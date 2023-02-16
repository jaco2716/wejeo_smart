package dk.wejeo.wejeo_smart.tuya_logic

import android.util.Log
import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.sdk.api.IDevListener
import com.tuya.smart.sdk.api.ITuyaDevice
import dk.wejeo.wejeo_smart.LocalDataHandler
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject


class TuyaDeviceExtensions : EventChannel.StreamHandler, TuyaDeviceHandler() {
    val EVENT_LOG_TAG = "DeviceEvent_#JW"
    lateinit var mDevice:ITuyaDevice
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

        print("Device Stream started")

        eventSink = events
        val currentDevId = LocalDataHandler.currentDeviceId
        if (currentDevId == null) {
            eventSink?.error("0", "No device id", "Could not get device id")
            return
        }
        currentDevice = TuyaHomeSdk.getDataInstance().getDeviceBean(currentDevId)
        mDevice = TuyaHomeSdk.newDeviceInstance(currentDevId)
        updateDeviceData()
        startDeviceListener()

    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        if (this::mDevice.isInitialized) {
            mDevice.unRegisterDevListener()
            Log.i(LOG_TAG, "unRegister device Listener")
        }
        Log.i(EVENT_LOG_TAG, "Device Stream Canceled")
    }

    private fun startDeviceListener() {

        mDevice.registerDevListener(object : IDevListener {
            override fun onDpUpdate(devId: String, dpStr: String) {
                Log.i(EVENT_LOG_TAG, "onDpUpdate")
                updateDeviceData()
            }

            override fun onRemoved(devId: String) {
                Log.i(EVENT_LOG_TAG, "onRemoved")
            }

            override fun onStatusChanged(devId: String, online: Boolean) {
                Log.i(EVENT_LOG_TAG, "onStatusChanged")
                updateDeviceData()
            }

            override fun onNetworkStatusChanged(devId: String, status: Boolean) {
                Log.i(EVENT_LOG_TAG, "onNetworkStatusChanged")
            }

            override fun onDevInfoUpdate(devId: String) {
                Log.i(EVENT_LOG_TAG, "onDevInfoUpdate")
                currentDevice?.getName()
                updateDeviceData()

            }
        })
    }

    private fun updateDeviceData() {
        val device = currentDevice
        if (device == null) {
            eventSink?.error("0", "Device null", "Could not get device from id")
            return
        }
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
        val jsData = JSONObject(data)
        eventSink?.success(jsData.toString())
    }

}