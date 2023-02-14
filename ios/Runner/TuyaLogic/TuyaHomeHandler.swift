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
///
///Access Tuya platform functions
///
class TuyaHomeHandler : NSObject{
    
    static let sharedInstance = TuyaHomeHandler()
    
    let homeManager: TuyaSmartHomeManager
    let tuyaActivator: TuyaSmartActivator
    var currentHome: TuyaSmartHome?
    var flutterResult: FlutterResult?
    var smartDevice :TuyaSmartDevice?
    public var eventSink: FlutterEventSink?
    
    override
    private init(){
        self.homeManager = TuyaSmartHomeManager()
        self.tuyaActivator = TuyaSmartActivator.sharedInstance()
        super.init()
        if LocalDataHandler.currentHomeId != nil {
            self.currentHome = TuyaSmartHome(homeId: LocalDataHandler.currentHomeId!)
            self.initHome(homeId: LocalDataHandler.currentHomeId!)
        }
        
    }
    
    ///
    ///Create a home
    ///
    public func addHome(result:@escaping FlutterResult, homeName: String, geoName: String, roomName: String, lat: Double, lon: Double) {
        
        self.homeManager.addHome(withName: homeName,
                                 geoName: geoName,
                                 rooms: [roomName],
                                 latitude: lat,
                                 longitude: lon,
                                 success: { (homeId) in
            LocalDataHandler.currentHomeId = homeId
            self.initHome(homeId: homeId)
            result(homeId)
        }) { (error) in
            if let e = error {
                result(FlutterError.init(code: " tuyaFailureError", message: "Add home failed: \(e)", details: nil))
            }
        }
    }
    public func removeHome(result:@escaping FlutterResult, homeId: Int64) {
        guard let homeWithID = TuyaSmartHome(homeId: homeId) else{
            result(nil)
            return
        }
        homeWithID.dismiss(success: {
            let message = "Success"
            result(message)
        }) { (error) in
            if let e = error {
                result(FlutterError.init(code: " tuyaFailureError", message: "Remove home failed: \(e)", details: nil))
            }
        }
    }
    
    ///
    ///Get list of homes
    ///
    public func getHomeList(result:@escaping FlutterResult) {
        
        
        self.homeManager.getHomeList(success: { (homes) in
            
            guard let myHomes = homes else{
                result(nil)
                print("nil Homes")
                return
            }
            
            if LocalDataHandler.currentHomeId == nil {
                guard let firstID = myHomes.first?.homeId else{
                    result(nil)
                    return
                }
                print("firstID:")
                print(firstID)
                LocalDataHandler.currentHomeId = firstID
                self.currentHome = TuyaSmartHome(homeId: firstID)
                self.initHome(homeId: firstID)
            }
            
            let sortedHomes = myHomes.sorted { $1.homeId == self.currentHome?.homeModel.homeId ? false : $0.homeId == self.currentHome?.homeModel.homeId ? true : $0.homeId < $1.homeId }
            
            let homeDictList = sortedHomes.reduce(into: [[AnyHashable: Any]]()) { array, value in
                array.append(["name": value.name!, "homeId" : value.homeId, "geoName" : value.geoName!, "lat" : value.latitude, "lon" : value.longitude])
            }
            
            result(homeDictList.toJSONString())
        }) { (error) in
            if let e = error {
                result(FlutterError.init(code: " tuyaFailureError", message: "Get home list failed: \(e)", details: nil))
            }
        }
    }
    
    
    public func setCurrentHome(result:@escaping FlutterResult, homeId:Int64) {
        LocalDataHandler.currentHomeId = homeId;
        self.initHome(homeId: homeId)
        result(nil)
    }
    
    public func getCurrentHome(result:@escaping FlutterResult) {
        
        print(LocalDataHandler.currentHomeId ?? "null home")
        guard let homeID = LocalDataHandler.currentHomeId else{
            print("currentHome nil")
            result(0)
            return
        }
        result(homeID)
    }
    
}

