//
//  ListTileNativeAdFactory.swift
//  Runner
//
//  Created by kira on 24/08/2022.
//

import google_mobile_ads

class ListTileNativeAdFactory : FLTNativeAdFactory {
    
    func createNativeAd(_ nativeAd: GADNativeAd,
                        customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("ListTileNativeAdView", owner: nil, options: nil)!.first
        let nativeAdView = nibView as! GADNativeAdView
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.headlineView?.isUserInteractionEnabled = false
        
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        if #available(iOS 15.0, *) {
            (nativeAdView.callToActionView as? UIButton)?.configuration?.titleTextAttributesTransformer = .init({ incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 12)
                return outgoing
            })
        }
        //        (nativeAdView.callToActionView as? UIButton)?.titleLabel?.font = (nativeAdView.callToActionView as? UIButton)?.titleLabel?.font.withSize(8)
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        nativeAdView.iconView?.contentMode = .scaleAspectFill
        nativeAdView.iconView?.layer.cornerRadius = 8
        nativeAdView.iconView?.isUserInteractionEnabled = false
        
        (nativeAdView.advertiserView as? UILabel)?.lineBreakMode = .byTruncatingTail
        (nativeAdView.advertiserView as? UILabel)?.numberOfLines = 1
        
        
        //        (nativeAdView.bodyView as! UILabel).text = nativeAd.body
        //        nativeAdView.bodyView!.isHidden = nativeAd.body == nil
        
        // View Customizations
        
        nativeAdView.nativeAd = nativeAd
        return nativeAdView
    }
}
