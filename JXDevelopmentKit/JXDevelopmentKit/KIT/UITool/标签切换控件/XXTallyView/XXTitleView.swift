//
//  XXTitleView.swift
//  XXTallyView
//
//  Created by 李珈旭 on 2017/5/23.
//  Copyright © 2017年 JiaXu. All rights reserved.
//

import UIKit
protocol XXTitleViewDelegate : class {
    func titleView(_ titleView: XXTitleView, targetIndex: Int)
}

class XXTitleView: UIView {
    
    weak var delegate : XXTitleViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var style : XXTitleStyle
    fileprivate lazy var currentIndex = 0
    
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    fileprivate lazy var bottomLine : UIView = {
       let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height = self.style.scrollLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        return bottomLine
    }()
    init(frame:CGRect, titles: [String], style: XXTitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame:frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension XXTitleView{
    fileprivate func setupUI(){
        
        // 1.将scrollview加入View
        addSubview(scrollView)
        
        // 2.将titleLabel添加到scrollView
        setupTitleLabel()
        
        // 3.设置titleLabel的frame
        setupTitleLabelsFrame()
        
        // 4.添加滚动条
        if style.isShowScrollLine{
            scrollView.addSubview(bottomLine)
        }
        
    }
    private func setupTitleLabel(){
        for (i,title) in titles.enumerated(){
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = style.normalColor
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor
            
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
            
        }
    }
    private func setupTitleLabelsFrame(){
        let count = titles.count
        for (i,label) in titleLabels.enumerated(){
            var w: CGFloat = 0
            let h: CGFloat = bounds.height
            var x: CGFloat = 0
            let y: CGFloat = 0
            
            if style.isScrollEnable { // 可以滚动
                
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey:label.font], context: nil).width
                 if i == 0{
                    x = style.itemMargin * 0.5
                    if style.isShowScrollLine{
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }

                } else {
                    x = titleLabels[i - 1].frame.maxX + style.itemMargin
                }
            }else{ // 不能滚动
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
                
                if i == 0 && style.isShowScrollLine {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
               
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            // 开启缩放的情况下第一个title缩放
            if i == 0 {
                let scale = style.isScale ? style.scaleRange : 1.0
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}
// MARK:- 监听事件
extension XXTitleView{
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer){
        
        let targetLabel = tapGes.view as! UILabel

        adjustTitleLabel(targetIndex: targetLabel.tag)
        if style.isShowScrollLine{
            UIView.animate(withDuration: 0.25) {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            }
        }
        
        
        delegate?.titleView(self, targetIndex: currentIndex)
    }
    fileprivate func adjustTitleLabel(targetIndex: Int){
        
        if targetIndex == currentIndex { return }
        
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
        
        currentIndex = targetLabel.tag
        
        if style.isScrollEnable{
            var offestX = targetLabel.center.x - scrollView.bounds.width * 0.5
            if offestX < 0  {
                offestX = 0
            }
            if offestX > (scrollView.contentSize.width - scrollView.bounds.width) {
                offestX = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offestX, y: 0), animated: true)
        }
        // label点击放大
        if style.isScale{
            sourceLabel.transform = CGAffineTransform.identity
            targetLabel.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
        }
    }
}

// MARK:- 遵守XXContentViewDelegate
extension XXTitleView: XXContentViewDelegate{
    func contentView(_ contentView: XXContentView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    func contentView(_ contentView: XXContentView, targetIndex: Int, progress: CGFloat) {
        //取出label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selectColor, style.normalColor)
        let selectedRGB = style.selectColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        targetLabel.textColor = UIColor.RGB(normalRGB.0 + deltaRGB.0 * progress, normalRGB.1 + deltaRGB.1 * progress, normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor.RGB(selectedRGB.0 - deltaRGB.0 * progress, selectedRGB.1 - deltaRGB.1 * progress, selectedRGB.2 - deltaRGB.2 * progress)
        //底部line的渐变
        if style.isShowScrollLine{
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
        //label放大
        if style.isScale{
            let scaleD = (style.scaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleD, y: style.scaleRange - scaleD)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleD, y:  1.0 + scaleD)
        }
        
    }
    
}
