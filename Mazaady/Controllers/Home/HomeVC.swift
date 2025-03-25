//
//  HomeVC.swift
//  Mazaady
//
//  Created by Walid Ahmed on 25/03/2025.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class HomeVC: UIViewController {

    let disposeBag = DisposeBag()
    let homeViewModel = HomeViewModel()

    @IBOutlet weak var livesCV: UICollectionView!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var headerbgV: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pointsLbl.textColor = .SecondaryColor
        homeViewModel.addLiveAvatars()
        setProductsCollectionViewsUI(collectionView: livesCV, nibName: "LivesCell")
        bindViewModel()
    }
    func setProductsCollectionViewsUI(collectionView: UICollectionView, nibName: String){
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        let layout = UICollectionViewFlowLayout()
        let cellHeight = collectionView.frame.height
        layout.itemSize = CGSize(width: cellHeight, height: cellHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    func bindViewModel(){
        // bind products
        homeViewModel.liveAvatars
            .bind(to: livesCV.rx.items(cellIdentifier: "LivesCell", cellType: LivesCell.self)) { row, liveAvatar, cell in
                cell.liveAvatar = liveAvatar
             }.disposed(by: disposeBag)
    }
}
