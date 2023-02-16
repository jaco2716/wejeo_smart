# WEJEO SMART 

Flutter version 3.3.10

Console Filter : `E/, #JW, flutter, !D/TUYA, Exception`

## Commands
### Build JsonSerializable model classes:
```yaml
dependencies:
  json_annotation: ^4.8.0 #use @command:dart.addDependency

dev_dependencies:
  build_runner: ^2.3.3 #use @command:dart.addDevDependency
  json_serializable: ^6.6.0 #use @command:dart.addDevDependency
```

```dart
//Replace NAME with class
factory NAME.fromJson(Map<String, dynamic> json) => _$NAMEFromJson(json);
Map<String, dynamic> toJson() => _$NAMEToJson(this);
```
* flutter pub run build_runner build
* flutter pub run build_runner watch


### Build iOS/Android Archive: 
Remember to change version! (version: 1.0.0+1 -> 1.0.1+2)
* flutter build ipa
* flutter build appbundle


### Google Cloud Platform
Restore backup
* gcloud firestore import gs://ab_one_firestore_backup/[EXPORT FOLDER NAME]

---
## Useful config setup

<details>
<summary>Screen Orientaion (Portrait olnly)</summary>

Input in main.dart -> MyApp -> after `Widget build(BuildContext context) {`
```dart
SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
```
For iOS (To work on iPad)
```plist
<array>
  <string>UIInterfaceOrientationPortrait</string>
</array>
```
</details>

<details>
<summary>IOS Setup for Bluetooth, Location and Wifi info</summary>

In Targets->Runner -> Signing & Capabilities -> +Capability -> Access Wifi information

In info.plist set: 
| Desc | Field Name | Value |
| --- | --- | --- |
| No encryption |App Uses Non-Exempt Encryption | NO |
| Set app Name | Bundle display name | APP_NAME |
| Use bluetooth | Privacy - Bluetooth Peripheral Usage Description |Bluetooth is required for some features|
| Use Bluetooth | Privacy - Bluetooth Always Usage Description | Bluetooth is required for some features
| Use location | Privacy - Location Always Usage Description | Location is required for some features
| Use location |Privacy - Location When In Use Usage Description | Location is required for some features
| Use location | Privacy - Location Always and When In Use Usage Description | Location is required for some features
| Use location | Privacy - Local Network Usage Description | Location is required for some features
| Use location | Privacy - Location Usage Description | Location is required for some features

Paste in info.plist for location and bluetooth (Location needed for WIFI info and connection to IOT device):
```plist
<key>NSBluetoothPeripheralUsageDescription</key>  
<string>Bluetooth is required for some features</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth is required for some features</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Location is required for some features</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location is required for some features</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Location is required for some features</string>
<key>NSLocationUsageDescription</key>
<string>Location is required for some features</string>
<key>NSLocalNetworkUsageDescription</key>
<string>Local Network is required for some features</string>
```
</details>


<details>
<summary>Android Setup for Bluetooth, Location and Wifi info</summary>

* Find `minSdkVersion`=16, `compileSdkVersion`=33, `targetSdkVersion`=33 -> /FlutterSDK/flutter/packages/flutter_tools/gradle/flutter.gradle
* See guide for `permission_handler` [Here](https://pub.dev/packages/permission_handler)

</details>
---

## TUYA SDK SETUP
<details>
<summary>IOS</summary>

* Update CocoaPods to the latest version. 
[sudo] gem install cocoapods

* Add the following code block to the Podfile:
```pod
source 'https://cdn.cocoapods.org/'
source 'https://github.com/TuyaInc/TuyaPublicSpecs.git'
source 'https://github.com/tuya/tuya-pod-specs.git'
platform :ios, '11.0'

target 'Your_Project_Name' do
    Pod 'TuyaSmartHomeKit','~> 4.0.0'
end
```
In the root directory of your project, run pod update.

### Initialize the SDK

1) Make sure bundle id is the same as in Tuya setup.
2) Import the security image to the root directory (Runner folder) of the project, and rename it as t_s.bmp. 
3) Go to Project Settings > Target > Build Phases, and add this image to Copy Bundle Resources. (May be there already)
4) Dont: (Add the following content to the PrefixHeader.pch file:
- #import <TuyaSmartHomeKit/TuyaSmartKit.h>)
5) Add the following content to the bridging header file xxx_Bridging-Header.h:
- #import <TuyaSmartHomeKit/TuyaSmartKit.h>
6) Open the AppDelegate.swift file and initialize the SDK in AppDelegate application:didFinishLaunchingWithOptions:.
### Configure the SDK
Define values:
```swift
  let tuyaUserHandler = TuyaUserHandler.sharedInstance
  let tuyaHomeHandler = TuyaHomeHandler.sharedInstance
  let NAMEHandler = NAMEHandler.sharedInstance
```
Insert into AppDelegate.swift - func application (Replace BUNDLE_ID):
```swift
    //Flutter Method Channel
    let deviceEventChannelName = "dk.wejeo.BUNDLE_ID/deviceEvents"
    let tuyaChannelName = "dk.wejeo.BUNDLE_ID/tuya"
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let tuyaChannel = FlutterMethodChannel(name: tuyaChannelName, binaryMessengercontroller.    binaryMessenger)
    tuyaChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping   FlutterResult) -> Void in
        self.checkMethodChannel(call: call, result: result)
    })
    
    let deviceChannel = FlutterEventChannel(name: deviceEventChannelNamebinaryMessenger:    controller.binaryMessenger)
    deviceChannel.setStreamHandler(NAMEHandler)
    
    // Initialize TuyaSmartSDK
    TuyaSmartSDK.sharedInstance().start(withAppKey: AppKey.appKey, secretKey: AppKesecretKey)
    
    // Enable debug mode, which allows you to see logs.
    #if DEBUG
          TuyaSmartSDK.sharedInstance().debugMode = true
    #endif
```
Create AppKey.swift file and pase code(Change values to your key and secret):
```swift
    import Foundation
    struct AppKey {
        static let appKey = "YOUR_APP_KEY"
        static let secretKey = "YOUR_APP_SECRET"
    }
```
</details>

<details>
<summary>Android</summary>

* Get SHA256 key:
1. Navigate to the Gradle tab at the right side of Android Studio.
2. Click The elephant "Execute Gradle Task".
3. Write  "gradle signingReport" and enter.
4. Add Key in Tuya Platform

* Add dependencies to the build.gradle(app) file of the Android project.
```gradle
android {
	defaultConfig {
		ndk {
			abiFilters "armeabi-v7a", "arm64-v8a"
		}
	}
	packagingOptions {
		pickFirst 'lib/*/libc++_shared.so' // An Android Archive (AAR) file contains an Android library. If the .so file exists in multiple AAR files, select the first AAR file.
	}
}
dependencies {
	implementation 'com.alibaba:fastjson:1.1.67.android'
  implementation 'com.squareup.okhttp3:okhttp-urlconnection:3.14.9'

  // The latest stable App SDK for Android.
  implementation 'com.tuya.smart:tuyasmart:4.0.3'
}
```

* Add the Tuya IoT Maven repository URL to the build.gradle file in the root directory. (Add to both "buildscript" & "allprojects")
```
 repositories {
        google()
        mavenCentral()

        // Tuya Setup
        jcenter()
        maven { url 'https://maven-other.tuya.com/repository/maven-releases/' }
        maven { url "https://maven-other.tuya.com/repository/maven-commercial-releases/" }
        maven { url 'https://jitpack.io' }

        maven { url 'https://maven.aliyun.com/repository/public' }
        maven {
            url 'http://central.maven.org/maven2/'
            allowInsecureProtocol = true
        }
        maven { url 'https://oss.sonatype.org/content/repositories/snapshots/' }
        maven { url 'https://developer.huawei.com/repo/' }

    }
```
* Log in to the Tuya IoT Development Platform, go to the SDK Development page, and then click the SDK to be managed.
* On the page that appears, click the Get Key tab and click Download in the App Security Image for Android field.
* Rename the security image as t_s.bmp and put the image in the assets folder of your project. (Create Assets folder in "app->src->main->assets" in Project view)

* Return to the Android project, configure appkey and appSecret in AndroidManifest.xml, and then set permissions for the app.
```xml
<meta-data
android:name="TUYA_SMART_APPKEY"
android:value="APP_KEY" />
<meta-data
android:name="TUYA_SMART_SECRET"
android:value="APP_SECRET" />
```
* Configure obfuscation in proguard-rules.pro. (Create "proguard-rules.pro" file in "app->src->" and paste code)
```pro
#fastJson
-keep class com.alibaba.fastjson.**{*;}
-dontwarn com.alibaba.fastjson.**

#mqtt
-keep class com.tuya.smart.mqttclient.mqttv3.** { *; }
-dontwarn com.tuya.smart.mqttclient.mqttv3.**

#OkHttp3
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

-keep class okio.** { *; }
-dontwarn okio.**

-keep class com.tuya.**{*;}
-dontwarn com.tuya.**
```
* In build.gradle (app) 
```gralde
buildTypes {
  release {
    proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    // Other code ...
  }
}
```
* Initialize the SDK in Application. Make sure that all processes are initialized. Example: (Create kotlin file with your AppName in "app->src->main->kotlin->domain->)
```kotlin
class AppName : Application() {
    override fun onCreate() {
        super.onCreate()
        application = this
        TuyaHomeSdk.init(this, "APP_KEY", "APP_SECRET")
        TuyaHomeSdk.setDebugMode(true)
    }
}
```
* Change android:name="" in `<application tag` to the file you created. and add `tools:replace="android:label"`
```xml
android:name=".AppNameFile"
tools:replace="android:label"
```
* Change android:name="" in `<activity tag` to ".MainActivity"
```xml
android:name=".MainActivity"
```
* Add to MainActivity file
```kotlin
 override fun onDestroy() {       
    super.onDestroy()            
    TuyaHomeSdk.onDestroy()      
}                                
```
</details>