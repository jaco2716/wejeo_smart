package dk.wejeo.wejeo_smart.tuya_logic

import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.home.sdk.bean.HomeBean
import com.tuya.smart.home.sdk.callback.ITuyaGetHomeListCallback
import com.tuya.smart.home.sdk.callback.ITuyaHomeResultCallback
import com.tuya.smart.sdk.api.IResultCallback
import dk.wejeo.wejeo_smart.LocalDataHandler
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray


open class TuyaHomeHandler {

     var eventSink: EventChannel.EventSink? = null
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
     fun addHome(result: MethodChannel.Result, homeName: String, geoName: String, roomName: String, lat: Double, lon: Double) {
        TuyaHomeSdk.getHomeManagerInstance()
            .createHome(homeName, lon, lat, geoName, listOf(roomName), object : ITuyaHomeResultCallback {
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
                if(homeBeans.isEmpty()){
                    result.success(null)
                    return
                }
                var firstID = homeBeans.first().homeId
                LocalDataHandler.currentHomeId = firstID

                //TODO
//                self.currentHome = TuyaSmartHome(homeId: firstID)
//                self.initHome(homeId: firstID)

                var homeDictList: List<Map<String, Any?>> = homeBeans.map { mapOf("name" to it.name, "homeId" to it.homeId, "geoName" to it.geoName, "lat" to it.lat, "lon" to it.lon) }
                val jsArray = JSONArray(homeDictList)
                result.success(jsArray.toString())
            }

            override fun onError(code: String?, error: String?) {
                result.error(code.toString(), error, "Failed to get home list")
            }
        })

    }


    fun setCurrentHome(result: MethodChannel.Result, homeId:Long) {
        LocalDataHandler.currentHomeId = homeId;
        //TODO
//        self.initHome(homeId: homeId)
        result.success(null)
    }

    fun getCurrentHome(result: MethodChannel.Result) {
        val homeId = LocalDataHandler.currentHomeId
        if(homeId == null){
            result.success(0)
            return
        }
        result.success(homeId)
    }
}