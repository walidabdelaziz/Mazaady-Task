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
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var dataTVHeight: NSLayoutConstraint!
    @IBOutlet weak var dataTV: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgV: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    func setupUI() {
        configureView()
        configureSearchField()
        configureTableView()
        updateUIForType()
    }
    func configureView() {
        bgV.dropShadow(radius: 3, opacity: 0.08, offset: CGSize(width: 1, height: 1))
        bgV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    func configureSearchField() {
        searchTF.dropShadow(radius: 3, opacity: 0.08, offset: CGSize(width: 1, height: 1))
        searchTF.layer.cornerRadius = 8
        searchTF.paddingLeft(padding: 8)
    }
    func configureTableView() {
        dataTV.register(UINib(nibName: "DataTVCell", bundle: nil), forCellReuseIdentifier: "DataTVCell")
        dataTV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    func updateUIForType() {
        switch type {
        case .category:
            formsViewModel.getCategories()
            setTitleAndPlaceholder(title: "Categories", placeholder: "Search Categories")
        case .subCategory:
            setTitleAndPlaceholder(title: "Sub Categories", placeholder: "Search Sub Categories")
        case .property:
            setTitleAndPlaceholder(title: "Properties", placeholder: "Search Properties")
        default:
            break
        }
    }
    func setTitleAndPlaceholder(title: String, placeholder: String) {
        titleLbl.text = title
        searchTF.placeholder = placeholder
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
        // Handle search
        searchTF.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    if self.type == .category {
                        self.formsViewModel.currentDataSource.accept(self.formsViewModel.parentCategories.value)
                    } else if self.type == .subCategory {
                        self.formsViewModel.currentDataSource.accept(self.formsViewModel.subCategories.value.filter {
                            $0.parentID == self.formsViewModel.selectedData.value.selectedCategory?.id
                        })
                    }
                } else {
                    let source = (self.type == .category) ? self.formsViewModel.parentCategories.value :
                                self.formsViewModel.subCategories.value.filter { $0.parentID == self.formsViewModel.selectedData.value.selectedCategory?.id }

                    let filteredResults = source.filter {
                        $0.name?.lowercased().contains(query.lowercased()) ?? false
                    }
                    self.formsViewModel.currentDataSource.accept(filteredResults)
                }
            })
            .disposed(by: disposeBag)

    }
}
