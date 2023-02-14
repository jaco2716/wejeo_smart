package dk.wejeo.wejeo_smart.TuyaLogic

import android.util.Log
import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.home.sdk.api.ITuyaHomeChangeListener
import com.tuya.smart.home.sdk.bean.HomeBean
import com.tuya.smart.home.sdk.callback.ITuyaHomeResultCallback
import com.tuya.smart.sdk.bean.DeviceBean
import com.tuya.smart.sdk.bean.GroupBean
import dk.wejeo.wejeo_smart.LocalDataHandler
import io.flutter.plugin.common.EventChannel
import org.json.JSONArray
import org.json.JSONObject


class TuyaHomeExtensions : EventChannel.StreamHandler, TuyaHomeHandler() {
    val LOG_TAG = "TuyaHomeEventStream"

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.i(LOG_TAG,"Home Stream started")
        this.eventSink = events
        val currentHomeId = LocalDataHandler.currentHomeId
        if (currentHomeId == null) {
            this.eventSink?.error("0", "No home id", "Could not get home id")
            return
        }
        updateHomeData(currentHomeId)
        startHomeListener()
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
        Log.i(LOG_TAG, "Home Stream Canceled")

    }


    private fun startHomeListener() {

        val listener: ITuyaHomeChangeListener = object : ITuyaHomeChangeListener {
            override fun onHomeInvite(homeId: Long, homeName: String) {
                // do something
            }

            override fun onHomeRemoved(homeId: Long) {
                // do something
            }

            override fun onHomeInfoChanged(homeId: Long) {
                Log.i(LOG_TAG, "onHomeInfoChanged")
                updateHomeData(homeId)
            }

            override fun onSharedDeviceList(sharedDeviceList: List<DeviceBean?>?) {
                // do something
                Log.i(LOG_TAG, "onSharedDeviceList")
            }

            override fun onSharedGroupList(sharedGroupList: List<GroupBean>) {
                // do something
                Log.i(LOG_TAG, "onSharedGroupList")
            }

            override fun onServerConnectSuccess() {
                // do something
                Log.i(LOG_TAG, "onServerConnectSuccess")
            }

            override fun onHomeAdded(homeId: Long) {
                // do something
                Log.i(LOG_TAG, "onHomeAdded")
            }
        }
        // Registers a listener.
        TuyaHomeSdk.getHomeManagerInstance().registerTuyaHomeChangeListener(listener)
    }


    private fun updateHomeData(homeId:Long){
        val home = TuyaHomeSdk.newHomeInstance(homeId)

        home.getHomeDetail(object : ITuyaHomeResultCallback {
            override fun onSuccess(bean: HomeBean?) {
                val deviceList = bean?.deviceList
                var devicesListMap = mutableListOf<Map<String, Any?>>()
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
                    eventSink?.success(jsArray.toString())
                }
            }

            override fun onError(code: String?, error: String?) {
                eventSink?.error(code, error,"Error getting home details")

            }
        })
    }


}