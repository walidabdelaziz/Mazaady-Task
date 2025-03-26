//
//  FormsVC.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import UIKit

class FormsVC: UIViewController {

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
        }
    }

}
