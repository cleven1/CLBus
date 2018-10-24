//
//  CLRealTimeController.swift
//  Bus
//
//  Created by cleven on 2018/10/19.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let contentViewHeight:CGFloat = 220

class CLRealTimeController: CLRootViewController {

    private var lineModel:CLLineModel?
    private var currentStation:String?
    private var direction:Bool = false
    private var stopId:String?
    private var contentView:UIView = UIView()
    /// 剩余时间
    private var timeLabel:UILabel?
    /// 剩余站和距离
    private var stopdisLabel:UILabel?
    /// 车牌
    private var terminalLabel:UILabel?
    
    init(currentStation:String,lineModel:CLLineModel?,stopId:String,direction:Bool) {
        super.init(nibName: nil, bundle: nil)
        self.currentStation = currentStation
        self.lineModel = lineModel
        self.stopId = stopId
        self.direction = direction
        self.view.backgroundColor = UIColor.cl_RGBColor(r: 0, g: 0, b: 0, a: 0)
        setupUI()
        getRealTimeData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.clickTapGesture))
        view.addGestureRecognizer(tap)
    }
    
    private func getRealTimeData() {
        
        HYBNetworking.getBusRealTimeData(direction: direction ? 1 : 0, lineId: lineModel?.line_id ?? "", lineNama: lineModel?.line_name ?? "", stopId: stopId ?? "", success: { (response) in
            let carsModel = response as! CLCarsModel
            self.setCarsMdoelData(carsModel: carsModel)
        }) { (error) in
            HUD.showErrorMessage(message: "获取数据失败")
        }
    }
    
    private func setCarsMdoelData(carsModel:CLCarsModel) {
        let model = carsModel.cars?.first
        timeLabel?.text = model?.time
        stopdisLabel?.text = "剩余\(model?.stopdis ?? "0")站 约\(model?.distance ?? "0")米"
        terminalLabel?.text = model?.terminal
    }
    
    /// 外部调用显示方法
    public class func showDetailView(currentStation:String,lineModel:CLLineModel?,stopId:String,direction:Bool,vc:UIViewController){
        let realTimeVC = CLRealTimeController(currentStation: currentStation, lineModel: lineModel, stopId: stopId, direction: direction)
            realTimeVC.modalPresentationStyle = .custom
        vc.present(realTimeVC, animated: false, completion: {
            realTimeVC.showContentView()
        })
    }
    
    private func showContentView(){
        contentView.snp.remakeConstraints { (make) in
            make.leading.equalTo(view).offset(ScreenInfo.kMargin_20)
            make.trailing.equalTo(view).offset(-ScreenInfo.kMargin_20)
            make.centerY.equalTo(view)
            make.height.equalTo(contentViewHeight)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.cl_RGBColor(r: 0, g: 0, b: 0, a: 0.8)
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    private func hiddenContentView(){
        contentView.snp.remakeConstraints { (make) in
            make.leading.equalTo(view).offset(ScreenInfo.kMargin_20)
            make.trailing.equalTo(view).offset(-ScreenInfo.kMargin_20)
            make.top.equalTo(view.snp.bottom)
            make.height.equalTo(contentViewHeight)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.cl_RGBColor(r: 0, g: 0, b: 0, a: 0)
            self.view.layoutIfNeeded()
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    private func setupUI() {
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(ScreenInfo.kMargin_20)
            make.trailing.equalTo(view).offset(-ScreenInfo.kMargin_20)
            make.top.equalTo(view.snp.bottom)
            make.height.equalTo(contentViewHeight)
        }
        
        let titleLabel:UILabel = UILabel(text: currentStation, textColor: UIColor.black, fontSize: 14)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(ScreenInfo.Kmargin_10)
        }
        
        let endStationLabel:UILabel = UILabel(text: "开往: " + lineModel!.end_stop!, textColor: UIColor.darkGray, fontSize: 11)
        contentView.addSubview(endStationLabel)
        endStationLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(ScreenInfo.Kmargin_5)
        }
        
        let infoView:UIView = UIView()
        infoView.layer.borderColor = UIColor.darkGray.cgColor
        infoView.layer.borderWidth = 1
        infoView.layer.cornerRadius = 8
        infoView.layer.masksToBounds = true
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-55)
            make.top.equalTo(endStationLabel.snp.bottom).offset(ScreenInfo.Kmargin_10)
            make.width.equalTo(230)
        }
        
        let nextLabel:UILabel = UILabel(text: "下一班:", textColor: UIColor.darkGray, fontSize: 11)
        infoView.addSubview(nextLabel)
        nextLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(infoView).offset(ScreenInfo.Kmargin_10)
            make.top.equalTo(infoView).offset(ScreenInfo.Kmargin_15)
        }
        
        timeLabel = UILabel(text: "00:00", textColor: UIColor.red, fontSize: 24)
        infoView.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints { (make) in
            make.centerX.equalTo(infoView)
            make.bottom.equalTo(infoView.snp.centerY)
        }
        
        stopdisLabel = UILabel(text: "剩余0站 约000米", textColor: UIColor.darkGray, fontSize: 14)
        infoView.addSubview(stopdisLabel!)
        stopdisLabel?.snp.makeConstraints { (make) in
            make.centerX.equalTo(infoView)
            make.top.equalTo(timeLabel!.snp.bottom).offset(ScreenInfo.Kmargin_10)
        }
        
        terminalLabel = UILabel(text: "沪B-99346", textColor: UIColor.darkGray, fontSize: 12)
        infoView.addSubview(terminalLabel!)
        terminalLabel?.snp.makeConstraints { (make) in
            make.centerX.equalTo(infoView)
            make.bottom.equalTo(infoView).offset(-ScreenInfo.Kmargin_10)
        }
        
        let refreshButton = UIButton(title: "刷新", titleColor: UIColor.red)
        refreshButton.backgroundColor = UIColor.cyan
        contentView.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-ScreenInfo.Kmargin_10)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        
        
    }
    
    
    @objc private func clickTapGesture(){
        hiddenContentView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
