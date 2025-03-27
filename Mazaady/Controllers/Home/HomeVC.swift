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
import AdvancedPageControl

class HomeVC: UIViewController {
    
    let disposeBag = DisposeBag()
    let homeViewModel = HomeViewModel()
    
    @IBOutlet weak var coursesCV: UICollectionView!
    @IBOutlet weak var coursesPageControl: AdvancedPageControlView!
    @IBOutlet weak var categoriesCV: UICollectionView!
    @IBOutlet weak var upcomingCoursesLbl: UILabel!
    @IBOutlet weak var livesCV: UICollectionView!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var headerbgV: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        bindViewModel()
    }
    func setupUI(){
        setCollectionViewsConfiguration()
        pointsLbl.textColor = .SecondaryColor
        upcomingCoursesLbl.attributedText = NSAttributedString.styledText(
            mainText: "upcoming".localized(),
            subText: "courses_of_this_week".localized(),
            mainFont: UIFont.systemFont(ofSize: 18, weight: .semibold),
            subFont: UIFont.systemFont(ofSize: 18, weight: .regular)
        )
        pointsLbl.attributedText = NSAttributedString.styledText(
            mainText: "+1600",
            subText: "points".localized(),
            mainFont: UIFont.systemFont(ofSize: 14, weight: .semibold),
            subFont: UIFont.systemFont(ofSize: 14, weight: .regular)
        )
    }
    func setCollectionViewsConfiguration(){
        livesCV.configureCollectionView(
            nibName: "LivesCell",
            itemSize: CGSize(width: livesCV.frame.height, height: livesCV.frame.height),
            lineSpacing: 0,
            interItemSpacing: 0
        )
        
        categoriesCV.configureCollectionView(
            nibName: "CategoriesCell",
            estimatedSize: true
        )
        
        coursesCV.configureCollectionView(
            nibName: "CoursesCell",
            scrollDirection: .horizontal,
            useCarousel: true,
            estimatedSize: false,
            itemSize: CGSize(width: UIScreen.main.bounds.width / 2, height: coursesCV.frame.height),
            lineSpacing: 4,
            interItemSpacing: 0,
            contentInsets: .zero
        )
    }

    func setPageControlCount(){
        let courses =  homeViewModel.categories.value[homeViewModel.selectedCategoryIndex.value].courses
        coursesPageControl.isHidden = courses.isEmpty ? true : false
        coursesPageControl.numberOfPages = courses.count
        coursesPageControl.drawer = ExtendedDotDrawer(numberOfPages: courses.count, height: 10, width: 10, space: 5,raduis: 10, currentItem: 0, indicatorColor: .PrimaryColor, dotsColor: UIColor.LightGreyColor,borderWidth: 0)
    }
    func bindViewModel(){
        // bind live avatars
        homeViewModel.liveAvatars
            .bind(to: livesCV.rx.items(cellIdentifier: "LivesCell", cellType: LivesCell.self)) { row, liveAvatar, cell in
                cell.liveAvatar = liveAvatar
            }.disposed(by: disposeBag)
        
        // bind categories
        homeViewModel.categories
            .bind(to: categoriesCV.rx.items(cellIdentifier: "CategoriesCell", cellType: CategoriesCell.self)) {[weak self] row, category, cell in
                guard let self = self else{return}
                cell.category = category
                cell.updateCellUI(selectedItem: self.homeViewModel.selectedCategoryIndex.value, item: row)
            }
            .disposed(by: disposeBag)
        
        // Observe selected index to update UI
        homeViewModel.selectedCategoryIndex
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.categoriesCV.reloadData()
                self.coursesCV.reloadData()
                self.setPageControlCount()
            })
            .disposed(by: disposeBag)
        
        // Observe categories to update UI
        homeViewModel.categories
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setPageControlCount()
            })
            .disposed(by: disposeBag)
        
        // Handle category selection and scrolling
        Observable.zip(
            categoriesCV.rx.modelSelected(CoursesCategory.self),
            categoriesCV.rx.itemSelected
        )
        .subscribe(onNext: { [weak self] category, indexPath in
            guard let self = self else { return }
            self.homeViewModel.selectedCategoryIndex.accept(indexPath.row)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.scrollToCategory(indexPath: indexPath)
            }
        })
        .disposed(by: disposeBag)
        
        // bind courses
        homeViewModel.selectedCategoryCourses
            .bind(to: coursesCV.rx.items(cellIdentifier: "CoursesCell", cellType: CoursesCell.self)) { row, course, cell in
                cell.course = course
            }
            .disposed(by: disposeBag)
    }
    func scrollToCategory(indexPath: IndexPath) {
        guard indexPath.row < homeViewModel.categories.value.count else { return }
        guard categoriesCV.numberOfItems(inSection: 0) > indexPath.row else { return }
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.categoriesCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
