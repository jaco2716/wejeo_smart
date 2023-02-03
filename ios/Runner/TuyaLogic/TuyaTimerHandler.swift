//
//  TuyaDeviceHandler.swift
//  Runner
//
//  Created by Jacob Welin - Wejeo on 10/09/2022.
//

import Foundation
//
//  TuyaHandler.swift
//  Runner
//
//  Created by Jacob Welin - Wejeo on 05/09/2022.
//

import Foundation
import Flutter
import TuyaSmartBaseKit
import TuyaSmartActivatorKit
import YYModel
///
///Access Tuya platform functions
///
class TuyaTimerHandler : NSObject{
    
    static let sharedInstance = TuyaTimerHandler()
    let tuyaSmartTimer: TuyaSmartTimer = TuyaSmartTimer()
    public var eventSink: FlutterEventSink?
    
    override
    private init(){
        super.init()
    }
    
    public func getDeviceTimers(completion: @escaping (String) -> Void, failure: @escaping (Error?) -> Void) {
        
        guard let device = TuyaSmartDevice(deviceId: LocalDataHandler.currentDeviceId ?? "") else{
            print("Device Error: \(LocalDataHandler.currentDeviceId ?? "")")
            return
        }
        print("DevID: \(device.deviceModel.devId ?? "nil id")")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            
            self.tuyaSmartTimer.getTaskList(withBizId: device.deviceModel.devId,  bizType: 0, success: { (list) in
                
                guard let timerGroupList = list,
                      let firstGroup = timerGroupList.first,
                      let timerList = firstGroup.timers else {
                    print("Get first Timer failed")
                    completion("[]")
                    return
                }
                
                var timersData: [[AnyHashable : Any]] = []
                for time in timerList {
                    let tempTimersData: [AnyHashable : Any] = [
                        "timerId" : time.timerId!,
                        "aliasName" : time.aliasName!,
                        "date" : time.date!,
                        "dpsStatus" : time.dps["1"]!,
                        "loops" : time.loops!,
                        "status" : time.status,
                        "time" : time.time!,
                    ]
                    timersData.append(tempTimersData)
                }
                print("getDeviceTimers")
                print("\(timersData.toJSONString())")
                
                
                completion(timersData.toJSONString())
                
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
    
    public func addDeviceTimer(result:@escaping FlutterResult, deviceId: String, time: String, loops: String, dpsStatus: Bool) {
        let dps = ["1" : dpsStatus]
        
        self.tuyaSmartTimer.add(withTask: "timer_task_name", loops: loops, bizId: deviceId, bizType: 0, time: time, dps: dps, status: true, isAppPush: true, aliasName: "New timer") {
            let message = "Success"
            guard let eventSink = self.eventSink else{
                return
            }
            self.getDeviceTimers(completion: { (dataResult) in
                eventSink(dataResult)
            }, failure: { (error) in
                if let e = error?.localizedDescription {
                    eventSink(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
                } else{
                    return
                }
            })
            
            
            result(message)
        } failure: { (error) in
            if let e = error?.localizedDescription {
                result(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
            } else{
                result(nil)
            }
        }
    }
    
    
    public func updateTimerStatus(result:@escaping FlutterResult, deviceId: String, timerIds: [String], updateType: Int32) {
        
        self.tuyaSmartTimer.updateTimerStatus(withTimerIds: timerIds, bizId: deviceId, bizType: 0, updateType: updateType) {
            let message = "Success"
            guard let eventSink = self.eventSink else{
                return
            }
            
            self.getDeviceTimers(completion: { (dataResult) in
                eventSink(dataResult)
            }, failure: { (error) in
                if let e = error?.localizedDescription {
                    eventSink(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
                } else{
                    return
                }
            })
            result(message)
        } failure: { (error) in
            if let e = error?.localizedDescription {
                result(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
            } else{
                result(nil)
            }
        }
    }
}
