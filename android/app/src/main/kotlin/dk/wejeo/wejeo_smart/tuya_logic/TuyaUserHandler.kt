package dk.wejeo.wejeo_smart.tuya_logic

import com.tuya.smart.android.user.api.ILoginCallback
import com.tuya.smart.android.user.api.ILogoutCallback
import com.tuya.smart.android.user.api.IRegisterCallback
import com.tuya.smart.android.user.api.IResetPasswordCallback
import com.tuya.smart.android.user.bean.User
import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.sdk.api.IResultCallback
import io.flutter.plugin.common.MethodChannel


class TuyaUserHandler {

//    val TuyaHomeSdk.getUserInstance():ITuyaUser = TuyaHomeSdk.getUserInstance()

    //    init(){
//        self.TuyaHomeSdk.getUserInstance() = TuyaTuyaHomeSdk.getUserInstance().sharedInstance()
//    }

    ///
    ///check if user is logged in to the Tuya Platform
    ///
     fun checkIsLoggedIn(result: MethodChannel.Result){
//        Log.e("TuyaHomeSdk", "TuyaHomeSdk get")
//        Log.println(Log.ERROR,"TuyaHomeSdk","TUYAGOMESDK TOSTRING!=!")
//        result.success(false)
        try {
//            print("TuyaHomeSdk:::")
//            val user = TuyaHomeSdk()
//            print("TuyaHomeSdk tostring")
//            print(user.toString())
        if (TuyaHomeSdk.getUserInstance().isLogin){
            result.success(true)
        } else{
            result.success(false)
        }
        } catch (e:Error){
            result.error(e.toString(), e.message, e.localizedMessage)
        }

    }

    ///
    ///Log in to the Tuya Platform
    ///
     fun loginWithEmail(result: MethodChannel.Result, countryCode: String, email: String, password: String){
//        Log.e("TuyaHomeSdk", "login get")
//        Log.println(Log.ERROR,"TuyaHomeSdk","login!=!")
//try {
//    val sdk = TuyaHomeSdk.getUserInstance()
//    Log.e("TuyaHomeSdk", "getUserInstance")
//    Log.e("TuyaHomeSdk", sdk.toString())
//    Log.e("TuyaHomeSdk", sdk.user.toString())
//}catch (e:Error){
//    Log.e("TuyaHomeSdk", "ERROR")
//    Log.e("TuyaHomeSdk", e.toString())
//}
//        result.success("nope")
        TuyaHomeSdk.getUserInstance().loginWithEmail(countryCode, email, password, object :
            ILoginCallback {
                override fun onError(code: String?, error: String?) {
                    result.error(code.toString(), error, "Failed to login")
                }

                override fun onSuccess(user: User) {
                    result.success("Success")
                }
            })
    }

    ///
    ///Send a verification code from the Tuya Platform
    ///
     fun sendVerificationCode(result: MethodChannel.Result, countryCode: String, email: String, type: Int) {
        TuyaHomeSdk.getUserInstance().sendVerifyCodeWithUserName(
            email,
            "",
            countryCode,
            type,
            object : IResultCallback {
                override fun onError(code: String?, error: String?) {
                    result.error(code.toString(), error, "Failed to send verification code")
                }

                override fun onSuccess() {
                    result.success("Success")
                }
            })
    }

    ///
    ///check the verification code in to the Tuya Platform
    ///
     fun checkVerificationCode(result: MethodChannel.Result, countryCode: String, email: String, verificationCode: String, type: Int){
        TuyaHomeSdk.getUserInstance().checkCodeWithUserName(email, "",  countryCode,  verificationCode,  type, object : IResultCallback {
            override fun onError(code: String?, error: String?) {
                result.error(code.toString(), error, "Failed to check verification code")
            }

            override fun onSuccess() {
                result.success("Success")
            }
        })
    }

    ///
    ///Register user in to the Tuya Platform
    ///
     fun registerUser(result: MethodChannel.Result, countryCode: String, email: String, password: String, verificationCode: String){
        TuyaHomeSdk.getUserInstance().registerAccountWithEmail(
            countryCode,
            email,
            password,
            verificationCode,
            object : IRegisterCallback {
                override fun onError(code: String?, error: String?) {
                    result.error(code.toString(), error, "Failed to register user")
                }
                override fun onSuccess(user: User) {
                    result.success("Success")
                }
            })
    }

     fun logOutUser(result: MethodChannel.Result) {

        TuyaHomeSdk.getUserInstance().logout(object : ILogoutCallback{
            override fun onError(code: String?, error: String?) {
                result.error(code.toString(), error, "Failed to sign out user")
            }

            override fun onSuccess() {
                result.success("Success")
            }
        })
    }

     fun resetPasswordByEmail(result: MethodChannel.Result, countryCode: String, email: String, password: String, verificationCode: String) {
        TuyaHomeSdk.getUserInstance().resetEmailPassword(countryCode, email, verificationCode,password, object: IResetPasswordCallback{
            override fun onError(code: String?, error: String?) {
                result.error(code.toString(), error, "Failed to reset password")
            }

            override fun onSuccess() {
                result.success("Success")
            }
        })
    }

    ///
    /// Deletes a user account. During the week following this delete operation, if the user is logged in again, the delete request is canceled.
    /// If not, the user is permanently disabled and all its information is deleted after this week.
    ///
     fun cancelAccount(result: MethodChannel.Result) {
        TuyaHomeSdk.getUserInstance().cancelAccount(object :IResultCallback{
            override fun onError(code: String?, error: String?) {
                result.error(code.toString(), error, "Failed to cancel account")
            }
            override fun onSuccess() {
                result.success("Success")
            }
        })
    }

}