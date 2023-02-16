package dk.wejeo.wejeo_smart.tuya_logic

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.home.sdk.api.ITuyaHome
import com.tuya.smart.home.sdk.bean.HomeBean
import com.tuya.smart.home.sdk.callback.ITuyaGetHomeListCallback
import com.tuya.smart.home.sdk.callback.ITuyaHomeResultCallback
import com.tuya.smart.sdk.api.IResultCallback
import dk.wejeo.wejeo_smart.LocalDataHandler
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.util.*
import kotlin.concurrent.schedule


open class TuyaHomeHandler {
    val LOG_TAG = "HomeConfig_#JW"

    companion object {
        var eventSink: EventChannel.EventSink? = null
        private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())

        //        var currentHome: HomeBean? = null
        var mHome: ITuyaHome? = null

        fun updateHomeData() {
            if (mHome?.homeBean == null) {
                return
            } else {
                val dataString = homeDataToJson(mHome?.homeBean)
                uiThreadHandler.post {
                    eventSink?.success(dataString)
                }
            }

        }

        fun homeDataToJson(bean: HomeBean?): String {
            val deviceList = bean?.deviceList
            val devicesListMap = mutableListOf<Map<String, Any?>>()
            if (deviceList != null) {
                for (device in deviceList) {

                    val data: Map<String, Any?> =
                        mapOf(
                            "name" to device.name,
                            "devId" to device.devId,
                            "isOnline" to device.isOnline,
                            "isCloudOnline" to device.isCloudOnline,
                            "onlineType" to 0,
                            "deviceType" to 0,
                            "dps" to JSONObject(device.dps).toString(),
                            "homeId" to 0,
                            "roomId" to 0,
                        )
                    devicesListMap.add(data)
                }
                val jsArray = JSONArray(devicesListMap)
                return jsArray.toString()
            } else {
                return "[]"
            }
        }
    }
//    static let sharedInstance = TuyaHomeHandler()

//    val homeManager: TuyaSmartHomeManager
//    val tuyaActivator: TuyaSmartActivator
//    var currentHome: TuyaSmartHome?
//    var flutterResult: FlutterResult?
//    var smartDevice :TuyaSmartDevice?

//    override
//    private init(){
//        self.homeManager = TuyaSmartHomeManager()
//        self.tuyaActivator = TuyaSmartActivator.sharedInstance()
//        super.init()
//        if LocalDataHandler.currentHomeId != nil {
//            self.currentHome = TuyaSmartHome(homeId: LocalDataHandler.currentHomeId!)
//            self.initHome(homeId: LocalDataHandler.currentHomeId!)
//        }
//
//    }

    ///
    ///Create a home
    ///
    fun addHome(
        result: MethodChannel.Result,
        homeName: String,
        geoName: String,
        roomName: String,
        lat: Double,
        lon: Double
    ) {
        TuyaHomeSdk.getHomeManagerInstance()
            .createHome(
                homeName,
                lon,
                lat,
                geoName,
                listOf(roomName),
                object : ITuyaHomeResultCallback {
                    override fun onError(code: String?, error: String?) {
                        result.error(code.toString(), error, "Failed to add home")
                    }

                    override fun onSuccess(bean: HomeBean) {
                        LocalDataHandler.currentHomeId = bean.homeId
                        //TODO self.initHome(homeId: homeId)
                        result.success(bean.homeId)
                    }
                })
    }

    fun removeHome(result: MethodChannel.Result, homeId: Long) {

        TuyaHomeSdk.newHomeInstance(homeId).dismissHome(object : IResultCallback {
            override fun onSuccess() {
                // do something
                result.success("Success")
            }

            override fun onError(code: String?, error: String?) {
                result.error(code.toString(), error, "Failed to remove home")
            }
        })
    }


    ///
    ///Get list of homes
    ///
    fun getHomeList(result: MethodChannel.Result) {
        TuyaHomeSdk.getHomeManagerInstance().queryHomeList(object : ITuyaGetHomeListCallback {
            override fun onSuccess(homeBeans: List<HomeBean>) {
                // do something
                if (homeBeans.isEmpty()) {
                    result.success(null)
                    return
                }
                var firstID = homeBeans.first().homeId
                LocalDataHandler.currentHomeId = firstID

                //TODO
//                self.currentHome = TuyaSmartHome(homeId: firstID)
//                self.initHome(homeId: firstID)

                var homeDictList: List<Map<String, Any?>> = homeBeans.map {
                    mapOf(
                        "name" to it.name,
                        "homeId" to it.homeId,
                        "geoName" to it.geoName,
                        "lat" to it.lat,
                        "lon" to it.lon
                    )
                }
                val jsArray = JSONArray(homeDictList)
                Log.i(LOG_TAG, "homedata: $jsArray")
                result.success(jsArray.toString())
            }

            override fun onError(code: String?, error: String?) {
                result.error(code.toString(), error, "Failed to get home list")
            }
        })

    }


    fun setCurrentHome(result: MethodChannel.Result, homeId: Long) {
        LocalDataHandler.currentHomeId = homeId;
        //TODO
//        self.initHome(homeId: homeId)
        result.success(null)
    }

    fun getCurrentHome(result: MethodChannel.Result) {
        val homeId = LocalDataHandler.currentHomeId
        if (homeId == null) {
            result.success(0)
            return
        }
        result.success(homeId)
    }

    fun updateHomeData(result: MethodChannel.Result) {
        updateHomeData()
        result.success(null)
    }
}