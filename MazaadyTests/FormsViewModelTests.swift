//
//  MazaadyTests.swift
//  MazaadyTests
//
//  Created by Walid Ahmed on 25/03/2025.
//

import Testing
import XCTest
import RxSwift
import RxCocoa
@testable import Mazaady

class FormsViewModelTests: XCTestCase {
    var viewModel: FormsViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        viewModel = FormsViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }

    func testGetCategories() {
        let mockCategories = [
            FormCategory(id: 1, name: "Cars", parentID: nil),
            FormCategory(id: 2, name: "Sedan", parentID: 1),
            FormCategory(id: 3, name: "SUV", parentID: 1)
        ]

        viewModel.getCategories()
        
        // Simulate success response
        viewModel.parentCategories.accept(mockCategories.filter { $0.parentID == nil })
        viewModel.subCategories.accept(mockCategories.filter { $0.parentID != nil })
        
        XCTAssertEqual(viewModel.parentCategories.value.count, 1)
        XCTAssertEqual(viewModel.subCategories.value.count, 2)
    }

    func testGetProperties() {
        let mockProperties = [
            FormCategory(id: 10, name: "Color", type: "dropdown"),
            FormCategory(id: 11, name: "Transmission", type: "dropdown")
        ]

        viewModel.getProperties()

        // Simulate response with "Other" added
        var updatedProperties = mockProperties
        updatedProperties.append(FormCategory(id: 0, name: "Other", type: "other"))

        viewModel.parentProperties.accept(updatedProperties)

        XCTAssertEqual(viewModel.parentProperties.value.count, 3)
        XCTAssertEqual(viewModel.parentProperties.value.last?.name, "Other")
    }

    func testUpdateSubCategories() {
        let mockSubCategories = [
            FormCategory(id: 2, name: "Sedan", parentID: 1),
            FormCategory(id: 3, name: "SUV", parentID: 1),
            FormCategory(id: 4, name: "Motorcycle", parentID: 5)
        ]

        viewModel.subCategories.accept(mockSubCategories)

        viewModel.selectedData.accept(SelectedData(selectedCategory: FormCategory(id: 1, name: "Cars", parentID: nil)))
        viewModel.updateSubCategories()

        XCTAssertEqual(viewModel.currentDataSource.value.count, 2)
        XCTAssertTrue(viewModel.currentDataSource.value.allSatisfy { $0.parentID == 1 })
    }
}

