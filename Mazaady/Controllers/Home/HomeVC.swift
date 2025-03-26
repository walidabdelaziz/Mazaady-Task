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
import FSPagerView
import AdvancedPageControl

class HomeVC: UIViewController, UICollectionViewDelegate {
    
    let disposeBag = DisposeBag()
    let homeViewModel = HomeViewModel()
    
    @IBOutlet weak var coursesPageViewer: FSPagerView!{
        didSet {
            coursesPageViewer.register(UINib(nibName: "CoursesCell", bundle: nil), forCellWithReuseIdentifier: "cell")
//            coursesPageViewer.interitemSpacing = 0
            coursesPageViewer.transformer = FSPagerViewTransformer(type: .linear)
            coursesPageViewer.interitemSpacing = 20
            coursesPageViewer.itemSize = CGSize(width: 370, height: 370)
        }
    }
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
        homeViewModel.addLiveAvatars()
        homeViewModel.addCategories()
        bindViewModel()
    }
    func setupUI(){
        setCollectionViewsConfiguration()
        setPageViewerConfiguration()
        pointsLbl.textColor = .SecondaryColor
        upcomingCoursesLbl.attributedText = NSAttributedString.styledText(
            mainText: "Upcoming",
            subText: "courses of this week",
            mainFont: UIFont.systemFont(ofSize: 18, weight: .semibold),
            subFont: UIFont.systemFont(ofSize: 18, weight: .regular)
        )
        pointsLbl.attributedText = NSAttributedString.styledText(
            mainText: "+1600",
            subText: "points",
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
    }
    func setPageViewerConfiguration(){
        [coursesPageViewer].forEach{
            $0?.delegate = self
            $0?.dataSource = self
        }
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
                self.coursesPageViewer.reloadData()
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
            categoriesCV.rx.modelSelected(Category.self),
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
extension HomeVC: FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return homeViewModel.categories.value[homeViewModel.selectedCategoryIndex.value].courses.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! CoursesCell
        let course = homeViewModel.categories.value[homeViewModel.selectedCategoryIndex.value].courses[index]
        cell.course = course
        return cell
    }
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        coursesPageControl.setPage(pagerView.currentIndex)
    }
}

