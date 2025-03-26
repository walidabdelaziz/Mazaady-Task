//
//  CoursesCell.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import UIKit
import FSPagerView

class CoursesCell: FSPagerViewCell {

    @IBOutlet weak var courseNameLbl: UILabel!
    @IBOutlet weak var authorRoleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var authorImg: UIImageView!
    @IBOutlet weak var free2Lbl: UILabel!
    @IBOutlet weak var free2bgV: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categorybgV: UIView!
    @IBOutlet weak var lessonsLbl: UILabel!
    @IBOutlet weak var lessonsbgV: UIView!
    @IBOutlet weak var freeLbl: UILabel!
    @IBOutlet weak var freebgV: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var course: Course? {
        didSet {
            guard let course = course else { return }
            authorLbl.text = course.author
            authorRoleLbl.text = course.authorRole
            courseNameLbl.text = course.title
            timeLbl.text = course.duration
            lessonsLbl.text = "\(course.lessons) lessons"
            categoryLbl.text = course.category
            freeLbl.text = "Free e-book"
            free2Lbl.text = "Free"
            [freebgV,free2bgV].forEach {
                $0.isHidden = course.isFree ? false : true
            }
            authorImg.image = UIImage(named: course.authorImageUrl)
            img.image = UIImage(named: course.imageUrl)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.cornerRadius = 24
        layer.cornerRadius = 24
        contentView.layer.shadowRadius = 0
        freebgV.layer.cornerRadius = 10
        [free2bgV,categorybgV,lessonsbgV].forEach {
            $0.layer.cornerRadius = 8
        }
        freebgV.backgroundColor = UIColor.SoftYellow
        free2bgV.backgroundColor = UIColor.PurpleColor
        lessonsbgV.backgroundColor = UIColor.TurquoiseColor
        categorybgV.backgroundColor = UIColor.DeepBlue
        [authorRoleLbl,timeLbl].forEach {
            $0?.textColor = .DarkGreyColor
        }
    }
}

