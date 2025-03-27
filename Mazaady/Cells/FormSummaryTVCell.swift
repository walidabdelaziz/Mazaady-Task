//
//  FormSummaryTVCell.swift
//  Mazaady
//
//  Created by Walid Ahmed on 27/03/2025.
//

import UIKit

class FormSummaryTVCell: UITableViewCell {

    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var keyLbl: UILabel!
    
    var item: SummaryItem? {
        didSet {
            guard let item = item else { return }
            keyLbl.text = item.key
            valueLbl.text = item.value
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
