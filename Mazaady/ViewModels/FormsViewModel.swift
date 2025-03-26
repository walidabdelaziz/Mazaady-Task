//
//  FormsViewModel.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//


import Foundation
import RxSwift
import RxCocoa
import Alamofire

class FormsViewModel {
    let isLoading = BehaviorRelay<Bool>(value: false)
    var parentCategories = BehaviorRelay<[FormCategory]>(value: [])
    var subCategories = BehaviorRelay<[FormCategory]>(value: [])
    var originalDataSource = BehaviorRelay<[FormCategory]>(value: [])
    var currentDataSource = BehaviorRelay<[FormCategory]>(value: [])
    var selectedData = BehaviorRelay<SelectedData>(value: SelectedData())
    var parentProperties = BehaviorRelay<[FormCategory]>(value: [])

    func getCategories() {
        isLoading.accept(true)
        FormsService().getCategories(completion: { [weak self] result in
            guard let self = self else { return }
            self.isLoading.accept(false)
            switch result {
            case .success(let response):
                let (parents, subs) = self.splitCategories(response)
                self.parentCategories.accept(parents)
                self.originalDataSource.accept(parents)
                self.currentDataSource.accept(parents)
                self.subCategories.accept(subs)
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        })
    }
    func getProperties() {
        isLoading.accept(true)
        FormsService().getProperties(categoryId: selectedData.value.selectedSubCategory?.id ?? 0, completion: { [weak self] result in
            guard let self = self else { return }
            self.isLoading.accept(false)
            switch result {
            case .success(let response):
                let otherProperty = FormCategory(id: 0, name: "Other",type: "other")
                var updatedResponse = response
                updatedResponse.append(otherProperty)
                self.parentProperties.accept(updatedResponse)
                self.currentDataSource.accept(updatedResponse)
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        })
    }
    //  Splits categories into parent and subcategories
    private func splitCategories(_ categories: [FormCategory]) -> ([FormCategory], [FormCategory]) {
        let parentCategories = categories.filter { $0.parentID == nil }
        let subCategories = categories.filter { $0.parentID != nil }
        return (parentCategories, subCategories)
    }
    //  Updates subcategories dynamically based on selected category
    func updateSubCategories() {
        guard let selectedCategory = selectedData.value.selectedCategory else {
            currentDataSource.accept([])
            return
        }
        let filteredSubCategories = subCategories.value.filter { $0.parentID == selectedCategory.id }
        currentDataSource.accept(filteredSubCategories)
    }
    //  Updates subcategories dynamically based on selected category
    func updateOptions() {
        let filteredOptions = selectedData.value.selectedProperty?.options ?? []
        currentDataSource.accept(filteredOptions)
    }
}
