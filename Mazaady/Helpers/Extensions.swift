//
//  Untitled.swift
//  Mazaady
//
//  Created by Walid Ahmed on 25/03/2025.
//
import UIKit
import Foundation
import Kingfisher

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    @nonobjc class var PrimaryColor: UIColor {
        return UIColor(hexString: "#EC5F5F")
    }
    @nonobjc class var SecondaryColor: UIColor {
        return UIColor(hexString: "#FCD034")
    }
}
extension UIView {
    func dropShadow(radius: CGFloat, opacity: Float = 0.3, offset: CGSize = CGSize(width: 1.5, height: 3)) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.rasterizationScale = UIScreen.main.scale
    }
}
extension UIImageView{
    func setImage(imageStr: String, placeholder: String? = nil, renderImage: Bool? = false,showIndicatorView: Bool? = true, completionHandler: (() -> Void)? = nil) {
        let imageURL = URL(string: imageStr)
        if showIndicatorView == true{
            self.kf.indicatorType = .activity
            (self.kf.indicator?.view as? UIActivityIndicatorView)?.color = .PrimaryColor
        }
        self.kf.setImage(with: imageURL,  placeholder: placeholder != nil ? UIImage(named: placeholder!) : nil, options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(1)),
        ]) { result in
            switch result {
            case .success(let imageResult):
                // Set the image
                if renderImage == true {
                    self.image = imageResult.image.withRenderingMode(.alwaysTemplate)
                    self.tintColor = UIColor.black
                } else {
                    self.image = imageResult.image
                }
                completionHandler?()
            case .failure(let error):
                // Handle the error
                if !error.isTaskCancelled && !error.isNotCurrentTask {
                    print("Error: \(error)")
                    self.image = placeholder != nil ? UIImage(named: placeholder!) : nil
                    self.contentMode = .scaleAspectFit
                }
            }
        }
    }
}
