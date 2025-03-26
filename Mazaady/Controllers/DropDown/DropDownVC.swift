//
//  DropDownVC.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import UIKit

class DropDownVC: UIViewController {
    
    var selectedData = SelectedData()
    var onConfirm: ((SelectedData) -> Void)?
    var type: DataType?
    
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataTVHeight: NSLayoutConstraint!
    @IBOutlet weak var dataTV: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgV: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
//        selectedData.dismissVC_Without_Action = true
        onConfirm!(selectedData)
    }
    func setupUI(){
        bgV.dropShadow(radius: 3, opacity: 0.08, offset: CGSize(width: 1, height: 1))
        bgV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
//        dataTV.delegate = self
//        dataTV.dataSource = self
        dataTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        dataTV.register(UINib(nibName: "DataTVCell", bundle: nil), forCellReuseIdentifier: "DataTVCell")
        bottomConstraint.constant = 32
        
        setLocalizations()
    }
    func setLocalizations(){
        switch type{
        case .category:
            titleLbl.text = "Categories"
        case .subcategory:
            titleLbl.text = "SubCategories"
        case .property:
            titleLbl.text = "Properties"
        default:
            break
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != bgV{
//            selectedData.dismissVC_Without_Action = true
            onConfirm!(selectedData)
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
}
