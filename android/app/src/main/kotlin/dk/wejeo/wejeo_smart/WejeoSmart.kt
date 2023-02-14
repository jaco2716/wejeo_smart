package dk.wejeo.wejeo_smart

import android.app.Application
import android.content.Context
import android.util.Log
import com.tuya.smart.home.sdk.TuyaHomeSdk

class WejeoSmart : Application() {

    override fun onCreate() {
        super.onCreate()
        application = this
        Log.e("TuyaHomeSdk", "########")
        Log.e("TuyaHomeSdk", "Initializing TUYA SDK")
        TuyaHomeSdk.init(this, "c9turmwnftkwm7wmetxd", "85evxdqjgvkc9sucqd7yka7htqnwqe49")
        Log.e("TuyaHomeSdk", " Setting debug mode true...")
        TuyaHomeSdk.setDebugMode(true)
        Log.e("TuyaHomeSdk", "########")

    }

    // Access context
    companion object {
        private var application: Application? = WejeoSmart()

        val context: Context
            get() = application!!.applicationContext
    }

    

    override fun onTerminate() {
        super.onTerminate()
        TuyaHomeSdk.onDestroy();
    }

}
