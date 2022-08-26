import UIKit
import Flutter
import google_mobile_ads

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let nativeAdFactory = NativeAdFactoryExample()
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(self,
                                                         factoryId: "adFactoryExample",
                                                         nativeAdFactory: nativeAdFactory)
        
        let listTileNativeAdFactory = ListTileNativeAdFactory()
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(self,
                                                         factoryId: "listTileNativeAd",
                                                         nativeAdFactory: listTileNativeAdFactory)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
