//
//  CategoriesCell.swift
//  Mazaady
//
//  Created by Walid Ahmed on 25/03/2025.
//

import UIKit

class CategoriesCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgV: UIView!
    
    var category: String? {
        didSet {
            guard let category = category else { return }
            titleLbl.text = category
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgV.layer.cornerRadius = 8
    }
    func updateCellUI<T: Equatable>(selectedItem: T, item: T) {
        if selectedItem == item{
            titleLbl.textColor = .white
            bgV.backgroundColor = .PrimaryColor
        } else {
            titleLbl.textColor = .DarkGreyColor
            bgV.backgroundColor = .LightGreyColor
        }
    }
}
