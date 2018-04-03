//
//  DeviceUserIDGenerator.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 3/13/18.
//  Copyright © 2018 xd. All rights reserved.
//

import UIKit

class DeviceUserIDGenerator: UserIDGenerator {

    func generateUserID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
}
