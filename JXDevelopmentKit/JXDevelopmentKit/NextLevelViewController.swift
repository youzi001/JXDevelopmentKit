//
//  NextLevelViewController.swift
//  JXDevelopmentKit
//
//  Created by jiaxu on 2018/7/23.
//  Copyright © 2018年 jiaxu. All rights reserved.
//

import UIKit

class NextLevelViewController: UIViewController {
    public var listArr = [String]()
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView()
        
    }
}
extension NextLevelViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nextCell", for: indexPath)
        cell.textLabel?.text = listArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let name = listArr[indexPath.row]
        let cls:AnyClass? = NSClassFromString(nameSpace + "." + name)
        let viewControllerCls = cls as! UIViewController.Type
        let vc = viewControllerCls.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
