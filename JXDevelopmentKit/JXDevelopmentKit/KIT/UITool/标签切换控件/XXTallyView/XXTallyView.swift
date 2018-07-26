//
//  XXTallyView.swift
//  XXTallyView
//
//  Created by 李珈旭 on 2017/5/23.
//  Copyright © 2017年 JiaXu. All rights reserved.
//

import UIKit

class XXTallyView: UIView {
    

    
    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var style : XXTitleStyle
    fileprivate var titleView : XXTitleView!
    
    init(frame: CGRect, titles: [String], childVcs: [UIViewController], parentVc: UIViewController, style: XXTitleStyle) {
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame:frame)
        
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK:- 设置UI界面
extension XXTallyView{
    fileprivate func setupUI(){
        setupTitleView()
        setupContentView()
    }
    private func setupTitleView(){
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = XXTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        addSubview(titleView)
    }
    private func setupContentView(){
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = XXContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
