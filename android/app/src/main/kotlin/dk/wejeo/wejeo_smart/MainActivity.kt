package dk.wejeo.wejeo_smart

import androidx.annotation.NonNull
import com.tuya.smart.home.sdk.TuyaHomeSdk
import dk.wejeo.wejeo_smart.TuyaLogic.TuyaTimerHandler
import dk.wejeo.wejeo_smart.tuya_logic.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val LOG_TAG = "MethodChannel_#JW"

    //    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
//        super.onCreate(savedInstanceState, persistentState)
//        TuyaHomeSdk.init(this.application)
//        TuyaHomeSdk.setDebugMode(true)
//    }
//
    override fun onDestroy() {
        super.onDestroy()
        TuyaHomeSdk.onDestroy()
    }

    private val tuyaUserHandler = TuyaUserHandler()
    private val tuyaHomeHandler = TuyaHomeHandler()
    private val tuyaDeviceHandler = TuyaDeviceHandler()
    private val tuyaTimerHandler = TuyaTimerHandler()

    private val tuyaChannelName = "dk.wejeo.wejeoSmart/tuya"
    private val homeEventChannelName = "dk.wejeo.wejeoSmart/homeEvents"
    private val deviceEventChannelName = "dk.wejeo.wejeoSmart/deviceEvents"
    private val timerEventChannelName = "dk.wejeo.wejeoSmart/timerEvents"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, homeEventChannelName)
            .setStreamHandler(TuyaHomeExtensions())

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, deviceEventChannelName)
            .setStreamHandler(TuyaDeviceExtensions())

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, timerEventChannelName)
            .setStreamHandler(TuyaTimerExtensions())

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            tuyaChannelName
        ).setMethodCallHandler {
            // This method is invoked on the main thread.s
                call, result ->
            when (call.method) {
                "checkIsLoggedIn" -> {
                    tuyaUserHandler.checkIsLoggedIn(result)
                }
                "loginWithEmail" -> {
                    try {
                        val email = call.argument<String>("email")
                        val password = call.argument<String>("password")
                        val countryCode = call.argument<String>("countryCode")
                        tuyaUserHandler.loginWithEmail(result, countryCode!!, email!!, password!!)

                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }

                }
                "logOutUser" -> {
                    tuyaUserHandler.logOutUser(result)

                }
                "sendVerificationCode" -> {
                    try {
                        val email = call.argument<String>("email")
                        val countryCode = call.argument<String>("countryCode")
                        val type = call.argument<Int>("type")
                        tuyaUserHandler.sendVerificationCode(result, countryCode!!, email!!, type!!)
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }

                }
                "checkVerificationCode" -> {
                    try {
                        val email = call.argument<String>("email")
                        val countryCode = call.argument<String>("countryCode")
                        val verificationCode = call.argument<String>("verificationCode")
                        val type = call.argument<Int>("type")
                        tuyaUserHandler.checkVerificationCode(
                            result,
                            countryCode!!,
                            email!!,
                            verificationCode!!,
                            type!!
                        )
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }

                }
                "registerUser" -> {
                    try {
                        val email = call.argument<String>("email")
                        val password = call.argument<String>("password")
                        val verificationCode = call.argument<String>("verificationCode")
                        val countryCode = call.argument<String>("countryCode")
                        tuyaUserHandler.registerUser(
                            result,
                            countryCode!!,
                            email!!,
                            password!!,
                            verificationCode!!
                        )
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }

                }
                "resetPasswordByEmail" -> {
                    try {
                        val email = call.argument<String>("email")
                        val password = call.argument<String>("password")
                        val verificationCode = call.argument<String>("verificationCode")
                        val countryCode = call.argument<String>("countryCode")
                        tuyaUserHandler.resetPasswordByEmail(
                            result,
                            countryCode!!,
                            email!!,
                            password!!,
                            verificationCode!!
                        )
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }
                }
                "cancelAccount" -> {
                    tuyaUserHandler.cancelAccount(result)

                }


//                -------------------------------------------------------------------------------
//                Home functions
                "getHomeList" -> {
                    tuyaHomeHandler.getHomeList(result)

                }
                "addHome" -> {
                    try {
                        val homeName = call.argument<String>("homeName")
                        val geoName = call.argument<String>("geoName")
                        val roomName = call.argument<String>("roomName")
                        val lat = call.argument<Double>("lat")
                        val lon = call.argument<Double>("lon")
                        tuyaHomeHandler.addHome(
                            result,
                            homeName!!,
                            geoName!!,
                            roomName!!,
                            lat!!,
                            lon!!
                        )
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }
                }
                "setCurrentHome" -> {
                    try {
                        val homeId = call.arguments<Long>()
                        tuyaHomeHandler.setCurrentHome(result, homeId!!)

                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }


                }
                "removeHome" -> {
                    try {
                        val homeId = call.arguments<Long>()
                        tuyaHomeHandler.removeHome(result, homeId!!)
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }


                }
                "getCurrentHome" -> {
                    tuyaHomeHandler.getCurrentHome(result)
                }
                "updateHomeData" -> {
                    tuyaHomeHandler.updateHomeData(result)
                }


                //-------------------------------------------------------------------------------
                //Device functions
                "startParing" -> {
                    try {
                        val homeId = call.argument<Int>("homeId")
                        val homeIdLong = homeId?.toLong() ?: call.argument<Long>("homeId")
                        val password = call.argument<String>("password")
                        val ssid = call.argument<String>("ssid")
                        val mode = call.argument<Int>("mode")

                        tuyaDeviceHandler.startParing(
                            result,
                            homeIdLong!!,
                            password!!,
                            ssid!!,
                            mode!!
                        )

                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }

                }
                "stopParing" -> {
                    tuyaDeviceHandler.stopParing(result)

                }
//                "getCurrentHomeDeviceList" -> {
//                    tuyaDeviceHandler.getCurrentHomeDeviceList(result)
//
//                }
                "setCurrentDevice" -> {
                    try {
                        val devId = call.arguments<String>()
                        tuyaDeviceHandler.setCurrentDevice(result, devId!!)

                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }


                }
                "setDeviceValue" -> {
                    try {
                        val deviceId = call.argument<String>("deviceId")
                        val dpId = call.argument<String>("dpId")
                        tuyaDeviceHandler.setDeviceValue(result, deviceId!!, dpId!!)

                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }

                }
//                "readDeviceValues" -> {
//                    try {
//
//                        val deviceId = call.arguments<String>()
//                        tuyaDeviceHandler.readDeviceValues(result, deviceId)
//
//                    } catch (e: Exception) {
//                        result.error("errorSetDebug", "data or format error", "")
//                    }
//
//
//                }
//                "getDeviceProperties" -> {
//                    try {
//
//                        val deviceId = call.arguments<String>()
//                        tuyaDeviceHandler.getDeviceProperties(result, deviceId)
//                    } catch (e: Exception) {
//                        result.error("errorSetDebug", "data or format error", "")
//                    }
//
//
//                }
//                "getDeviceListFromHomeId" -> {
//
//                    try {
//
//                        val homeId = call.arguments<String>()
//                        tuyaDeviceHandler.getDeviceListFromHomeId(result, homeId)
//                    } catch (e: Exception) {
//                        result.error("errorSetDebug", "data or format error", "")
//                    }
//
//                }
                "modifyDeviceName" -> {
                    try {
                        val deviceId = call.argument<String>("deviceId")
                        val name = call.argument<String>("name")


                        tuyaDeviceHandler.modifyDeviceName(result, deviceId!!, name!!)
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }


                }
                "removeDevice" -> {
                    try {
                        val deviceId = call.arguments<String>()
                        tuyaDeviceHandler.removeDevice(result, deviceId!!)
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }


                }


                //-------------------------------------------------------------------------------
                //Timer functions
                "addDeviceTimer" -> {
                    try {
                        val deviceId = call.argument<String>("deviceId")
                        val time = call.argument<String>("time")
                        val loops = call.argument<String>("loops")
                        val dpsStatus = call.argument<Boolean>("dpsStatus")
                        tuyaTimerHandler.addDeviceTimer(
                            result,
                            deviceId!!,
                            time!!,
                            loops!!,
                            dpsStatus!!
                        )
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }


                }
                //        else if (call.method == "getDeviceTimers"){
                //            if  let deviceId = call.arguments as? String {
                //                tuyaTimerHandler.getDeviceTimers(result: result, deviceId: deviceId)
                //            } else {
                //                result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
                //            }
                //
                //        }
                "updateTimerStatus" -> {
                    try {
                        val deviceId = call.argument<String>("deviceId")
                        val timerIds = call.argument<List<String>>("timerIds")
                        val updateType = call.argument<Int>("updateType")
                        tuyaTimerHandler.updateTimerStatus(
                            result,
                            deviceId!!,
                            timerIds!!,
                            updateType!!
                        )
                    } catch (e: Exception) {
                        result.error("errorSetDebug", "data or format error", "")
                    }

                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
