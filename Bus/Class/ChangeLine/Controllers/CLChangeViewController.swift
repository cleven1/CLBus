//
//  CLChangeViewController.swift
//  Bus
//
//  Created by cleven on 2018/10/17.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import SnapKit

class CLChangeViewController: CLRootViewController {

    private var tableView:UITableView!
    private var headerView:UIView!
    private var startButton:UIButton!
    private var endButton:UIButton!
    private var startModel:CLAroundPoisModel?
    private var endModel:CLAroundPoisModel?
    
    private var dataArray:[CLTransitsModel]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
    }
    
    private func setupNavBar() {
        let searchButton:UIButton = UIButton(title: "搜索", titleColor: UIColor.black)
        searchButton.addTarget(self, action: #selector(self.getChangeLineData), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.leftBarButtonItem?.customView?.isHidden = true
    }
    
    private func setupUI() {
        
        headerView = UIView()
        headerView.backgroundColor = UIColor.cl_colorWithHex(hex: 0x6626FC)
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(ScreenInfo.navigationHeight)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(80)
        }
        let startHintLabel = UILabel(text: "从", textColor: CLColor.subTitleColor(), fontSize: 10)
        headerView.addSubview(startHintLabel)
        startHintLabel.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.leading.equalTo(headerView).offset(ScreenInfo.kMargin_20 + 10)
            make.top.equalTo(headerView).offset(ScreenInfo.Kmargin_15)
        }
        
        startButton = UIButton()
        startButton.titleLabel?.textAlignment = .left
        startButton.setTitle("输入起始位置", for: .normal)
        startButton.setTitleColor(CLColor.subTitleColor(), for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        headerView.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(startHintLabel)
            make.leading.equalTo(startHintLabel.snp.trailing).offset(ScreenInfo.Kmargin_5)
            make.trailing.equalTo(headerView).offset(-60)
        }
        startButton.addTarget(self, action: #selector(self.clickStartButton(sender:)), for: .touchUpInside)
        
        let line:UIView = UIView()
        line.backgroundColor = CLColor.subTitleColor()
        headerView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(startHintLabel)
            make.top.equalTo(startHintLabel.snp.bottom).offset(ScreenInfo.Kmargin_15)
            make.trailing.equalTo(startButton)
            make.height.equalTo(1 * ScreenInfo.Scale)
        }
        
        let endHintLabel = UILabel(text: "到", textColor: CLColor.subTitleColor(), fontSize: 10)
        headerView.addSubview(endHintLabel)
        endHintLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(startHintLabel)
            make.top.equalTo(line.snp.bottom).offset(ScreenInfo.Kmargin_15)
        }
        
        endButton = UIButton()
        endButton.setTitle("输入终点位置", for: .normal)
        endButton.setTitleColor(CLColor.subTitleColor(), for: .normal)
        endButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        headerView.addSubview(endButton)
        endButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(endHintLabel.snp.top).offset(5)
            make.leading.equalTo(startButton)
            make.trailing.equalTo(line)
        }
        endButton.addTarget(self, action: #selector(self.clickEndButton(sender:)), for: .touchUpInside)
        
        let changeButton:UIButton = UIButton()
        changeButton.setImage(UIImage(named: "bt_tabbar_transit_select")?.imageWithTintColor(color: UIColor.white), for: .normal)
        headerView.addSubview(changeButton)
        changeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerY.equalTo(line)
            make.trailing.equalTo(headerView).offset(-ScreenInfo.Kmargin_5)
        }
        changeButton.addTarget(self, action: #selector(self.clickChangeButton(sender:)), for: .touchUpInside)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "changeLineCell")
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
    }
    
    
    @objc private func clickStartButton(sender:UIButton) {
        let searchVC = CLSearchLocationController()
        searchVC.selectLocationFinished = { [weak self] arroundModel in
            self?.startButton.setTitle(arroundModel.name, for: .normal)
            self?.startModel = arroundModel
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func clickEndButton(sender:UIButton) {
        let searchVC = CLSearchLocationController()
        searchVC.selectLocationFinished = { [weak self] arroundModel in
            self?.endButton.setTitle(arroundModel.name, for: .normal)
            self?.endModel = arroundModel
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func clickChangeButton(sender:UIButton) {
        var startTitle:String? = startButton.titleLabel?.text
        var endTitle:String? = endButton.titleLabel?.text
        if startTitle == "输入起始位置" || endTitle == "输入终点位置" {
            HUD.showErrorMessage(message: "请输入位置")
            return
        }
        sender.isSelected = !sender.isSelected
        CLTools.shareTool.swap(a: &startModel!, b: &endModel!)
        CLTools.shareTool.swap(a: &startTitle!, b: &endTitle!)
        startButton.setTitle(startTitle, for: .normal)
        endButton.setTitle(endTitle, for: .normal)
    }

    /// 获取数据
    @objc private func getChangeLineData() {
        HYBNetworking.getChangeLineData(start: startModel?.location ?? "", end: endModel?.location ?? "", success: { (response) in
            guard let models = response as? [CLTransitsModel] else {return}
            
            self.dataArray = models
            
        }) { (error) in
            guard let e = error as? [String:Any] else {return}
            HUD.showErrorMessage(message: e["error"] as? String)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CLChangeViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "changeLineCell", for: indexPath)
        
        let model = dataArray![indexPath.row]
        
        cell.textLabel?.text = model.cost
        
        return cell
    }
    
}
