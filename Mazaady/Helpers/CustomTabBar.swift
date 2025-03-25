//
//  CustomTabBar.swift
//  Mazaady
//
//  Created by Walid Ahmed on 25/03/2025.
//
import UIKit
class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 55
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            
            if #available(iOS 11.0, *) {
                sizeThatFits.height = height + window.safeAreaInsets.bottom
            } else {
                sizeThatFits.height = height
            }
        }
        return sizeThatFits
    }
}
