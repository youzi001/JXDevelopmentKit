//
//  XXContentView.swift
//  XXTallyView
//
//  Created by 李珈旭 on 2017/5/23.
//  Copyright © 2017年 JiaXu. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

protocol XXContentViewDelegate: class {
    func contentView(_ contentView: XXContentView, targetIndex: Int)
    func contentView(_ contentView: XXContentView, targetIndex: Int, progress: CGFloat)
}

class XXContentView: UIView {
    
    weak var delegate : XXContentViewDelegate?
    
    fileprivate var startOffestX : CGFloat = 0.0
    
    fileprivate var isForbidScroll :Bool = false
    
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
       let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    init(frame: CGRect,childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension XXContentView {
    fileprivate func setupUI(){
        // 将所有的子控制器添加到父控制器中
        for childVc in childVcs{
            parentVc.addChildViewController(childVc)
        }
        // 添加UICollectionView用于展示
        addSubview(collectionView)
    }
}
extension XXContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

// MARK:- UICollectionView Delegate 
extension XXContentView : UICollectionViewDelegate{

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startOffestX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard startOffestX != scrollView.contentOffset.x,!isForbidScroll else {
            return
        }
        
        var targetIndex = 0
        var progress : CGFloat = 0.0
        let currentIndex = Int(startOffestX / scrollView.bounds.width)
        if startOffestX < scrollView.contentOffset.x { // 左滑动
            
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count - 1 {
               targetIndex = childVcs.count - 1
            }
            
            progress = (scrollView.contentOffset.x - startOffestX)/scrollView.bounds.width
            
            if progress >= 1  {
                progress = 1
            }
        }else{ // 右滑动
            targetIndex = currentIndex - 1
            if targetIndex < 0  {
                targetIndex = 0
            }
            progress = (startOffestX - scrollView.contentOffset.x)/scrollView.bounds.width
            if progress >= 1  {
                progress = 1
            }
        }
//        print(progress)
        //通知代理
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
        scrollView.isScrollEnabled = true
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            contentEndScroll()
        }else{
            scrollView.isScrollEnabled = false
        }
    }
    private func contentEndScroll(){
        
        guard !isForbidScroll else { return }
        
        // 1.获取滚动到的位置
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        // 2.通知titleView进行调整
        delegate?.contentView(self, targetIndex: currentIndex)
        
    }
    
}
// MARK:- 遵守titleView点击代理
extension XXContentView : XXTitleViewDelegate{
    func titleView(_ titleView: XXTitleView, targetIndex: Int) {
        isForbidScroll = true
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
