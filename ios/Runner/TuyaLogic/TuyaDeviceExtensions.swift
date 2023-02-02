//
//  TuyaDeviceExtensions.swift
//  Runner
//
//  Created by Jacob Welin - Wejeo on 31/01/2023.
//

import Foundation


extension TuyaDeviceHandler: TuyaSmartActivatorDelegate {
    
    func activator(_ activator: TuyaSmartActivator!, didReceiveDevice deviceModel: TuyaSmartDeviceModel!, error: Error!) {
        print("Paring update...")
        
        if deviceModel != nil && error == nil {
            print("Device paired!")
            print("name: \(deviceModel.name ?? "Null"), name: \(deviceModel.uiName ?? "Null"), ")
            LocalDataHandler.currentDeviceId = deviceModel.devId
            self.initDevice(deviceId: deviceModel.devId)
            self.returnDevicePairResult(message: "Success:\(deviceModel.devId ?? "Null")")
        }
        
        if let e = error {
            print("Failed to pair device!")
            print("\(e)")
            self.returnDevicePairResult(message: "Failed to pair device")
        }
        
    }
}

extension TuyaDeviceHandler: TuyaSmartDeviceDelegate {
    
    func initDevice(deviceId:String){
        self.smartDevice = TuyaSmartDevice(deviceId: deviceId)
        self.smartDevice?.delegate = self
    }
    
    
    func updateDeviceData(device: TuyaSmartDevice) -> String {
        let data: [AnyHashable : Any] = [
            "name": device.deviceModel.name!,
            "devId": device.deviceModel.devId!,
            "isOnline": device.deviceModel.isOnline,
            "isCloudOnline": device.deviceModel.isCloudOnline,
            "onlineType": device.deviceModel.onlineType.rawValue,
            "deviceType": device.deviceModel.deviceType.rawValue,
            "dps": device.deviceModel.dps.toJSONString(),
            "homeId": device.deviceModel.homeId,
            "roomId": device.deviceModel.roomId,
        ]
        return data.toJSONString()
    }
    
    func device(_ device: TuyaSmartDevice, dpsUpdate dps: [AnyHashable : Any]) {
        print("Device dpsUpdate!")
        guard let eventSink = self.eventSink else{
            return
        }
        eventSink(updateDeviceData(device: device))
    }
    
//    func deviceOnlineUpdate(_ device: TuyaSmartDevice) {
//        print("deviceOnlineUpdate")
//        guard let eventSink = self.eventSink else{
//            return
//        }
//        eventSink(updateDeviceData(device: device))
//    }
    
    func deviceInfoUpdate(_ device: TuyaSmartDevice) {
        print("deviceInfoUpdate")
        guard let eventSink = self.eventSink else{
            return
        }
        eventSink(updateDeviceData(device: device))
    }
    
}


extension TuyaDeviceHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("Device Stream started")
        
        self.eventSink = events
        guard let device = TuyaSmartDevice(deviceId: LocalDataHandler.currentDeviceId ?? "") else{
            print("Device Error: \(LocalDataHandler.currentDeviceId ?? "")")
            events(nil)
            return nil
        }
        
        let data: [AnyHashable : Any] = [
            "name": device.deviceModel.name!,
            "devId": device.deviceModel.devId!,
            "isOnline": device.deviceModel.isOnline,
            "isCloudOnline": device.deviceModel.isCloudOnline,
            "onlineType": device.deviceModel.onlineType.rawValue,
            "deviceType": device.deviceModel.deviceType.rawValue,
            "dps": device.deviceModel.dps.toJSONString(),
            "homeId": device.deviceModel.homeId,
            "roomId": device.deviceModel.roomId,
        ]
//        print(data.toJSONString())
        events(data.toJSONString())
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        print("Device Stream Canceled")
        return nil
    }
    
    
}
