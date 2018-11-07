//
//  CLSearchLocationController.swift
//  Bus
//
//  Created by cleven on 2018/11/2.
//  Copyright © 2018 cleven. All rights reserved.
//

import UIKit
import CoreLocation

class CLSearchLocationController: CLRootViewController {

    public var selectLocationFinished:((CLAroundPoisModel)->())?
    
    private var isLocationFinish:Bool = false
    private var tableView:UITableView! = nil
    private var dataArray:[CLAroundPoisModel] = [CLAroundPoisModel]()
    private var textField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        getCurrentLocation()
    }
    
    private func setupNavBar() {
        
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: ScreenInfo.Width - ScreenInfo.scaleLength(180), height: 35))
        textField.backgroundColor = UIColor.cl_colorWithHex(hex: 0xF6F4F7)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.placeholder = "请输入地点名称"
        textField.textAlignment = .center
        navigationItem.titleView = textField
        textField.addTarget(self, action: #selector(self.textFieldTextChange(textField:)), for: .editingChanged)
        
        
    }
    
    private func setupUI(){
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationSearchCell")
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
    }
    
    @objc private func textFieldTextChange(textField:UITextField) {
        guard let text = textField.text?.trim else  {return}
        print(text)
        HYBNetworking.searchAroundData(text: text, success: { (response) in
            guard let arroundModel = response as? CLAroundModel else {return}
            if let pois = arroundModel.pois {
                self.dataArray += pois
            }
            self.tableView.reloadData()
        }) { (error) in
            guard let e = error as? [String:Any] else {return}
            HUD.showErrorMessage(message: e["error"] as? String)
        }
        
    }
    
    //获取定位服务的授权状态
    fileprivate func getCurrentLocation(){
        
        let status = CLLocationManager.authorizationStatus();
        
        if status == CLAuthorizationStatus.denied{
            
            CLAlertController.alertViewShow(title: "打开定位开关", msg: "定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许App使用定位服务", cancelTitle: "取消", confirmTitle: "确定", showView: view) {
                if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                    
                    UIApplication.shared.openURL(appSettings as URL)
                }
            }
            return
        }
        
        self.isLocationFinish = true
        LocationManager.shareManager.creatLocationManager().startLocation { (location, address, error) in
            let lng = "\(location?.coordinate.longitude ?? 0.0)"
            let lat = "\(location?.coordinate.latitude ?? 0.0)"
            print("经度 \(lng)")
            print("纬度 \(lat)")
            print("地址\(address ?? "")")
            print("error\(error ?? "没有错误")")
            if error == nil && self.isLocationFinish {
                var model = CLAroundPoisModel()
                model.name = "[我的位置]"
                model.location = lng + "," + lat
                if self.dataArray.count == 0 {
                    self.dataArray.append(model)
                }else{
                    self.dataArray.insert(model, at: 0)
                }
                self.isLocationFinish = false
                self.tableView.reloadData()
                return
            }
            
        }
        
    }
    
}
extension CLSearchLocationController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationSearchCell", for: indexPath)
        
        let model = dataArray[indexPath.row]
        
        cell.textLabel?.text = model.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        selectLocationFinished?(model)
        navigationController?.popViewController(animated: true)
    }
    
}

