//
//  SwitchLabelViewController.swift
//  JXDevelopmentKit
//
//  Created by jiaxu on 2018/7/23.
//  Copyright © 2018年 jiaxu. All rights reserved.
//

import UIKit
extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
class SwitchLabelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        //let titles = ["游戏","娱乐","大咖","新秀","颜值"]
        let titles = ["游戏","娱乐娱乐娱乐","大咖咖咖","新秀","颜咖值","大咖咖咖","娱乐娱乐娱乐","大咖咖咖","新秀"]
        let style = XXTitleStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true
        style.normalColor = UIColor.RGB(0, 0, 0)
        style.selectColor = UIColor.RGB(255, 127, 0)
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        var pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        if UIDevice.current.isX() {
            pageFrame = CGRect(x: 0, y: 88, width: view.bounds.width, height: view.bounds.height - 88)
        }
        
        let tallyView = XXTallyView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
        view.addSubview(tallyView)
    }
}
