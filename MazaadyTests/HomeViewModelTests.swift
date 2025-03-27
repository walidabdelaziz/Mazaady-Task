//
//  HomeViewModelTests.swift
//  MazaadyTests
//
//  Created by Walid Ahmed on 27/03/2025.
//

import Testing
import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Mazaady

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }

    func testLiveAvatarsInitialization() {
        let expectedCount = 4
        XCTAssertEqual(viewModel.liveAvatars.value.count, expectedCount, "Live avatars should contain \(expectedCount) items.")
    }

    func testCategoriesInitialization() {
        let expectedCategoryCount = 4
        XCTAssertEqual(viewModel.categories.value.count, expectedCategoryCount, "Categories should contain \(expectedCategoryCount) items.")
    }
    
    func testSelectedCategoryUpdates() {
        let expectedIndex = 2
        viewModel.selectedCategoryIndex.accept(expectedIndex)
        
        XCTAssertEqual(viewModel.selectedCategoryIndex.value, expectedIndex, "Selected category index should update correctly.")
    }
    
    func testSelectedCategoryCoursesUpdates() {
        let observer = scheduler.createObserver([Course].self)
        
        viewModel.selectedCategoryCourses
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expectedCourses = viewModel.categories.value[0].courses
        XCTAssertEqual(observer.events.last?.value.element, expectedCourses, "Courses should update based on selected category.")
        
        viewModel.selectedCategoryIndex.accept(1) // UI/UX
        let expectedUiUxCourses = viewModel.categories.value[1].courses
        XCTAssertEqual(observer.events.last?.value.element, expectedUiUxCourses, "Courses should update correctly when category changes.")
    }
}

