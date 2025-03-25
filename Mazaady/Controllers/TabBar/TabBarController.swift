//
//  TabBarController.swift
//  Mazaady
//
//  Created by Walid Ahmed on 25/03/2025.
//

import UIKit
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    let lineView = UIView() 
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbarUI()
        setLocalization()
        addLineAboveTabbar()
    }
    func addLineAboveTabbar(){
        // configure the line view
        lineView.layer.cornerRadius = 2
        lineView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        lineView.backgroundColor = .PrimaryColor
        tabBar.addSubview(lineView)
        
        // move the line to the first tab bar item
        let itemWidth = tabBar.frame.width / CGFloat(tabBar.items!.count)
        let initialLineFrame = CGRect(x: itemWidth / 2 - 10, y: 0, width: 20, height: 4)
        lineView.frame = initialLineFrame
        
        let currentLineFrame = CGRect(x: lineView.frame.origin.x, y: lineView.frame.origin.y, width: 20, height: 4)
        lineView.frame = currentLineFrame
        // set the delegate of the tab bar controller to self
        delegate = self
    }
    func setTabbarUI(){
        tabBar.dropShadow(radius: 1, opacity: 0.06, offset: CGSize(width: 0, height: -1))
        tabBar.tintColor = .PrimaryColor
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "#3D3D3D")
        UITabBar.appearance().tintColor = .PrimaryColor
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
    func setLocalization(){
        guard let items = tabBar.items else { return }
        items[0].title = "Home"
        items[1].title = "Forms"
    }
    func animateAfterSelectingIndex(index: Int){
        let itemWidth = tabBar.frame.width / CGFloat(tabBar.items!.count)
        UIView.animate(withDuration: 0.3) {[weak self] in
            guard let self = self else{return}
            self.lineView.frame.origin.x = itemWidth * CGFloat(index) + itemWidth / 2 - 10
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // animate the line view to the selected tab bar item
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }
        animateAfterSelectingIndex(index: index)
    }
}
