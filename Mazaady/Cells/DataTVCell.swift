//
//  DataTVCell.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import UIKit

class DataTVCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var bgV: UIView!


    var category: FormCategory? {
        didSet {
            guard let category = category else { return }
            titleLbl.text = category.name
        }
    }
//    var location: SearchLocation? {
//        didSet {
//            guard let location = location else { return }
//            titleLbl.text = location.title
//        }
//    }
//    var gender: String? {
//        didSet {
//            guard let gender = gender else { return }
//            titleLbl.text = gender
//        }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgV.dropShadow(radius: 3, opacity: 0.08, offset: CGSize(width: 1, height: 1))
    }

    func updateCellUI<T: Equatable>(selectedItem: T, item: T,changeBorderColor: Bool? = false) {
        if selectedItem == item{
            selectedIcon.image = UIImage(named: "selectedCell")
            titleLbl.textColor = .PrimaryColor
        }else{
            selectedIcon.image = UIImage(named: "unselectedCell")
            titleLbl.textColor = UIColor.DarkGreyColor
        }
    }
}
