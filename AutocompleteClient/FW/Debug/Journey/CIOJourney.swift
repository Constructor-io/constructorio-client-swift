//
//  CIOJourney.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/// A file of journey definitions. The same JSON format is shared with the Android SDK.
struct CIOJourneyFile: Decodable {

    static let supportedSchemaVersion = 1

    let schemaVersion: Int
    let fileVersion: String
    let journeys: [CIOJourney]
}

/// A predefined user flow: an ordered list of the tracking events it should fire
struct CIOJourney: Decodable {
    let id: String
    let name: String
    let description: String?
    let steps: [CIOJourneyStep]
}

struct CIOJourneyStep: Decodable {
    let id: String

    /// Shown to the developer, e.g. "Tap a product in the results"
    let instruction: String

    /// Raw value of a `CIOTrackingEventName`
    let event: String

    /// Optional constraint on the event's `type` parameter, so a step can target e.g. only add-to-cart conversions
    let conversionType: String?

    /// Position in the sequence. Steps with the same order can fire in either order among themselves. Without it,
    /// the step's position in the list is used, so the journey is strictly ordered.
    let order: Int?

    let params: [CIOJourneyParamRule]

    var eventName: CIOTrackingEventName? {
        return CIOTrackingEventName(rawValue: self.event)
    }

    private enum CodingKeys: String, CodingKey {
        case id, instruction, event, conversionType, order, params
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.instruction = try container.decode(String.self, forKey: .instruction)
        self.event = try container.decode(String.self, forKey: .event)
        self.conversionType = try container.decodeIfPresent(String.self, forKey: .conversionType)
        self.order = try container.decodeIfPresent(Int.self, forKey: .order)
        self.params = try container.decodeIfPresent([CIOJourneyParamRule].self, forKey: .params) ?? []
    }
}

/// A check on one parameter of a step's event. Parameters are named as they appear in the request: a query
/// parameter, a JSON body key, `term` for the search term in the URL path, or `items[].item_id` for array fields.
struct CIOJourneyParamRule: Decodable {

    struct StepReference: Decodable {
        let step: String
        let param: String
    }

    let name: String

    /// A missing or empty value is an error
    let required: Bool

    /// A missing or empty value is a warning
    let recommended: Bool

    /// The value must equal the named parameter of an earlier step
    let equals: StepReference?

    /// The value must be one of the values of the named parameter of an earlier step
    let `in`: StepReference?

    /// The values must include the named parameter of an earlier step, e.g. purchased items include the clicked item
    let contains: StepReference?

    /// The value must be a number at least this large
    let min: Double?

    /// Optional fix text shown when the rule fails
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case name, required, recommended, equals, `in`, contains, min, message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.required = try container.decodeIfPresent(Bool.self, forKey: .required) ?? false
        self.recommended = try container.decodeIfPresent(Bool.self, forKey: .recommended) ?? false
        self.equals = try container.decodeIfPresent(StepReference.self, forKey: .equals)
        self.in = try container.decodeIfPresent(StepReference.self, forKey: .in)
        self.contains = try container.decodeIfPresent(StepReference.self, forKey: .contains)
        self.min = try container.decodeIfPresent(Double.self, forKey: .min)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}
