//
//  DropDownVC.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class DropDownVC: UIViewController {
    
    var onConfirm: ((SelectedData) -> Void)?
    var type: DataType?
    let disposeBag = DisposeBag()
    var formsViewModel = FormsViewModel()
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataTVHeight: NSLayoutConstraint!
    @IBOutlet weak var dataTV: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgV: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI(){
        bgV.dropShadow(radius: 3, opacity: 0.08, offset: CGSize(width: 1, height: 1))
        bgV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        dataTV.register(UINib(nibName: "DataTVCell", bundle: nil), forCellReuseIdentifier: "DataTVCell")
        dataTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        bottomConstraint.constant = 32
        
        setLocalizations()
    }
    func setLocalizations() {
        switch type {
        case .category:
            formsViewModel.getCategories { [weak self] in
                guard let self = self else { return }
                self.formsViewModel.currentDataSource.accept(self.formsViewModel.parentCategories.value)
            }
            titleLbl.text = "Categories"
        case .subCategory:
            titleLbl.text = "Sub Categories"
        case .property:
            titleLbl.text = "Properties"
            //                formsViewModel.currentDataSource.accept(formsViewModel.properties.value)
        default:
            break
        }
    }
    func dismissWithoutAction(){
        var updatedData = formsViewModel.selectedData.value
        updatedData.dismissVC_Without_Action = true
        formsViewModel.selectedData.accept(updatedData)
        formsViewModel.updateSubCategories()
        onConfirm!(formsViewModel.selectedData.value)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != bgV{
            dismissWithoutAction()
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize = newvalue as! CGSize
                dataTVHeight.constant = newsize.height
            }
        }
    }
    func bindViewModel(){
        // bind back button
        cancelBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else{return}
                self.dismissWithoutAction()
            }).disposed(by: disposeBag)
        // bind categories
        formsViewModel.currentDataSource
            .bind(to: dataTV.rx.items(cellIdentifier: "DataTVCell", cellType: DataTVCell.self)) { [weak self] row, category, cell in
                guard let self = self else { return }
                cell.selectionStyle = .none
                switch self.type {
                case .category:
                    cell.category = category
                    cell.updateCellUI(selectedItem: self.formsViewModel.selectedData.value.selectedCategory, item: category)
                case .subCategory:
                    cell.category = category
                    cell.updateCellUI(selectedItem: self.formsViewModel.selectedData.value.selectedSubCategory, item: category)
                case .property:
                    cell.category = category
                    cell.updateCellUI(selectedItem: self.formsViewModel.selectedData.value.selectedCategory, item: category)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        // Handle selection
        dataTV.rx.itemSelected
            .map { indexPath in
                return self.formsViewModel.currentDataSource.value[indexPath.row]
            }
            .subscribe(onNext: { [weak self] category in
                guard let self = self else { return }
                var updatedData = self.formsViewModel.selectedData.value
                switch self.type {
                case .category:
                    updatedData.selectedCategory = category
                    self.formsViewModel.selectedData.accept(updatedData)
                    self.formsViewModel.updateSubCategories()
                case .subCategory:
                    updatedData.selectedSubCategory = category
                case .property:
                    updatedData.selectedSubCategory = category
                default:
                    break
                }
                updatedData.dismissVC_Without_Action = false
                self.formsViewModel.selectedData.accept(updatedData)
                self.onConfirm?(self.formsViewModel.selectedData.value)
            })
            .disposed(by: disposeBag)
    }
}
