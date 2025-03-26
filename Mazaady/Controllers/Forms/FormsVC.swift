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
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var optionArrow: UIImageView!
    @IBOutlet weak var optionLbl: UILabel!
    @IBOutlet weak var optionTF: UITextField!
    @IBOutlet weak var optionbgV: UIView!
    @IBOutlet weak var inputLbl: UILabel!
    @IBOutlet weak var inputTF: UITextField!
    @IBOutlet weak var inputbgV: UIView!
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
        bindViewModel()
    }
    func setupUI(){
        configureButtons()
        configureTextFields()
        [propertybgV, inputbgV, optionbgV].forEach {
            $0.isHidden = true
        }
        categoryLbl.text = "Category"
        subcategoryLbl.text = "SubCategory"
        propertyLbl.text = "Property"
        optionLbl.text = "Option"
        inputLbl.text = "Property Note"
        categoryTF.placeholder = "Choose Category"
        subcategoryTF.placeholder = "Choose SubCategory"
        propertyTF.placeholder = "Choose Property"
        optionTF.placeholder = "Choose Option"
        inputTF.placeholder = "Write Property Note"
        submitBtn.setTitle("Submit", for: .normal)
        resetBtn.setTitle("Reset", for: .normal)
    }
    func configureButtons() {
        [submitBtn, resetBtn].forEach {
            $0.layer.cornerRadius = 8
        }
        submitBtn.backgroundColor = .PrimaryColor
        submitBtn.setTitleColor(.white, for: .normal)
        resetBtn.backgroundColor = .white
        resetBtn.setTitleColor(.PrimaryColor, for: .normal)
        resetBtn.layer.borderWidth = 1
        resetBtn.layer.borderColor = UIColor.PrimaryColor.cgColor
    }
    func bindViewModel() {
        // bind reset button
        resetBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                self.resetSelection(resetCategory: true ,resetSubCategory: true, resetProperty: true, resetOption: true)
            }).disposed(by: disposeBag)
    }
    func configureTextFields() {
        [categoryTF,subcategoryTF,propertyTF, inputTF,optionTF].forEach {
            $0?.dropShadow(radius: 3, opacity: 0.08, offset: CGSize(width: 1, height: 1))
            $0?.layer.cornerRadius = 8
            $0?.paddingLeft(padding: 8)
            $0?.delegate = self
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    private func handleCategorySelection() {
        SelectionManager.shared.handleSelection(viewModel: formsViewModel, vc: self, type: .category) {
            [weak self] selectedData in
            guard let self = self else { return }
            categoryArrow.resetArrowRotation()
            if !selectedData.dismissVC_Without_Action {
                self.categoryTF.text = selectedData.selectedCategory?.name
                if selectedData.selectedCategory?.id != selectedData.selectedSubCategory?.parentID{
                    self.resetSelection(resetSubCategory: true, resetProperty: true, resetOption: true)
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
                    propertybgV.isHidden = selectedData.selectedSubCategory?.propertiesCount == 0 ? true : false
                    if self.formsViewModel.selectedData.value.selectedSubCategory?.id != selectedData.selectedSubCategory?.id{
                        self.resetSelection(resetProperty: true)
                    }
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
                self.propertyTF.text = selectedData.selectedProperty?.name
                inputbgV.isHidden = selectedData.selectedProperty?.type != "other" ? true : false
                optionbgV.isHidden = selectedData.selectedProperty?.type != "other" ? false : true
                if self.formsViewModel.selectedData.value.selectedOption?.id != selectedData.selectedOption?.id || selectedData.selectedProperty?.type == "other"{
                    self.resetSelection(resetOption: true)
                }
            }
        } setDataHandler: { [weak self] selectedData in
            guard let self = self else { return }
            self.formsViewModel.selectedData.accept(selectedData)
        }
        propertyArrow.rotateArrow()
    }
    private func handleOptionSelection() {
        SelectionManager.shared.handleSelection(viewModel: formsViewModel, vc: self, type: .option) {
            [weak self] selectedData in
            guard let self = self else { return }
            optionArrow.resetArrowRotation()
            if !selectedData.dismissVC_Without_Action {
                self.optionTF.text = selectedData.selectedOption?.name
            }
        } setDataHandler: { [weak self] selectedData in
            guard let self = self else { return }
            self.formsViewModel.selectedData.accept(selectedData)
        }
        optionArrow.rotateArrow()
    }
    private func resetSelection(resetCategory: Bool = false, resetSubCategory: Bool = false, resetProperty: Bool = false, resetOption: Bool = false) {
        var updatedData = formsViewModel.selectedData.value
        if resetCategory {
            categoryTF.text = ""
            updatedData.selectedCategory = nil
        }
        if resetSubCategory {
            subcategoryTF.text = ""
            [propertybgV, inputbgV, optionbgV].forEach {
                $0.isHidden = true
            }
            updatedData.selectedSubCategory = nil
        }
        if resetProperty {
            [propertyTF, inputTF, optionTF].forEach {
                $0.text = ""
            }
            updatedData.selectedProperty = nil
        }
        if resetOption {
            optionTF.text = ""
            updatedData.selectedOption = nil
        }
        formsViewModel.selectedData.accept(updatedData)
    }
}
extension FormsVC: UITextFieldDelegate {
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
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
        if textField == optionTF {
            handleOptionSelection()
            return false
        }
        return true
    }
}
