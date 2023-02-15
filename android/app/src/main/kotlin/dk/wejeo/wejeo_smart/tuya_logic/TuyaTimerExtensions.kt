package dk.wejeo.wejeo_smart.tuya_logic

import android.util.Log
import dk.wejeo.wejeo_smart.TuyaLogic.TuyaTimerHandler
import io.flutter.plugin.common.EventChannel

class TuyaTimerExtensions : EventChannel.StreamHandler, TuyaTimerHandler() {

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.i(LOG_TAG, "Timer Stream started")
        eventSink = events

        this.getDeviceTimers { result ->
            if (result == "error") {
                Log.i(LOG_TAG, "RESULT ERROR")

                eventSink?.error(
                    "TuyaTimerError",
                    "Could not get timers",
                    "Error when getting timers"
                )
            } else {
                Log.i(LOG_TAG, "RESULT timers:  $result")
                eventSink?.success(result)
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        Log.i(LOG_TAG, "Home Stream Canceled")
    }
}