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
    var propertyInputValue = BehaviorRelay<String>(value: "")
    var parentCategories = BehaviorRelay<[FormCategory]>(value: [])
    var subCategories = BehaviorRelay<[FormCategory]>(value: [])
    var originalDataSource = BehaviorRelay<[FormCategory]>(value: [])
    var currentDataSource = BehaviorRelay<[FormCategory]>(value: [])
    var selectedData = BehaviorRelay<SelectedData>(value: SelectedData())
    var parentProperties = BehaviorRelay<[FormCategory]>(value: [])
    var summaryItems = BehaviorRelay<[SummaryItem]>(value: [])

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
    //  Updates options dynamically based on selected property
    func updateOptions() {
        let filteredOptions = selectedData.value.selectedProperty?.options ?? []
        currentDataSource.accept(filteredOptions)
    }
    func updateSummary() {
        var items: [SummaryItem] = []
        if let category = selectedData.value.selectedCategory?.name {
            items.append(SummaryItem(key: "Category", value: category))
        }
        if let subCategory = selectedData.value.selectedSubCategory?.name {
            items.append(SummaryItem(key: "Subcategory", value: subCategory))
        }
        if let property = selectedData.value.selectedProperty?.name {
            items.append(SummaryItem(key: "Property", value: property))
        }
        if selectedData.value.selectedProperty?.type == "other" && !propertyInputValue.value.isEmpty{
            items.append(SummaryItem(key: "Property Note", value: propertyInputValue.value))
        }else{
            if let option = selectedData.value.selectedOption?.name {
                items.append(SummaryItem(key: "Option", value: option))
            }
        }
        summaryItems.accept(items)
    }

}
