//
//  CLSearchViewController.swift
//  Bus
//
//  Created by cleven on 2018/10/17.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit

class CLHomeViewController: CLRootViewController {

    private var dataArray:NSMutableArray = NSMutableArray()
    /// 搜索过的数据
    private var searchDataArray:[CLLineModel] = [CLLineModel]()
    
    private var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let linesModel = CLLinesModel()
        dataArray.add(searchDataArray)
        if let data = linesModel.getBusData() {
            dataArray.add(data)
        }
        setNavBar()
        setupUI()
        
    }
    
    private func setNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.leftBarButtonItem?.customView?.isHidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "搜索", style: .done, target: self, action: #selector(self.clickSearchButton))
        
    }
    private func setupUI(){
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CLBusLinesCell")
        view.addSubview(tableView)
        
    }

    @objc private func clickClearHistoryData() {
        
    }
    
    @objc private func clickSearchButton() {
        let searchVC = CLSearchLineController(linesModel: dataArray[1] as! [CLLinesModel])
        searchVC.searchBusLineCallback = { [weak self] lineModel in
            self?.searchDataArray.append(lineModel)
            if self?.searchDataArray.isEmpty == false {
                self?.dataArray[0] = self?.searchDataArray ?? ""
            }
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension CLHomeViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let searchData = dataArray[0] as? [CLLineModel],searchData.count > 0 {
            return dataArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchData = dataArray[0] as? [CLLineModel],searchData.count > 0 {
            if section == 0 {
                return searchData.count
            }
            return (dataArray[section] as! [CLLinesModel]).count
        }
        return (dataArray[1] as! [CLLinesModel]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CLBusLinesCell", for: indexPath)
        if let searchData = dataArray[0] as? [CLLineModel],searchData.count > 0 {
            if indexPath.section == 0 {
                let datas = dataArray[indexPath.section] as! [CLLineModel]
                let lineModel = datas[indexPath.row]
                cell.textLabel?.text = lineModel.line_name
            }else{
                let datas = dataArray[indexPath.section] as! [CLLinesModel]
                let lineModel = datas[indexPath.row]
                cell.textLabel?.text = lineModel.line
            }
        }else{
            let datas = dataArray[1] as! [CLLinesModel]
            let model = datas[indexPath.row]
            cell.textLabel?.text = model.line
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenInfo.Width, height: 40))
        let titleLabel = UILabel(frame: CGRect(x: ScreenInfo.Kmargin_15, y: 0, width: 100, height: 40))
        titleLabel.textColor = UIColor.gray
        titleLabel.text = "所有线路"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(titleLabel)
        if let searchData = dataArray[0] as? [CLLineModel],searchData.count > 0 {
            if section == 0 {
                titleLabel.text = "历史记录"
                let clearBtn:UIButton = UIButton(frame: CGRect(x: ScreenInfo.Width - 50, y: 0, width: 50, height: 40))
                clearBtn.setTitle("清除", for: .normal)
                clearBtn.setTitleColor(UIColor.blue, for: .normal)
                clearBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                clearBtn.addTarget(self, action: #selector(self.clickClearHistoryData), for: .touchUpInside)
                view.addSubview(clearBtn)
            }
        }
        return view
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
}