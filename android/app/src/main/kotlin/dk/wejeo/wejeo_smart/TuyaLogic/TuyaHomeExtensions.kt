package dk.wejeo.wejeo_smart.TuyaLogic

import com.tuya.smart.home.sdk.TuyaHomeSdk
import dk.wejeo.wejeo_smart.LocalDataHandler
import io.flutter.plugin.common.EventChannel

class TuyaHomeExtensions : EventChannel.StreamHandler , TuyaHomeHandler() {




    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        print("Home Stream started")
        this.eventSink = events
        val currentHomeId = LocalDataHandler.currentHomeId
        if(currentHomeId == null){
            this.eventSink?.error("0", "No home id", "Could not get home id")
            return
        }
        val home = TuyaHomeSdk.newHomeInstance(currentHomeId)
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

    override fun onCancel(arguments: Any?) {
        self.eventSink = nil
        print("Home Stream Canceled")
        return nil
    }



}