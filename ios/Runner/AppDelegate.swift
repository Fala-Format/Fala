import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        loadDataFromICloud()
        GeneratedPluginRegistrant.register(with: self)
        let controller = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "io.fala.ios.client/native",
                                                 binaryMessenger: controller.binaryMessenger)
        
        methodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "syncICloud" {
                self.saveDataToICloud()
                result(nil) // 返回数据给 Flutter
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func loadDataFromICloud() {
        let defaults = NSUbiquitousKeyValueStore.default
        let userDefault = UserDefaults(suiteName: "group.io.fala.ios.client")
        let syncICloud = userDefault?.bool(forKey: "syncICloud")
        if syncICloud == false {
            return
        }
        let object = defaults.array(forKey: "subscriptions")
        if object != nil && object?.count ?? 0 > 0 {
            userDefault?.set(object, forKey: "subscriptions")
            userDefault?.synchronize()
        }
    }
    
    func saveDataToICloud() {
        let defaults = NSUbiquitousKeyValueStore.default
        let userDefault = UserDefaults(suiteName: "group.io.fala.ios.client")
        let syncICloud = userDefault?.bool(forKey: "syncICloud")
        if syncICloud == false {
            return
        }
        let object = userDefault?.stringArray(forKey: "subscriptions")
        if object != nil && object?.count ?? 0 > 0  {
            defaults.set(object, forKey: "subscriptions")
            defaults.synchronize()
        }
    }
    
    override func applicationWillTerminate(_ application: UIApplication) {
        saveDataToICloud()
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        saveDataToICloud()
    }
}
