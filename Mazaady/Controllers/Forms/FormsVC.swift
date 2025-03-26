//
//  FormsVC.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class FormsVC: UIViewController {

    let disposeBag = DisposeBag()
    let formsViewModel = FormsViewModel()
    
    @IBOutlet weak var propertyArrow: UIImageView!
    @IBOutlet weak var propertyTF: UITextField!
    @IBOutlet weak var propertyLbl: UILabel!
    @IBOutlet weak var propertybgV: UIView!
    @IBOutlet weak var subcategoryArrow: UIImageView!
    @IBOutlet weak var subcategoryLbl: UILabel!
    @IBOutlet weak var subcategoryTF: UITextField!
    @IBOutlet weak var subcategorybgV: UIView!
    @IBOutlet weak var categoryArrow: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var categorybgV: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    func setupUI(){
        categoryLbl.text = "Category"
        subcategoryLbl.text = "SubCategory"
        propertyLbl.text = "Property"
        categoryTF.placeholder = "Choose Category"
        subcategoryTF.placeholder = "Choose SubCategory"
        propertyTF.placeholder = "Choose Property"
        [categoryTF,subcategoryTF,propertyTF].forEach {
            $0?.dropShadow(radius: 3, opacity: 0.08, offset: CGSize(width: 1, height: 1))
            $0?.layer.cornerRadius = 8
            $0?.paddingLeft(padding: 8)
            $0?.delegate = self
        }
    }
    private func handleCategorySelection() {
        SelectionManager.shared.handleSelection(viewModel: formsViewModel, vc: self, type: .category) {
            [weak self] selectedData in
            guard let self = self else { return }
            categoryArrow.resetArrowRotation()
            if !selectedData.dismissVC_Without_Action {
                self.categoryTF.text = selectedData.selectedCategory?.name
                if selectedData.selectedCategory?.id != selectedData.selectedSubCategory?.parentID{
                    subcategoryTF.text = ""
                    var updatedData = self.formsViewModel.selectedData.value
                    updatedData.selectedSubCategory = nil
                    self.formsViewModel.selectedData.accept(updatedData)
                }
            }
        } setDataHandler: { [weak self] selectedData in
            guard let self = self else { return }
            self.formsViewModel.selectedData.accept(selectedData)
        }
        categoryArrow.rotateArrow()
    }
    private func handleSubCategorySelection() {
        if categoryTF.text?.isEmpty == true{
            
        }else{
            SelectionManager.shared.handleSelection(viewModel: formsViewModel, vc: self, type: .subCategory) {
                [weak self] selectedData in
                guard let self = self else { return }
                subcategoryArrow.resetArrowRotation()
                if !selectedData.dismissVC_Without_Action {
                    self.subcategoryTF.text = selectedData.selectedSubCategory?.name
                }
            } setDataHandler: { [weak self] selectedData in
                guard let self = self else { return }
                self.formsViewModel.selectedData.accept(selectedData)
            }
            subcategoryArrow.rotateArrow()
        }
    }
    private func handlePropertySelection() {
        SelectionManager.shared.handleSelection(viewModel: formsViewModel, vc: self, type: .property) {
            [weak self] selectedData in
            guard let self = self else { return }
            propertyArrow.resetArrowRotation()
            if !selectedData.dismissVC_Without_Action {
//                self.propertyTF.text = selectedData.selectedProperty?.name
            }
        } setDataHandler: { [weak self] selectedData in
            guard let self = self else { return }
            self.formsViewModel.selectedData.accept(selectedData)
        }
        propertyArrow.rotateArrow()
    }
}
extension FormsVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == categoryTF {
            handleCategorySelection()
            return false
        }
        if textField == subcategoryTF {
            handleSubCategorySelection()
            return false
        }
        if textField == propertyTF {
            handlePropertySelection()
            return false
        }
        return true
    }
}
