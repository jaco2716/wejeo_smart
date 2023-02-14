package dk.wejeo.wejeo_smart

import android.content.Context
import android.content.SharedPreferences

object LocalDataHandler {

    private val sharedPreference: SharedPreferences = WejeoSmart.context.getSharedPreferences("myPref", Context.MODE_PRIVATE)

     var currentHomeId : Long? = null
        get() {
            val value = sharedPreference.getLong("CurrentHomeId",0L)
            if(value == 0L){
                println("Getting Current id Null")
                return null
            }
            println("Getting homeId = $value")
            return value
        }
        set(value) {
            val editor = sharedPreference.edit()
            if (value != null) {
                editor.putLong("CurrentHomeId",value)
            }
            editor.commit()
            field = value
        }


    var currentDeviceId : String? = null
        get() {
            val value = sharedPreference.getString("CurrentDeviceId","")
            if(value == ""){
                println("Getting Current id Null")
                return null
            }
            println("Getting deviceId = $value")
            return value
        }
        set(value) {
            val editor = sharedPreference.edit()
            if (value != null) {
                editor.putString("CurrentDeviceId",value)
            }
            editor.commit()
            field = value
        }
}