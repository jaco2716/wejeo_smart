package dk.wejeo.wejeo_smart.TuyaLogic

import android.util.Log
import com.tuya.smart.android.device.api.IPropertyCallback
import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.home.sdk.builder.ActivatorBuilder
import com.tuya.smart.sdk.api.IResultCallback
import com.tuya.smart.sdk.api.ITuyaActivator
import com.tuya.smart.sdk.api.ITuyaActivatorGetToken
import com.tuya.smart.sdk.api.ITuyaSmartActivatorListener
import com.tuya.smart.sdk.bean.DeviceBean
import com.tuya.smart.sdk.enums.ActivatorModelEnum
import dk.wejeo.wejeo_smart.LocalDataHandler
import dk.wejeo.wejeo_smart.WejeoSmart.Companion.context
import io.flutter.plugin.common.MethodChannel


class TuyaDeviceHandler {

    lateinit var mTuyaActivator: ITuyaActivator
//    static let sharedInstance = TuyaDeviceHandler()
//    let tuyaSmartTimer: TuyaSmartTimer = TuyaSmartTimer()
//    var flutterResult: FlutterResult?
//    let tuyaActivator: TuyaSmartActivator
//    var smartDevice: TuyaSmartDevice?
//    public var eventSink: FlutterEventSink?
//    var connectingWifiSsid: String?
//
//    override
//    private init(){
//        self.tuyaActivator = TuyaSmartActivator.sharedInstance()
//        super.init()
//        if LocalDataHandler.currentDeviceId != nil {
//            self.smartDevice = TuyaSmartDevice(deviceId: LocalDataHandler.currentDeviceId!)
//            self.initDevice(deviceId: LocalDataHandler.currentDeviceId!)
//        }
//
//
//    }

    //--------------------------------------------------------------------------
    //Paring device
    fun startParing(
        result: MethodChannel.Result,
        homeId: Long,
        password: String,
        ssid: String,
        mode: Int
    ) {

//        connectingWifiSsid = ssid

        print("Started Paring device: homeId: $homeId, password: $password, ssid: $ssid")
        getToken(result, homeId, ssid, password, mode)
    }

    private fun getToken(
        result: MethodChannel.Result,
        homeId: Long,
        ssid: String,
        password: String,
        mode: Int
    ) {
        TuyaHomeSdk.getActivatorInstance().getActivatorToken(homeId,
            object : ITuyaActivatorGetToken {
                override fun onSuccess(token: String) {

                }

                override fun onFailure(code: String?, error: String?) {
                    result.error(code.toString(), error, "Failed to add home")
                }
            })

    }

    private fun startConfigWiFi(
        result: MethodChannel.Result,
        ssid: String,
        password: String,
        token: String,
        mode: Int
    ) {
        //TODO impliment mode

// Starts pairing.
        val builder = ActivatorBuilder()
            .setSsid(ssid)
            .setContext(context)
            .setPassword(password)
            .setActivatorModel(ActivatorModelEnum.TY_EZ)
            .setTimeOut(100)
            .setToken(token)
            .setListener(object : ITuyaSmartActivatorListener {
                override fun onStep(step: String?, data: Any?) {
                    Log.i("TuyaDeviceConfigEZ", "$step --> $data")
                }

                override fun onActiveSuccess(devResp: DeviceBean?) {

                    if (devResp != null) {

                        Log.i("TuyaDeviceConfigEZ", "Device paired!")

                        LocalDataHandler.currentDeviceId = devResp.devId
//                    self.initDevice(deviceId: devResp.devId)
                        result.success("Success:${devResp.devId}")
                    } else {
                        result.success("Failed to pair device.")
                    }
                }

                override fun onError(
                    code: String?,
                    error: String?
                ) {
                    result.error(code.toString(), error, "Failed to pair device.")
                }
            }
            )

        mTuyaActivator = TuyaHomeSdk.getActivatorInstance().newMultiActivator(builder)

        //Start configuration
        mTuyaActivator.start()


        Log.i("TuyaDeviceConfigEZ", "Config started with , ssid: $ssid, password: $password")
//        flutterResult = result
    }


    fun stopParing() {
        Log.i("TuyaDeviceConfigEZ","Stopping config")
        mTuyaActivator.stop()
    }


    //--------------------------------------------------------------------------
    //Handle devices

    fun setCurrentDevice(result: MethodChannel.Result, devId: String) {
        LocalDataHandler.currentDeviceId = devId;
//        self.initDevice(deviceId: devId)
        result.success(null)
    }

//    fun getCurrentHomeDeviceList(result: MethodChannel.Result) {
//        guard let currentHome = TuyaHomeHandler.sharedInstance.currentHome else{
//            result("nil home")
//            return
//        }
//
//        currentHome.getDataWithSuccess({
//            (home) in
//                    // The value of `homeId` for the home.
//
//                    guard let deviceList = currentHome.deviceList else {
//            print("Get Device failed")
//            result(nil)
//            return
//        }
//            print(deviceList)
//            let deviceDictList = deviceList . reduce (into: [[AnyHashable: Any]]()) {
//            array, value in
//            array.append(["name": value. name !,
//            "devId" : value.devId!,
//            "isOnline" : value.isOnline,
//            "dps" : value.dps!,
//            "deviceType" : value.deviceType.rawValue,
//            "homeId" : value.homeId,
//            "roomId" : value.roomId
//            ])
//        }
//
//            print(deviceDictList)
//            result(deviceDictList.toJSONString())
//
//        }, failure: {
//            error in
//                    print("Failed to get home data")
//            result(nil)
//        })
//
//    }

//
//    fun getDeviceProperties(result: MethodChannel.Result, deviceId: String) {
//        let deviceFromId = TuyaSmartDevice (deviceId: deviceId)
//        guard let device = deviceFromId else {
//            print("Failed to get device.")
//            result(nil)
//            return
//        }
//        LocalDataHandler.currentDeviceId = device.deviceModel.devId
//        self.initDevice(deviceId: device. deviceModel . devId)
//        self.smartDevice = device
//        self.smartDevice?.delegate = self
//        guard let schemaArray = device.deviceModel.schemaArray else{
//            print("Failed to get schemaArray.")
//            result(nil)
//            return
//        }
//
//
//
//        let schemaDictList = schemaArray . reduce (into: [[AnyHashable: Any]]()) {
//            array, value in
//            //            print("Property\(value.property.yy_modelToJSONString()!)")
//            array.append(["code": value. code !,
//            "name":value.name!,
//            "dpId" : value.dpId!,
//            "mode": value.mode!,
//            "type":value.type!,
//            "property": value.property.yy_modelToJSONString()!
//            ])
//        }
//        //        schemaDictList.append(["isOnline" : self.smartDevice?.deviceModel.isOnline ?? false])
//        result(schemaDictList.toJSONString())
//    }

    ///
    ///Set device Name
    ///
    fun modifyDeviceName(result: MethodChannel.Result,deviceId: String, name: String)
    {
        val deviceFromId = TuyaHomeSdk.newDeviceInstance(deviceId)
        deviceFromId.renameDevice(name, object : IResultCallback {
            override fun onError(code: String?, error: String?) {
                result.error(code.toString(), error, "Failed to login")
            }

           override fun onSuccess() {
               result.success("Success")
            }
        })

    }

    ///
    ///Set device Value (Only for bool atm.)
    ///
    fun setDeviceValue(result: MethodChannel.Result, deviceId: String, dpId: String) {

        val deviceFromId = TuyaHomeSdk.newDeviceInstance(deviceId)
        val deviceBean = TuyaHomeSdk.getDataInstance().getDeviceBean(deviceId)
        LocalDataHandler.currentDeviceId = deviceId
        //TODO
//        self.initDevice(deviceId: device. deviceModel . devId)

        if(deviceBean != null){
            val dps = deviceBean.dps[dpId] as Boolean? ?: false
            val newDps = {dpId to !dps}
            deviceFromId.publishDps(newDps.toString(), object : IResultCallback{
                override fun onError(code: String?, error: String?) {
                    result.error(code.toString(), error, "Failed to login")
                }

                override fun onSuccess() {
                    result.success(!dps)
                }
            })
        }
    }

//    fun readDeviceValues(result: MethodChannel.Result, deviceId: String) {
//        let deviceFromId = TuyaSmartDevice (deviceId: deviceId)
//        guard let device = deviceFromId,
//        let dps = device . deviceModel . dps else {
//            print("Failed to get device/dps.")
//            result(nil)
//            return
//        }
//        LocalDataHandler.currentDeviceId = device.deviceModel.devId
//        self.initDevice(deviceId: device. deviceModel . devId)
//        result(dps.toJSONString())
//        //        let valueDict = ["value": dps[dpId]]
//        //        result(valueDict.toJSONString())
//    }

    fun removeDevice(result: MethodChannel.Result, deviceId: String) {
        val deviceFromId = TuyaHomeSdk.newDeviceInstance(deviceId)
deviceFromId.removeDevice(object :IResultCallback{
    override fun onError(code: String?, error: String?) {
        result.error(code.toString(), error, "Failed to login")
    }

    override fun onSuccess() {
        LocalDataHandler.currentDeviceId = deviceId
        //TODO
//        self.initDevice(deviceId: device. deviceModel . devId)
        result.success("Success")
    }
})

    }
}