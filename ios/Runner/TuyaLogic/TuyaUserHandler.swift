//
//  TuyaHandler.swift
//  Runner
//
//  Created by Jacob Welin - Wejeo on 05/09/2022.
//

import Foundation
import Flutter
import TuyaSmartBaseKit
///
///Access Tuya user functions
///
class TuyaUserHandler : NSObject{
    
    static let sharedInstance = TuyaUserHandler()
    
    let smartUser: TuyaSmartUser
    
    override
    private init(){
        self.smartUser = TuyaSmartUser.sharedInstance()
    }
    ///
    ///check if user is logged in to the Tuya Platform
    ///
    public func checkIsLoggedIn(result:@escaping FlutterResult){
        if smartUser.isLogin {
            result(true)
        } else {
            result(false)
        }
    }
    
    ///
    ///Log in to the Tuya Platform
    ///
    public func loginWithEmail(result:@escaping FlutterResult, countryCode: String, email: String, password: String){
        smartUser.login(byEmail: countryCode, email: email, password: password) {
            let message = "Success"
            result(message)
        } failure: { error in
            if let e = error?.localizedDescription {
                result(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
            } else{
                result(nil)
            }
        }
    }
    
    ///
    ///Send a verification code from the Tuya Platform
    ///
    public func sendVerificationCode(result:@escaping FlutterResult, countryCode: String, email: String, type: Int)  {
        let region = smartUser.getDefaultRegion(withCountryCode: countryCode)
        
        smartUser.sendVerifyCode(withUserName: email, region: region, countryCode: countryCode, type: type) {
            let message = "Success"
            result(message)
        } failure: { error in
            if let e = error?.localizedDescription {
                result(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
            } else{
                result(nil)
            }
        }
    }
    
    ///
    ///check the verification code in to the Tuya Platform
    ///
    public func checkVerificationCode(result:@escaping FlutterResult, countryCode: String, email: String, verificationCode: String, type: Int){
        let region = smartUser.getDefaultRegion(withCountryCode: countryCode)
        
        smartUser.checkCode(withUserName: email, region: region, countryCode: countryCode, code: verificationCode, type: type) { value in
            if(value){
                result("Success")
            } else{
                result("Wrong code")
            }
            
        } failure: { error in
            if let e = error?.localizedDescription {
                result(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
            } else{
                result(nil)
            }
        }
        
    }
    
    ///
    ///Register user in to the Tuya Platform
    ///
    public func registerUser(result:@escaping FlutterResult, countryCode: String, email: String, password: String, verificationCode: String){
        
        smartUser.register(byEmail: countryCode, email: email, password: password, code: verificationCode) {
            let message = "Success"
            result(message)
        } failure: { error in
            if let e = error?.localizedDescription {
                result(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
            } else{
                result(nil)
            }
        }
    }
    
    public func logOutUser(result:@escaping FlutterResult) {
        smartUser.loginOut({
            let message = "Success"
            result(message)
        }, failure: { (error) in
            if let e = error?.localizedDescription {
                result(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
                
            } else{
                result(nil)
            }
        })
    }
    
    func resetPasswordByEmail(result:@escaping FlutterResult, countryCode: String, email: String, password: String, verificationCode: String) {
        
        smartUser.resetPassword(byEmail: countryCode, email: email, newPassword: password, code: verificationCode, success: {
            let message = "Success"
            result(message)
        }, failure: { (error) in
            if let e = error?.localizedDescription {
                result(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
            } else{
                result(nil)
            }
        })
    }
    
    ///
    ///Deletes a user account. During the week following this delete operation, if the user is logged in again, the delete request is canceled.
    ///If not, the user is permanently disabled and all its information is deleted after this week.
    ///
    func cancelAccount(result:@escaping FlutterResult) {
        smartUser.cancelAccount({
            print("cancel account success")
            let message = "Success"
            result(message)
        }, failure: { (error) in
            if let e = error?.localizedDescription {
                result(FlutterError.init(code: " tuyaFailureError", message: e, details: nil))
            } else{
                result(nil)
            }
        })
    }
    
}
