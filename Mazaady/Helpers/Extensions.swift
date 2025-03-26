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
    @nonobjc class var DarkGreyColor: UIColor {
        return UIColor(hexString: "#9D9FA0")
    }
    @nonobjc class var LightGreyColor: UIColor {
        return UIColor(hexString: "#F6F7FA")
    }
    @nonobjc class var SoftYellow: UIColor {
        return UIColor(hexString: "#FCCC75")
    }
    @nonobjc class var PurpleColor: UIColor {
        return UIColor(hexString: "#8D5EF2")
    }
    @nonobjc class var TurquoiseColor: UIColor {
        return UIColor(hexString: "#4DC9D1")
    }
    @nonobjc class var DeepBlue: UIColor {
        return UIColor(hexString: "#0082CD") 
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
     func resetArrowRotation(){
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
     func rotateArrow(){
        let transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = transform.rotated(by: CGFloat(Double.pi))
        })
    }
}
extension NSAttributedString {
    static func styledText(mainText: String, subText: String, mainFont: UIFont, subFont: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: mainText + " " + subText)
        
        attributedString.addAttribute(.font, value: mainFont, range: NSRange(location: 0, length: mainText.count))
        attributedString.addAttribute(.font, value: subFont, range: NSRange(location: mainText.count + 1, length: subText.count))
        
        return attributedString
    }
}
extension UICollectionView {
    func configureCollectionView(
        nibName: String,
        scrollDirection: UICollectionView.ScrollDirection = .horizontal,
        useCarousel: Bool = false,
        estimatedSize: Bool = false,
        itemSize: CGSize? = nil,
        lineSpacing: CGFloat = 10,
        interItemSpacing: CGFloat = 10,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    ) {
        // Register cell
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)

        // Use CarouselFlowLayout if enabled, else default to UICollectionViewFlowLayout
        let layout: UICollectionViewFlowLayout = useCarousel ? CarouselFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interItemSpacing
        self.contentInset = contentInsets

        if estimatedSize {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        } else if let size = itemSize {
            layout.itemSize = size
        }

        self.setCollectionViewLayout(layout, animated: true)
    }
}

extension UITextField {
    func paddingTop(padding: CGFloat) {
        self.textRect(forBounds: bounds).inset(by: UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0))
        self.editingRect(forBounds: bounds).inset(by: UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0))
        self.placeholderRect(forBounds: bounds).inset(by: UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0))
    }
    func paddingBottom(padding: CGFloat) {
        self.textRect(forBounds: bounds).inset(by: UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0))
        self.editingRect(forBounds: bounds).inset(by: UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0))
        self.placeholderRect(forBounds: bounds).inset(by: UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0))
    }
    func paddingLeft(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func paddingRight(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
