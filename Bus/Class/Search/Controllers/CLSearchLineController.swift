//
//  CLSearchViewController.swift
//  Bus
//
//  Created by cleven on 2018/10/18.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit

class CLSearchLineController: CLRootViewController {
    
    public var searchBusLineCallback:((CLLineModel)->())?
    
    private var linesModel:[CLLinesModel]?
    private var dataArray:[CLLinesModel]?{
        didSet{
            if (tableView != nil) {
                tableView.reloadData()
            }
        }
    }
    
    private var searchController: UISearchController!
    private var tableView:UITableView!
    private var searchText:String?
    
    
    init(linesModel:[CLLinesModel]) {
        super.init(nibName: nil, bundle: nil)
        self.linesModel = linesModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        addSearchController()
    }
    
    private func setupUI(){
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CLBusLinesCell")
        view.addSubview(tableView)
        
    }
    private func addSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.isActive = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = UIColor.cl_colorWithHex(hex: 0xF4F5FA)
        //设置显示搜索结果的控制器
        searchController.searchResultsUpdater = self
        //协议(UISearchResultsUpdating)
        searchController.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.keyboardType = .default
        searchController.searchBar.placeholder = "搜索公交车线路"
    }
    
    private func fileterBusLineData(line:String) {
        
        dataArray = linesModel?.filter({
            $0.line?.rangeOfCharacter(from: CharacterSet(charactersIn: line)) != nil
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CLSearchLineController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CLBusLinesCell", for: indexPath)

        let model = dataArray![indexPath.row]
        
        cell.textLabel?.text = model.line
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        searchController.dismiss(animated: true, completion: nil)
        
        let model = dataArray![indexPath.row]
        
        HUD.showTextHudTips(message: "正在获取线路信息...",view:view)
        HYBNetworking.getBusStation(line: model.line ?? "", success: { (response) in
            
            var lineModel = response as! CLLineModel
            lineModel.line_name = model.line
            self.searchBusLineCallback?(lineModel)
//            self.navigationController?.popViewController(animated: true)
            HYBNetworking.getCurrentLineAllStation(lineName: lineModel.line_name ?? "", lineId: lineModel.line_id ?? "", success: { (response) in
                HUD.hideHud()
                let model = response as! CLLineStationModel
                
                let lineDetailVC = CLBusLineDetailController(lineModel: lineModel, stationModel: model)
                self.navigationController?.pushViewController(lineDetailVC, animated: true)
            }, failure: { (error) in
                HUD.hideHud()
                HUD.showErrorMessage(message: "请求失败")
            })
            
        }) { (error) in
            HUD.hideHud()
            HUD.showErrorMessage(message: "请求失败")
        }
    }
    
}

extension CLSearchLineController:UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {return}
        if searchText.isEmpty || self.searchText == searchText {return}
        fileterBusLineData(line: searchText)
        self.searchText = searchText
    }
    
    // MARK: - UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            self.searchController?.searchResultsController?.view.isHidden = false
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print("该说话了")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchController?.searchResultsController?.view.isHidden = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        
        if searchText.isEmpty {
            DispatchQueue.main.async {
                self.searchController?.searchResultsController?.view.isHidden = false
            }
        }
    }
    
}
