//
//  ViewController.swift
//  JXDevelopmentKit
//
//  Created by jiaxu on 2018/7/23.
//  Copyright © 2018年 jiaxu. All rights reserved.
//

import UIKit
struct Kit {
    var kitName:String
    var kitArray:Array<String>
}
class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var controllerArray = [Kit]();
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView()
        
        let netToolArray = [String]()
        let newTool = Kit(kitName: "NetTool", kitArray: netToolArray)
        controllerArray.append(newTool)
        
        let UIkitArray = ["SwitchLabelViewController"]
        let UIkit = Kit(kitName: "UITool", kitArray: UIkitArray)
        controllerArray.append(UIkit)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //设置Large Title偏好设置为True
        if #available(iOS 11.0, *){
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //设置Large Title偏好设置为false
        if #available(iOS 11.0, *){
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
        let kit = controllerArray[indexPath.row]
        cell.textLabel?.text = kit.kitName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerArray.count;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kit = controllerArray[indexPath.row]
        let cell = tableview.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        guard kit.kitArray.count > 0 else {
            return
        }
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc : NextLevelViewController = story.instantiateViewController(withIdentifier: "NextLevelViewController") as! NextLevelViewController
        vc.listArr = kit.kitArray
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

