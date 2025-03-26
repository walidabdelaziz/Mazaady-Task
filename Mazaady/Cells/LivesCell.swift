//
//  LivesCell.swift
//  Mazaady
//
//  Created by Walid Ahmed on 25/03/2025.
//

import UIKit

class LivesCell: UICollectionViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var bgV: UIView!
    
    var liveAvatar: UIImage? {
        didSet {
            guard let liveAvatar = liveAvatar else { return }
            profileImg.image = liveAvatar
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImg.layer.cornerRadius = 20
        bgV.layer.cornerRadius = 24
        bgV.layer.borderWidth = 4
        bgV.layer.borderColor = UIColor.PrimaryColor.cgColor
    }
}
