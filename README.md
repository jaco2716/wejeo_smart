# WEJEO SMART 
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
Remember to change version!
* flutter build ipa
* flutter build appbundle


### Google Cloud Platform
Restore backup
* gcloud firestore import gs://ab_one_firestore_backup/[EXPORT FOLDER NAME]

---
## Useful To remember
### Screen Orientaion (Portrait olnly)
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

---
### IOS Setup for Bluetooth, Location and Wifi info
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
---
## TUYA IOS SDK SETUP


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
---