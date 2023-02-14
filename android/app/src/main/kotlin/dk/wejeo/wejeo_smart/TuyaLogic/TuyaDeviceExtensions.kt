package dk.wejeo.wejeo_smart.TuyaLogic

import android.util.Log
import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.sdk.api.IDevListener
import dk.wejeo.wejeo_smart.LocalDataHandler
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject


class TuyaDeviceExtensions : EventChannel.StreamHandler, TuyaDeviceHandler() {
    val EVENT_LOG_TAG = "TuyaHomeEventStream"

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

        print("Device Stream started")

        this.eventSink = events
        val currentDevId = LocalDataHandler.currentDeviceId
        if (currentDevId == null) {
            this.eventSink?.error("0", "No device id", "Could not get device id")
            return
        }
        updateDeviceData(currentDevId)
        startDeviceListener(currentDevId)

    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
        Log.i(EVENT_LOG_TAG, "Device Stream Canceled")
    }

    private fun startDeviceListener(deviceId: String) {
        val mDevice = TuyaHomeSdk.newDeviceInstance(deviceId)
        mDevice.registerDevListener(object : IDevListener {
            override fun onDpUpdate(devId: String, dpStr: String) {
                Log.i(EVENT_LOG_TAG, "onDpUpdate")
            }
            override fun onRemoved(devId: String) {
                Log.i(EVENT_LOG_TAG, "onRemoved")
            }
            override fun onStatusChanged(devId: String, online: Boolean) {
                Log.i(EVENT_LOG_TAG, "onStatusChanged")
            }
            override fun onNetworkStatusChanged(devId: String, status: Boolean) {
                Log.i(EVENT_LOG_TAG, "onNetworkStatusChanged")
            }
            override fun onDevInfoUpdate(devId: String) {
                Log.i(EVENT_LOG_TAG, "onDevInfoUpdate")
            }
        })
    }

    private fun updateDeviceData(deviceId: String) {
        val device = TuyaHomeSdk.getDataInstance().getDeviceBean(deviceId)
        if (device == null) {
            this.eventSink?.error("0", "Device null", "Could not get device from id")
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