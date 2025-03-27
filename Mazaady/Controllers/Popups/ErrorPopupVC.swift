//
//  ErrorPopupVC.swift
//  Mazaady
//
//  Created by Walid Ahmed on 27/03/2025.
//

import UIKit

class ErrorPopupVC: UIViewController {
    
    var onDismiss: (() -> Void)?
    var message = ""
    
    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bgV.dropShadow(radius: 3, opacity: 0.1, offset: CGSize(width: 2, height: 2))
        messageLbl.text = message
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != bgV {
            onDismiss!()
        }
    }
}
