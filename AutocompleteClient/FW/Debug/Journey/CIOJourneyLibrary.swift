//
//  CIOJourneyLibrary.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/// Loads the journey file from `ConstructorIOConfig.debugJourneysURL`. Main thread only.
final class CIOJourneyLibrary {

    static let shared = CIOJourneyLibrary()

    static let didChangeNotification = Notification.Name("CIOJourneyLibraryDidChange")

    enum State {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    var url: URL?
    private(set) var journeys: [CIOJourney] = []
    private(set) var fileVersion: String?
    private(set) var state: State = .idle

    var isLoading: Bool {
        if case .loading = self.state { return true }
        return false
    }

    /// Loads the journey file again, so edits show up without restarting the app
    func refresh() {
        guard !self.isLoading else { return }
        guard let url = self.url else {
            self.journeys = []
            self.fileVersion = nil
            self.state = .failed("No journey file is set. Pass debugJourneysURL in ConstructorIOConfig.")
            self.notifyChange()
            return
        }

        self.state = .loading
        self.notifyChange()
        print(Constants.Logging.debugMessage("Loading journeys from \(url.absoluteString)"))

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result: Result<CIOJourneyFile, Error>
            if let error = error {
                result = .failure(error)
            } else if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                result = .failure(CIOJourneyLibraryError.httpStatus(http.statusCode))
            } else if let data = data {
                result = Result { try CIOJourneyLibrary.decode(data) }
            } else {
                result = .failure(CIOJourneyLibraryError.emptyResponse)
            }

            DispatchQueue.main.async {
                self.finishRefresh(result)
            }
        }.resume()
    }

    static func decode(_ data: Data) throws -> CIOJourneyFile {
        let file = try JSONDecoder().decode(CIOJourneyFile.self, from: data)
        guard file.schemaVersion == CIOJourneyFile.supportedSchemaVersion else {
            throw CIOJourneyLibraryError.unsupportedSchemaVersion(file.schemaVersion)
        }
        return file
    }

    private func finishRefresh(_ result: Result<CIOJourneyFile, Error>) {
        switch result {
        case .success(let file):
            self.journeys = file.journeys
            self.fileVersion = file.fileVersion
            self.state = .loaded
            print(Constants.Logging.debugMessage("Journeys loaded · file \(file.fileVersion) · \(file.journeys.count) journey\(file.journeys.count == 1 ? "" : "s")"))
        case .failure(let error):
            let reason = CIOJourneyLibrary.describe(error)
            self.journeys = []
            self.fileVersion = nil
            self.state = .failed(reason)
            print(Constants.Logging.debugMessage("Couldn't load journeys: \(reason)"))
        }
        self.notifyChange()
    }

    private func notifyChange() {
        NotificationCenter.default.post(name: CIOJourneyLibrary.didChangeNotification, object: self)
    }

    private static func describe(_ error: Error) -> String {
        switch error {
        case CIOJourneyLibraryError.httpStatus(let code):
            return "HTTP \(code)"
        case CIOJourneyLibraryError.unsupportedSchemaVersion(let version):
            return "unsupported schema version \(version)"
        case CIOJourneyLibraryError.emptyResponse:
            return "empty response"
        case is DecodingError:
            return "the file isn't valid journey JSON"
        default:
            return error.localizedDescription
        }
    }
}

enum CIOJourneyLibraryError: Error {
    case unsupportedSchemaVersion(Int)
    case httpStatus(Int)
    case emptyResponse
}
