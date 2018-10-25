//
//  CLBusLineDetailController.swift
//  Bus
//
//  Created by cleven on 2018/10/19.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import SnapKit

class CLBusLineDetailController: CLRootViewController {

    private var tableView:UITableView!
    private var stationModel:CLLineStationModel?
    private var lineModel:CLLineModel?
    private var direction:Bool = true
    
    init(lineModel:CLLineModel,stationModel:CLLineStationModel) {
        super.init(nibName: nil, bundle: nil)
        self.stationModel = stationModel
        self.lineModel = lineModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lineModel?.line_name
        setupUI()
    }

    private func setupUI(){
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CLBusDetailLineCell.self, forCellReuseIdentifier: "CLBusLineDetailCell")
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
    }
    
    @objc private func clickBusChange() {
        direction = !direction
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CLBusLineDetailController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return direction ? (stationModel?.forwardStops?.count ?? 0) : (stationModel?.reverseStops?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CLBusLineDetailCell", for: indexPath) as? CLBusDetailLineCell
        
        let stations = direction ? stationModel?.forwardStops : stationModel?.reverseStops
        var model = stations![indexPath.row]
        if indexPath.row == 0 {
            model.isFirst = true
            model.isLast = false
        }else if indexPath.row == stations!.count - 1 {
            model.isFirst = false
            model.isLast = true
        }
        model.direction = direction
        model.index = indexPath.row
        cell?.setStationModel(model: model)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenInfo.Width, height: 80))
        
        let color = direction ? UIColor.cl_colorWithHex(hex: 0xFF7C73) : UIColor.cl_colorWithHex(hex: 0xFF9500)
        view.backgroundColor = color
        guard let start_stop = lineModel?.start_stop,let end_stop = lineModel?.end_stop else {
            return view
        }
        let station = direction ? (start_stop + " → " + end_stop) : (end_stop + " → " + start_stop)
        let titleLabel = UILabel(text: station , textColor: UIColor.white, fontSize: 14)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(ScreenInfo.Kmargin_10)
            make.top.equalTo(view).offset(ScreenInfo.Kmargin_10)
        }
        
        let startLaebl:UILabel = UILabel()
        startLaebl.text = "首班车: "
        startLaebl.textColor = UIColor.lightGray
        startLaebl.font = UIFont.systemFont(ofSize: 10)
        view.addSubview(startLaebl)
        startLaebl.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(view).offset(-ScreenInfo.Kmargin_10)
        }
        let startTimeLabel:UILabel = UILabel(text: direction ? lineModel?.start_earlytime : lineModel?.end_earlytime, textColor: UIColor.white, fontSize: 10)
        view.addSubview(startTimeLabel)
        startTimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startLaebl)
            make.leading.equalTo(startLaebl.snp.trailing)
        }
        
        let endLabel:UILabel = UILabel(text: "末班车: ", textColor: UIColor.lightGray, fontSize: 10)
        view.addSubview(endLabel)
        endLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startLaebl)
            make.leading.equalTo(startTimeLabel.snp.trailing).offset(ScreenInfo.Kmargin_5)
        }
        
        let endTimeLabel:UILabel = UILabel(text: direction ? lineModel?.start_latetime : lineModel?.end_latetime, textColor: UIColor.white, fontSize: 10)
        view.addSubview(endTimeLabel)
        endTimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startLaebl)
            make.leading.equalTo(endLabel.snp.trailing)
        }
        
        let refreshButton:UIButton = UIButton()
        refreshButton.setImage(UIImage(named: "bt_tabbar_transit_select"), for: .normal)
        view.addSubview(refreshButton)
        refreshButton.addTarget(self, action: #selector(self.clickBusChange), for: .touchUpInside)
        refreshButton.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(view)
            make.trailing.equalTo(view).offset(-20)
            make.width.equalTo(40)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = direction ? stationModel?.forwardStops![indexPath.row] : stationModel?.reverseStops![indexPath.row]
        
        CLRealTimeController.showDetailView(currentStation: model?.zdmc ?? "", lineModel: lineModel, stopId: model?.id ?? "", direction: !direction, vc: self)
    }
    
}
