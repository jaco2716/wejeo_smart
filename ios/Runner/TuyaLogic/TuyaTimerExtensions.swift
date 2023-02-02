//
//  TuyaTimerExtensions.swift
//  Runner
//
//  Created by Jacob Welin - Wejeo on 02/02/2023.
//

import Foundation

extension TuyaTimerHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("Timer Stream started")
        
        self.eventSink = events
        guard let device = TuyaSmartDevice(deviceId: LocalDataHandler.currentDeviceId ?? "") else{
            print("Device Error: \(LocalDataHandler.currentDeviceId ?? "")")
            events(nil)
            return nil
        }
        
        events(self.getDeviceTimers())
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        print("Timer Stream Canceled")
        return nil
    }
    
    
}
