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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CLBusLineDetailCell")
        view.addSubview(tableView)
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CLBusLineDetailCell", for: indexPath)
        
        let model = direction ? stationModel?.forwardStops![indexPath.row] : stationModel?.reverseStops![indexPath.row]
        
        cell.textLabel?.text = model?.zdmc
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenInfo.Width, height: 80))
        view.backgroundColor = UIColor.blue
        let station = direction ? (lineModel!.start_stop! + " → " + lineModel!.end_stop!) : (lineModel!.end_stop! + " → " + lineModel!.start_stop!)
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
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = direction ? stationModel?.forwardStops![indexPath.row] : stationModel?.reverseStops![indexPath.row]
        
//        CLRealTimeController.showDetailView(currentStation: model?.zdmc ?? "", endStation: lineModel?.end_stop ?? "", vc: self)
        CLRealTimeController.showDetailView(currentStation: model?.zdmc ?? "", lineModel: lineModel, stopId: model?.id ?? "", direction: direction, vc: self)
    }
    
}
