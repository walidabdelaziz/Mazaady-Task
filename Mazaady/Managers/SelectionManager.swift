//
//  SelectionManager.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import UIKit
class SelectionManager{
    static let shared = SelectionManager()
    private init() {}
    func handleSelection(viewModel: FormsViewModel,vc: UIViewController,type: DataType, completionHandler: @escaping (SelectedData) -> Void,setDataHandler: @escaping (SelectedData) -> Void){
        vc.parent?.view.alpha = 0.3
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DropDownVC = storyboard.instantiateViewController(withIdentifier: "DropDownVC") as! DropDownVC
        DropDownVC.formsViewModel = viewModel
        DropDownVC.type = type
        DropDownVC.onConfirm = {selectedData in
            setDataHandler(selectedData)
            vc.dismiss(animated: true){
                vc.parent?.view.alpha = 1
                 completionHandler(selectedData)
            }
        }
        DropDownVC.modalPresentationStyle = .overCurrentContext
        vc.present(DropDownVC, animated: true)
    }
     func showAlert(_ errorMessage: String, vc: UIViewController){
        vc.parent?.view.alpha = 0.3
        let PopupStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let ErrorPopupVC = PopupStoryBoard.instantiateViewController(withIdentifier: "ErrorPopupVC") as! ErrorPopupVC
        ErrorPopupVC.modalPresentationStyle = .overCurrentContext
        ErrorPopupVC.message = errorMessage
        ErrorPopupVC.onDismiss = {
        vc.dismiss(animated: true) {
                vc.parent?.view.alpha = 1
            }
        }
        vc.present(ErrorPopupVC, animated: true, completion: nil)
    }
}
