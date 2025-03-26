//
//  HomeViewModel.swift
//  Mazaady
//
//  Created by Walid Ahmed on 25/03/2025.
//

import RxSwift
import RxCocoa

class HomeViewModel {
    var liveAvatars = BehaviorRelay<[UIImage]>(value: [])
    var categories = BehaviorRelay<[String]>(value: [])
    let selectedCategoryIndex = BehaviorRelay<Int>(value: 0)

    func addLiveAvatars(){
        let imageView1 = UIImage(named: "Avatar1") ?? UIImage()
        let imageView2 = UIImage(named: "Avatar2") ?? UIImage()
        let imageView3 = UIImage(named: "Avatar3") ?? UIImage()
        let imageView4 = UIImage(named: "Avatar4") ?? UIImage()
        liveAvatars.accept([imageView1, imageView2, imageView3, imageView4])
    }
    func addCategories(){
        categories.accept(["All", "UI/UX", "Illustration", "3D Animation"])
    }
}
