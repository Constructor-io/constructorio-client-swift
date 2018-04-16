//
//  DeviceUserIDGenerator.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class DeviceUserIDGenerator: UserIDGenerator {

    func generateUserID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
}
