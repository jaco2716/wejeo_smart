package dk.wejeo.wejeo_smart.tuya_logic
import android.util.Log
import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.home.sdk.api.ITuyaHome
import com.tuya.smart.home.sdk.api.ITuyaHomeChangeListener
import com.tuya.smart.home.sdk.api.ITuyaHomeDeviceStatusListener
import com.tuya.smart.home.sdk.bean.HomeBean
import com.tuya.smart.home.sdk.callback.ITuyaHomeResultCallback
import com.tuya.smart.sdk.bean.DeviceBean
import com.tuya.smart.sdk.bean.GroupBean
import dk.wejeo.wejeo_smart.LocalDataHandler
import io.flutter.plugin.common.EventChannel
import org.json.JSONArray
import org.json.JSONObject


class TuyaHomeExtensions : EventChannel.StreamHandler, TuyaHomeHandler() {
    val LOG_TAG = "HomeEvent_#JW"
    private lateinit var mHome: ITuyaHome

    private val listener = object : ITuyaHomeDeviceStatusListener {
        override fun onDeviceInfoUpdate(devId: String?) {
            Log.i(LOG_TAG, "onDeviceInfoUpdate")
            updateHomeWithLocalId()
        }
        override fun onDeviceStatusChanged(devId: String?, online: Boolean) {
            Log.i(LOG_TAG, "onDeviceStatusChanged")
        }
        override fun onDeviceDpUpdate(devId: String?, dpStr: String?) {
            Log.i(LOG_TAG, "onDeviceDpUpdate")
            updateHomeWithLocalId()
        }
    }


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.i(LOG_TAG, "Home Stream started")
        eventSink = events
        val currentHomeId = LocalDataHandler.currentHomeId
        if (currentHomeId == null) {
            eventSink?.error("0", "No home id", "Could not get home id")
            return
        }
        updateHomeData(currentHomeId)
        startHomeListener(currentHomeId)
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        if (this::mHome.isInitialized) {
//            mHome.unRegisterHomeDeviceStatusListener(listener)
            Log.i(LOG_TAG, "unRegister home device Listener")

        }
        Log.i(LOG_TAG, "Home Stream Canceled")

    }

    private fun startHomeListener(homeId: Long) {
        // Registers a listener.
        mHome = TuyaHomeSdk.newHomeInstance(homeId)
        mHome.registerHomeDeviceStatusListener(listener)

        TuyaHomeSdk.getHomeManagerInstance().registerTuyaHomeChangeListener(object : ITuyaHomeChangeListener{
            override fun onHomeAdded(homeId: Long) {
                Log.i(LOG_TAG, "onHomeAdded")
            }
            override fun onHomeInfoChanged(homeId: Long) {
                Log.i(LOG_TAG, "onHomeInfoChanged")
            }
            override fun onSharedDeviceList(sharedDeviceList: MutableList<DeviceBean>?) {
                Log.i(LOG_TAG, "onSharedDeviceList")
            }
            override fun onSharedGroupList(sharedGroupList: MutableList<GroupBean>?) {
                Log.i(LOG_TAG, "onSharedGroupList")
            }
            override fun onHomeRemoved(homeId: Long) {
                Log.i(LOG_TAG, "onHomeRemoved")
            }
            override fun onHomeInvite(homeId: Long, homeName: String?) {
                Log.i(LOG_TAG, "onHomeInvite")
            }
            override fun onServerConnectSuccess() {
                Log.i(LOG_TAG, "onServerConnectSuccess")
            }
        })

    }

    private fun updateHomeWithLocalId(){
        val currentHomeId = LocalDataHandler.currentHomeId
        if (currentHomeId == null) {
            eventSink?.error("0", "No home id", "Could not get home id")
            return
        }
        updateHomeData(currentHomeId)
    }


    private fun updateHomeData(homeId: Long) {
        val home = TuyaHomeSdk.newHomeInstance(homeId)

        home.getHomeDetail(object : ITuyaHomeResultCallback {
            override fun onSuccess(bean: HomeBean?) {
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
                    eventSink?.success(jsArray.toString())
                }
            }

            override fun onError(code: String?, error: String?) {
                eventSink?.error(code, error, "Error getting home details")

            }
        })
    }


}