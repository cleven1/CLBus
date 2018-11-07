//
//  CLChangeLineModel.swift
//  Bus
//
//  Created by cleven on 2018/10/31.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import HandyJSON

struct CLTransitsModel: HandyJSON {
    /// 总站数
    var cost: String?
    /// 耗时
    var duration: String?
    /// 步行距离
    var walking_distance: String?
    /// 总距离
    var distance: String?
    /// 详情
    var segments:[CLSegmentsModel]?

}

struct CLSegmentsModel: HandyJSON {
    /// 步行
    var walking:CLWalkModel?
    /// 公共线路
    var bus:CLBusModel?
}

struct CLWalkModel: HandyJSON {
    /// 步行距离
    var distance:String?
    /// 步行时间
    var duration:String?
}

struct CLBusModel: HandyJSON {
    /// 所有交通线路
    var buslines:[CLBusLinesModel]?
}

struct CLBusLinesModel: HandyJSON {
    /// 起始站
    var departure_stop:String?
    /// 到达站
    var arrival_stop:String?
    /// 线路名称
    var name:String?
    /// 线路类型
    var type:String?
    /// 距离
    var distance:String?
    /// 时间
    var duration:String?
    /// 总站数
    var via_num:String?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &departure_stop, name: "departure_stop.name")
        mapper.specify(property: &arrival_stop, name: "arrival_stop.name")
    }
}
