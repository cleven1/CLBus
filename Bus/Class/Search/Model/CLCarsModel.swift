//
//  CLRealTimeModel.swift
//  Bus
//
//  Created by cleven on 2018/10/19.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import HandyJSON

struct CLCarsModel: HandyJSON {
    
    var cars:[CLRealTimeModel]?
}

struct CLRealTimeModel: HandyJSON {
    /// 时间(秒)
    var time:String?
    /// 距离(米)
    var distance:String?
    /// 车牌
    var terminal:String?
    /// 距离还有几站
    var stopdis:String?
}
