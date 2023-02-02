//
//  LocalDataHandler.swift
//  Runner
//
//  Created by Jacob Welin - Wejeo on 10/09/2022.
//

import Foundation
import TuyaSmartDeviceKit

struct LocalDataHandler {
    static var currentHomeId: Int64? {
        get {
            let defaults = UserDefaults.standard
            guard let homeID = defaults.string(forKey: "CurrentHomeId") else { return nil }
            guard let id = Int64(homeID)  else {
                print("Failed getting homeId")
                return nil
            }
            print("Getting homeId = \(id)")
            return  id
        }
        set {
            let defaults = UserDefaults.standard
            print("Setting homeId = \(newValue ?? 0)")
            defaults.setValue(newValue, forKey: "CurrentHomeId")
        }
    }
    
    static var currentDeviceId: String? {
        get {
            let defaults = UserDefaults.standard
            guard let deviceId = defaults.string(forKey: "CurrentDeviceId") else { return nil }
            return  deviceId
        }
        set {
            let defaults = UserDefaults.standard
            print("Setting deviceId = \(newValue ?? "Null")")
            defaults.setValue(newValue, forKey: "CurrentDeviceId")
        }
    }
}
