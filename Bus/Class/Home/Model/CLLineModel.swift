//
//  CLLineModel.swift
//  Bus
//
//  Created by cleven on 2018/10/18.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import HandyJSON

class CLLineModel: HandyJSON {
    /// 开始最晚班车时间
    var start_latetime:String?
    /// 线路
    var line_name:String?
    /// 结束最早班车时间
    var end_earlytime:String?
    /// 开始最早班车时间
    var start_earlytime:String?
    /// 最后一站
    var end_stop:String?
    /// id
    var line_id:String?
    /// 开始站
    var start_stop:String?
    /// 结束最晚班车时间
    var end_latetime:String?
    /// 历史记录排序用
    var timeStamp:String = ""
    
    required init(){}
}
