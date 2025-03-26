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
    var currentDataSource = BehaviorRelay<[FormCategory]>(value: [])
    var selectedData = BehaviorRelay<SelectedData>(value: SelectedData())

    func getCategories(completion: @escaping () -> Void) {
        isLoading.accept(true)
        FormsManager().getCategories(params: [:], completion: { [weak self] result in
            guard let self = self else { return }
            self.isLoading.accept(false)
            switch result {
            case .success(let response):
                let (parents, subs) = self.splitCategories(response)
                self.parentCategories.accept(parents)
                self.subCategories.accept(subs)
//                self.properties.accept([]) // If properties exist, populate them

                completion() // ✅ Notify UI that data is ready
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        })
    }
    private func splitCategories(_ categories: [FormCategory]) -> ([FormCategory], [FormCategory]) {
        let parentCategories = categories.filter { $0.parentID == nil }
        let subCategories = categories.filter { $0.parentID != nil }
        return (parentCategories, subCategories)
    }
    
    func updateSubCategories() {
        guard let selectedCategory = selectedData.value.selectedCategory else {
            currentDataSource.accept([]) // ✅ Clear subcategories if no category is selected
            return
        }
        
        let filteredSubCategories = subCategories.value.filter { $0.parentID == selectedCategory.id }
        currentDataSource.accept(filteredSubCategories) // ✅ Ensure UI updates immediately
    }


 
}
