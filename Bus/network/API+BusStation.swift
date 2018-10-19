//
//  API+BusStation.swift
//  Bus
//
//  Created by cleven on 2018/10/18.
//  Copyright © 2018年 cleven. All rights reserved.
//

import Foundation
import SwiftyXMLParser

extension HYBNetworking {
    
    /// 获取当前线路的班车时间丶起始站丶终点站
    class func getBusStation(line:String,success:@escaping success,failure:@escaping failure) {

        HYBNetworking.getWithUrl("http://118.25.123.116:3389/bus/querylineinfo?appVersion=103&linename=" + line + "&os=iOS&random=30695854212686256330698&systemVersion=11.4", refreshCache: false, success: { (response) in
            guard let dict = response as? [String:Any] else {failure("解析失败");return}
            if let data = dict["data"] as? [String:Any] { // json解析
                guard let model = CLLineModel.deserialize(from: data) else {failure("转模型失败");return}
                success(model)
            }else{ //xml解析
                let xml = try! XML.parse((dict["data"] as? String)!)
                let dict = xml["linedetail"]
                let end_earlytime = dict["end_earlytime"].text
                let end_latetime = dict["end_latetime"].text
                let end_stop = dict["end_stop"].text
                let line_id = dict["line_id"].text
                let line_name = dict["line_name"].text
                let start_earlytime = dict["start_earlytime"].text
                let start_latetime = dict["start_latetime"].text
                let start_stop = dict["start_stop"].text
                var model = CLLineModel()
                model.end_earlytime = end_earlytime
                model.end_latetime = end_latetime
                model.end_stop = end_stop
                model.line_id = line_id
                model.line_name = line_name
                model.start_earlytime = start_earlytime
                model.start_latetime = start_latetime
                model.start_stop = start_stop
                success(model)
            }
        }) { (error) in
            failure("请求失败")
        }
    }
    
    /// 获取当前线路的所有站点
    class func getCurrentLineAllStation(lineName:String,lineId:String,success:@escaping success,failure:@escaping failure) {
        
        let url = "http://118.25.123.116:3389/bus/querystops?appVersion=103&lineid=\(lineId)&linename=\(lineName)&os=iOS&random=52459402883302122&systemVersion=11.4"
        
        HYBNetworking.getWithUrl(url, refreshCache: false, success: { (response) in
            guard let dict = response as? [String:Any] else {failure("解析失败");return}
            if let data = dict["data"] as? [String:Any] { // json解析
                var stationModel = CLLineStationModel()
                if let lineResults0 = data["lineResults0"] as? [String:Any] {
                    let direction = lineResults0["direction"] as? Bool
                    if direction == true {
                        if let stops = lineResults0["stops"] as? [[String:Any]] {
                            for stop in stops {
                                stationModel.forwardStops?.append(CLLineStation.deserialize(from: stop)!)
                            }
                        }
                    }else{
                        if let stops = lineResults0["stops"] as? [[String:Any]] {
                            for stop in stops {
                                stationModel.reverseStops?.append(CLLineStation.deserialize(from: stop)!)
                            }
                        }
                    }
                    
                }
                if let lineResults1 = data["lineResults1"] as? [String:Any] {
                    let direction = lineResults1["direction"] as? Bool
                    if direction == true {
                        if let stops = lineResults1["stops"] as? [[String:Any]] {
                            for stop in stops {
                                stationModel.forwardStops?.append(CLLineStation.deserialize(from: stop)!)
                            }
                        }
                    }else{
                        if let stops = lineResults1["stops"] as? [[String:Any]] {
                            for stop in stops {
                                stationModel.reverseStops?.append(CLLineStation.deserialize(from: stop)!)
                            }
                        }
                    }
                }
                success(stationModel)
            }else { // xml解析
                var stationModel = CLLineStationModel()
                let xml = try! XML.parse((dict["data"] as? String)!)
                let lineInfoDetails = xml["lineInfoDetails"]
                let lineResults0 = lineInfoDetails["lineResults0"]
                let stops0 = lineResults0["stop"]
                if lineResults0["direction"].bool == false {
                    stationModel.reverseStops = stopsDataHandle(stops: stops0)
                }else{
                    stationModel.forwardStops = stopsDataHandle(stops: stops0)
                }
                let lineResults1 = lineInfoDetails["lineResults1"]
                let stops1 = lineResults1["stop"]
                if lineResults1["direction"].bool == false {
                    stationModel.reverseStops = stopsDataHandle(stops: stops1)
                }else{
                    stationModel.forwardStops = stopsDataHandle(stops: stops1)
                }
                success(stationModel)
            }
        }) { (error) in
           failure("请求失败")
        }
        
    }
    
    class func stopsDataHandle(stops:XML.Accessor) -> [CLLineStation] {
        var stopArray:[CLLineStation] = [CLLineStation]()
        for stop in stops {
            var model = CLLineStation()
            model.zdmc = stop["zdmc"].text
            model.id = stop["id"].text
            stopArray.append(model)
        }
        return stopArray
    }
    
    /// 获取实时公交信息
    class func getBusRealTimeData(direction:Int,lineId:String,lineNama:String,stopId:String,success:@escaping success,failure:@escaping failure) {
        
        let url = "http://118.25.123.116:3389/bus/queryarrivalinfo?appVersion=103&direction=\(direction)&lineid=\(lineId)&linename=\(lineNama)&os=iOS&random=74835218103329864520565&stopid=\(stopId)&systemVersion=11.4"
        
        HYBNetworking.getWithUrl(url, refreshCache: false, success: { (response) in
            guard let dict = response as? [String:Any] else {failure("解析失败");return}

            if let data = dict["data"] as? [String:Any] { //json解析
                
                success(CLCarsModel.deserialize(from: data)!)
            }else{ // xml解析
                let xml = try! XML.parse((dict["data"] as? String)!)
                let result = xml["result"]
                let cars = result["cars"]
                var carsModel = CLCarsModel()
                var tempArry:[CLRealTimeModel] = [CLRealTimeModel]()
                for c in cars {
                    let car = c["car"]
                    let time = car["time"].text
                    let terminal = car["terminal"].text
                    let stopdis = car["stopdis"].text
                    let distance = car["distance"].text
                    var realModel = CLRealTimeModel()
                    realModel.time = time
                    realModel.terminal = terminal
                    realModel.stopdis = stopdis
                    realModel.distance = distance
                    tempArry.append(realModel)
                }
                carsModel.cars = tempArry
                success(carsModel)
            }
            
        }) { (error) in
            failure("请求失败")
        }
    }

}
