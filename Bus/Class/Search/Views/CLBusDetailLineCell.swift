//
//  CLBusDetailLineCell.swift
//  Bus
//
//  Created by cleven on 2018/10/19.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import SnapKit

class CLBusDetailLineCell: UITableViewCell {

    private var orderButton:UIButton!
    private var titleLabel:UILabel!
    private var topLine:UIView!
    private var bottomLine:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        orderButton = UIButton()
        orderButton.setTitleColor(UIColor.cl_colorWithHex(hex: 0x6389F9), for: .normal)
        orderButton.layer.borderWidth = 3
        orderButton.layer.borderColor = UIColor.cl_colorWithHex(hex: 0x6389F9).cgColor
        orderButton.layer.cornerRadius = 10
        orderButton.layer.masksToBounds = true
        orderButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(orderButton)
        orderButton.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(ScreenInfo.Kmargin_10)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(20)
        }
        
        titleLabel = UILabel(text: "", textColor: UIColor.black, fontSize: 14)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(orderButton.snp.trailing).offset(ScreenInfo.kMargin_20)
        }
        
        topLine = UIView()
        topLine.backgroundColor = UIColor.cl_colorWithHex(hex: 0x6389F9)
        contentView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(orderButton)
            make.top.equalTo(orderButton.snp.bottom)
            make.bottom.equalTo(contentView)
            make.width.equalTo(2)
        }
        
        bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.cl_colorWithHex(hex: 0x6389F9)
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(topLine)
            make.top.equalTo(contentView)
            make.bottom.equalTo(orderButton.snp.top)
            make.width.equalTo(2)
        }
        
    }
    
    public func setStationModel(model:CLLineStation) {
        topLine.isHidden = model.isLast
        bottomLine.isHidden = model.isFirst
        orderButton.setTitle("\(model.index + 1)", for: .normal)
        titleLabel.text = model.zdmc
    }

}
