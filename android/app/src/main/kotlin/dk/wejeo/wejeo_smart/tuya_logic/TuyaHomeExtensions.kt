package dk.wejeo.wejeo_smart.tuya_logic

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.home.sdk.api.*
import com.tuya.smart.home.sdk.bean.HomeBean
import com.tuya.smart.home.sdk.callback.ITuyaHomeResultCallback
import dk.wejeo.wejeo_smart.LocalDataHandler
import io.flutter.plugin.common.EventChannel
import java.util.*
import kotlin.concurrent.schedule


class TuyaHomeExtensions : EventChannel.StreamHandler, TuyaHomeHandler() {
//    private lateinit var mHome: ITuyaHome
//    companion object {
////        private var mHome: ITuyaHome? = null
//
//    }


//        fun updateHomeData() {
//            if (mHome?.homeBean == null) {
//                return
//            } else {
//                val dataString = homeDataToJson(mHome?.homeBean)
//                eventSink?.success(dataString)
//            }
//
//        }
//
//        private fun homeDataToJson(bean: HomeBean?): String {
//            val deviceList = bean?.deviceList
//            val devicesListMap = mutableListOf<Map<String, Any?>>()
//            if (deviceList != null) {
//                for (device in deviceList) {
//
//                    val data: Map<String, Any?> =
//                        mapOf(
//                            "name" to device.name,
//                            "devId" to device.devId,
//                            "isOnline" to device.isOnline,
//                            "isCloudOnline" to device.isCloudOnline,
//                            "onlineType" to 0,
//                            "deviceType" to 0,
//                            "dps" to JSONObject(device.dps).toString(),
//                            "homeId" to 0,
//                            "roomId" to 0,
//                        )
//                    devicesListMap.add(data)
//                }
//                val jsArray = JSONArray(devicesListMap)
//                return jsArray.toString()
//            } else {
//                return "[]"
//            }
//        }

//    private val listener = object : ITuyaHomeDeviceStatusListener {
//
//        override fun onDeviceInfoUpdate(devId: String?) {
//            Log.i(LOG_TAG, "onDeviceInfoUpdate")
//        }
//
//        override fun onDeviceDpUpdate(devId: String?, dpStr: String?) {
//            Log.i(LOG_TAG, "onDeviceDpUpdate")
//            updateHomeData()
//        }
//
//        override fun onDeviceStatusChanged(devId: String?, online: Boolean) {
//            Log.i(LOG_TAG, "onDeviceStatusChanged")
//        }
//    }


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.i(LOG_TAG, "Home Stream started")
        eventSink = events
        val currentHomeId = LocalDataHandler.currentHomeId
        if (currentHomeId == null) {
            Log.i(LOG_TAG, "currentHomeId null")
            eventSink?.error("0", "No home id", "Could not get home id")
            return
        }
        mHome = TuyaHomeSdk.newHomeInstance(currentHomeId)
        Log.i(LOG_TAG, "currentHomeId: $currentHomeId")
        mHome?.getHomeDetail(object : ITuyaHomeResultCallback {
            override fun onSuccess(bean: HomeBean?) {
                val dataString = homeDataToJson(bean)
                Log.i(LOG_TAG, "getHomeDetail onSuccess")
                Log.i(LOG_TAG, "registerHomeDeviceStatusListener")
//                mHome?.registerHomeDeviceStatusListener(listener)
                updateStreamLoop()
                eventSink?.success(dataString)
            }

            override fun onError(code: String?, error: String?) {
                eventSink?.error(code, error, "Error getting home details")
            }
        })
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
//        mHome?.unRegisterHomeDeviceStatusListener(listener)
//        Log.i(LOG_TAG, "unRegister home device Listener")
//        Log.i(LOG_TAG, "Home Stream Canceled")

    }

    fun updateStreamLoop() {
        if (eventSink != null) {
                Timer().schedule(8000) {
                    updateHomeData()
                    updateStreamLoop()
                }
        }
    }


}