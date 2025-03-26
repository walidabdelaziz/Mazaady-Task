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
    var categories = BehaviorRelay<[Category]>(value: [])
    let selectedCategoryIndex = BehaviorRelay<Int>(value: 0)
    var selectedCategoryCourses: Observable<[Course]> {
        return Observable.combineLatest(categories.asObservable(), selectedCategoryIndex.asObservable())
            .map { categories, selectedIndex in
                guard categories.indices.contains(selectedIndex) else { return [] }
                return categories[selectedIndex].courses
            }
    }
    
    init() {
        addLiveAvatars()
        addCategories()
     }
    func addLiveAvatars(){
        let imageView1 = UIImage(named: "Avatar1") ?? UIImage()
        let imageView2 = UIImage(named: "Avatar2") ?? UIImage()
        let imageView3 = UIImage(named: "Avatar3") ?? UIImage()
        let imageView4 = UIImage(named: "Avatar4") ?? UIImage()
        liveAvatars.accept([imageView1, imageView2, imageView3, imageView4])
    }
    func addCategories() {
        let uiUxCourses = [
            Course(
                id: 1,
                category: "UI/UX",
                title: "Step design sprint for beginner",
                duration: "5h 21m",
                lessons: 6,
                isFree: true,
                imageUrl: "course1",
                author: "Laurel Seilha",
                authorRole: "Product Designer",
                authorImageUrl: "author1"
            )
        ]
        let illustrationCourses = [
            Course(
                id: 2,
                category: "Illustration",
                title: "Basic illustration techniques",
                duration: "4h 10m",
                lessons: 2,
                isFree: false,
                imageUrl: "course2",
                author: "John Doe",
                authorRole: "Illustrator",
                authorImageUrl: "author2"
            )
        ]
        let animationCourses: [Course] = []
        let allCourses = uiUxCourses + illustrationCourses + animationCourses
        let categoriesData: [Category] = [
            Category(
                id: 1,
                name: "All",
                courses: allCourses
            ),
            Category(
                id: 2,
                name: "UI/UX",
                courses: uiUxCourses
            ),
            Category(
                id: 3,
                name: "Illustration",
                courses: illustrationCourses
            ),
            Category(
                id: 4,
                name: "3D Animation",
                courses: animationCourses
            )
        ]
        categories.accept(categoriesData)
    }
}
