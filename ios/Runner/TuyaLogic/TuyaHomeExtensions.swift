//
//  TuyaHomeExtensions.swift
//  Runner
//
//  Created by Jacob Welin - Wejeo on 31/01/2023.
//

import Foundation

extension TuyaHomeHandler: TuyaSmartHomeDelegate {
    
    func initHome(homeId:Int64) {
        self.currentHome = TuyaSmartHome(homeId: homeId)
        self.currentHome?.delegate = self
    }
    
    func updateDeviceData(home: TuyaSmartHome!, device: TuyaSmartDeviceModel!) -> String {
        var devicesDps: [[AnyHashable : Any]] = []
        
        for device in home.deviceList {
            let data: [AnyHashable : Any] = [
                "name": device.name!,
                "devId": device.devId!,
                "isOnline": device.isOnline,
                "isCloudOnline": device.isCloudOnline,
                "onlineType": device.onlineType.rawValue,
                "deviceType": device.deviceType.rawValue,
                "dps": device.dps.toJSONString(),
                "homeId": device.homeId,
                "roomId": device.roomId,
            ]
            devicesDps.append(data)
        }
//        print(devicesDps.toJSONString())
        return devicesDps.toJSONString()
    }
    
    // Home information such as a home name is changed.
    func homeDidUpdateInfo(_ home: TuyaSmartHome!) {
        //        reload()
        print("Home info update...")
    }
    
    // The list of shared devices is updated.
    func homeDidUpdateSharedInfo(_ home: TuyaSmartHome!) {
        print("Home shared info update...")
    }
    
    // A room is added to the home.
    func home(_ home: TuyaSmartHome!, didAddRoom room: TuyaSmartRoomModel!) {
        //...
        print("Home room added ...")
    }
    
    // A room is removed from the home.
    private func home(_ home: TuyaSmartHome!, didRemoveRoom roomId: Int32!) {
        //...
        print("Home room removed...")
    }
    
    // Room information such as a room name is changed.
    func home(_ home: TuyaSmartHome!, roomInfoUpdate room: TuyaSmartRoomModel!) {
        //        reload()/
        print("Home room info update...")
    }
    
    // The mappings between rooms and devices or groups are updated.
    func home(_ home: TuyaSmartHome!, roomRelationUpdate room: TuyaSmartRoomModel!) {
        print("Home room relation update...")
    }
    
    // A device is added.
    func home(_ home: TuyaSmartHome!, didAddDeivice device: TuyaSmartDeviceModel!) {
        print("Home device added...")
    }
    
    // A device is removed.
    func home(_ home: TuyaSmartHome!, didRemoveDeivice devId: String!) {
        print("Home device removed...")
    }
    
    // Device information such as a device name is changed.
    func home(_ home: TuyaSmartHome!, deviceInfoUpdate device: TuyaSmartDeviceModel!) {
        print("Home device info update...")
        
        guard let eventSink = self.eventSink else{
            return
        }
        let jsonData = updateDeviceData(home: home, device: device)
        eventSink(jsonData)
    }
    
    // Device DPs are updated for the home.
    func home(_ home: TuyaSmartHome!, device: TuyaSmartDeviceModel!, dpsUpdate dps: [AnyHashable : Any]!) {
        
        print("Home device DP update...")
        
        guard let eventSink = self.eventSink else{
            return
        }
        let jsonData = updateDeviceData(home: home, device: device)
        eventSink(jsonData)
    }
    
    // A group is added.
    func home(_ home: TuyaSmartHome!, didAddGroup group: TuyaSmartGroupModel!) {
        print("Home group added...")
    }
    
    // A group is removed.
    func home(_ home: TuyaSmartHome!, didRemoveGroup groupId: String!) {
        print("Home remove group...")
    }
    
    // Group information such as a group name is changed.
    func home(_ home: TuyaSmartHome!, groupInfoUpdate group: TuyaSmartGroupModel!) {
        print("Home group info update ...")
    }
    
    // Group DPs are updated for the home.
    func home(_ home: TuyaSmartHome!, group: TuyaSmartGroupModel!, dpsUpdate dps: [AnyHashable : Any]!) {
        //...
        print("Home group DP update...")
    }
    
    // Device alerts are updated for the home.
    func home(_ home: TuyaSmartHome!, device: TuyaSmartDeviceModel!, warningInfoUpdate warningInfo: [AnyHashable : Any]!) {
        //...
        print("Home device alerts update...")
    }
    
    // Device update status is changed for the home.
    func home(_ home: TuyaSmartHome!, device: TuyaSmartDeviceModel!, upgradeStatus status: TuyaSmartDeviceUpgradeStatus) {
        //....
        print("Home device update status...")
    }
    
}



extension TuyaHomeHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("Home Stream started")
        self.eventSink = events
        guard let home = self.currentHome else{
            print("Home Error: \(self.currentHome?.homeModel.homeId ?? 0)")
            events(FlutterError.init(code: " tuyaFailureError", message: "Get home list failed", details: nil))
            return nil
        }
        
        home.getDataWithSuccess({ (homeModel) in
            print("got home success \(homeModel?.geoName ?? "nil")")
            var devicesDps: [[AnyHashable : Any]] = []
            for device in home.deviceList {
                let data: [AnyHashable : Any] = [
                    "name": device.name!,
                    "devId": device.devId!,
                    "isOnline": device.isOnline,
                    "isCloudOnline": device.isCloudOnline,
                    "onlineType": device.onlineType.rawValue,
                    "deviceType": device.deviceType.rawValue,
                    "dps": device.dps.toJSONString(),
                    "homeId": device.homeId,
                    "roomId": device.roomId,
                ]
                devicesDps.append(data)
            }
            
    //        print("Stream Data:\(devicesDps.toJSONString())")
            events(devicesDps.toJSONString())
        }, failure: { (error) in
            if let e = error?.localizedDescription {
                events(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
            } else{
                return
            }
        })

        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        print("Home Stream Canceled")
        return nil
    }
    
    
}
