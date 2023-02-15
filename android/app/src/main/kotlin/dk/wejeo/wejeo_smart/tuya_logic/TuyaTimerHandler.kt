package dk.wejeo.wejeo_smart.TuyaLogic

import android.util.Log
import com.tuya.smart.android.device.builder.TuyaTimerBuilder
import com.tuya.smart.android.device.enums.TimerDeviceTypeEnum
import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.home.sdk.constant.TimerUpdateEnum
import com.tuya.smart.sdk.api.IResultCallback
import com.tuya.smart.sdk.api.ITuyaDataCallback
import com.tuya.smart.sdk.bean.TimerTask
import com.tuya.smart.sdk.enums.ActivatorModelEnum
import dk.wejeo.wejeo_smart.LocalDataHandler
import dk.wejeo.wejeo_smart.toMap
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import org.xml.sax.Parser
import java.util.*
import kotlin.concurrent.schedule


open class TuyaTimerHandler {
    val LOG_TAG = "TimerConfig_#JW"

    companion object {
        var eventSink: EventChannel.EventSink? = null
    }

//    static let sharedInstance = TuyaTimerHandler()
//    let tuyaSmartTimer: TuyaSmartTimer = TuyaSmartTimer()

//    override
//    private init(){
//        super.init()
//    }

    // , failure: (error:String?) -> Void
    fun getDeviceTimers(completion: (result: String) -> Unit) {
        val deviceId = LocalDataHandler.currentDeviceId
        val deviceFromId = TuyaHomeSdk.newDeviceInstance(deviceId)
        val deviceBean = TuyaHomeSdk.getDataInstance().getDeviceBean(deviceId)
        Timer().schedule(100) {
            TuyaHomeSdk.getTimerInstance().getAllTimerList(
                deviceId,
                TimerDeviceTypeEnum.DEVICE,
                object : ITuyaDataCallback<MutableList<TimerTask>> {
                    override fun onSuccess(result: MutableList<TimerTask>?) {
                        if (result == null) {
                            completion("[]")
                            return
                        } else if (result.isEmpty()) {
                            completion("[]")
                            return
                        }

                        val firstTimerGroup = result.first()
                        val timerList = firstTimerGroup.timerList
                        if (timerList != null) {
                            val timerListMap = mutableListOf<Map<String, Any?>>()
                            for (time in timerList) {
                                Log.i(LOG_TAG, "Timer: $time}")
                                val status = time.status == 1
                                val jsonObj = JSONObject(time.value)

                                val dpsStatus = jsonObj.toMap() as Map<String, Boolean>
                                val data: Map<String, Any?> =
                                    mapOf(
                                        "timerId" to time.timerId,
                                        "aliasName" to time.remark,
                                        "date" to time.date,
                                        "dpsStatus" to dpsStatus["1"],
                                        "loops" to time.loops,
                                        "status" to status,
                                        "time" to time.time,
                                        //time.isOpen?, time.dpId?
                                    )
                                timerListMap.add(data)
                            }
                            val jsArray = JSONArray(timerListMap)
                            completion(jsArray.toString())
                        } else {
                            completion("[]")

                        }
                    }

                    override fun onError(code: String?, error: String?) {
                        completion("error")
                    }
                }
            )
        }
    }

    fun addDeviceTimer(
        result: MethodChannel.Result,
        deviceId: String,
        time: String,
        loops: String,
        dpsStatus: Boolean
    ) {

        val dps: Map<String, Any> = mapOf("1" to dpsStatus)
        val actions: Map<String, Any> = mapOf("dps" to dps, "time" to time)

        Log.i(LOG_TAG, "dps: ${JSONObject(actions)}")

        val builder = TuyaTimerBuilder.Builder()
            .taskName("timer_task_name")
            .devId(deviceId)
            .deviceType(TimerDeviceTypeEnum.DEVICE)
            .actions(JSONObject(actions).toString())
            .loops(loops)
            .aliasName("New timer")
            .status(1)
            .appPush(true)
            .build()

        TuyaHomeSdk.getTimerInstance().addTimer(builder, object : IResultCallback {
            override fun onSuccess() {
                getDeviceTimers { result ->
                    if (result == "error") {
                        Log.i(LOG_TAG, "RESULT ERROR...")
                        eventSink?.error(
                            "TuyaTimerError",
                            "Could not get timers",
                            "Error when getting timers"
                        )
                    } else {
                        eventSink?.success(result)
                    }
                }
                result.success("Success")
            }

            override fun onError(code: String, error: String) {
                result.error(code, error, "Failed to add timer")
            }
        })
    }


    fun updateTimerStatus(
        result: MethodChannel.Result,
        deviceId: String,
        timerIds: List<String>,
        updateType: Int
    ) {

        val updateTypeEnum = when (updateType) {
            0 -> TimerUpdateEnum.CLOSE
            1 -> TimerUpdateEnum.OPEN
            else -> TimerUpdateEnum.DELETE
        }

        TuyaHomeSdk.getTimerInstance().updateTimerStatus(
            deviceId,
            TimerDeviceTypeEnum.DEVICE,
            timerIds,
            updateTypeEnum,
            object : IResultCallback {
                override fun onSuccess() {
                    getDeviceTimers { result ->
                        if (result == "error") {
                            eventSink?.error(
                                "TuyaTimerError",
                                "Could not get timers",
                                "Error when getting timers"
                            )
                        } else {
                            eventSink?.success(result)
                        }
                    }
                    result.success("Success")
                }

                override fun onError(code: String, error: String) {
                    result.error(code, error, "Failed to update timer")
                }
            })
    }
}