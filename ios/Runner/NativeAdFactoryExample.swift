//
//  NativeAdFactoryExample.swift
//  Runner
//
//  Created by kira on 17/08/2022.
//

import Foundation
import google_mobile_ads
import UIKit

class NativeAdFactoryExample: NSObject, FLTNativeAdFactory {
    func createNativeAd(
        _ nativeAd: GADNativeAd,
        customOptions: [AnyHashable : Any]?
    ) -> GADNativeAdView? {
        // Create and place ad in view hierarchy.
        let adView = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil)?.first as! GADNativeAdView

        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        adView.nativeAd = nativeAd

        // Populate the native ad view with the native ad assets.
        // The headline is guaranteed to be present in every native ad.
        (adView.headlineView as! UILabel).text = nativeAd.headline

        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (adView.bodyView as! UILabel).text = nativeAd.body
        adView.bodyView!.isHidden = nativeAd.body == nil

        (adView.callToActionView as! UIButton).setTitle(
            nativeAd.callToAction,
            for: .normal)
        adView.callToActionView!.isHidden = nativeAd.callToAction == nil

        (adView.iconView as! UIImageView).image = nativeAd.icon?.image
        adView.iconView!.isHidden = nativeAd.icon == nil

        (adView.storeView as! UILabel).text = nativeAd.store
        adView.storeView!.isHidden = nativeAd.store == nil

        (adView.priceView as! UILabel).text = nativeAd.price
        adView.priceView!.isHidden = nativeAd.price == nil

        (adView.advertiserView as! UILabel).text = nativeAd.advertiser
        adView.advertiserView!.isHidden = nativeAd.advertiser == nil

        // In order for the SDK to process touch events properly, user interaction
        // should be disabled.
        adView.callToActionView!.isUserInteractionEnabled = false

        return adView
    }
}
