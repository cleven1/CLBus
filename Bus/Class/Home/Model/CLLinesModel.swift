//
//  CLLinesModel.swift
//  Bus
//
//  Created by cleven on 2018/10/17.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import HandyJSON

struct CLLinesModel: HandyJSON {

    var line:String?
    
    var sid:String?
    
    public func getBusData() -> [CLLinesModel]? {
        guard let path = Bundle.main.path(forResource: "shbus", ofType: "plist") else {return nil}
        
        guard let json = NSDictionary(contentsOfFile: path) else {return nil}
        
        guard let pdBus = json["pdbus"] as? [String] else {return nil}
        guard let pxBus = json["pxbus"] as? [String] else {return nil}
        var tempArray:[CLLinesModel] = [CLLinesModel]()
        for line in pdBus {
            var model = CLLinesModel()
            model.line = line
            tempArray.append(model)
        }
        for line in pxBus {
            var model = CLLinesModel()
            model.line = line
            tempArray.append(model)
        }
        return tempArray
    }
    
    public func getLinesData() -> [CLLinesModel]?{

        guard let path = Bundle.main.path(forResource: "BusData", ofType: "json") else {return nil}
        
        let url = URL(fileURLWithPath: path)
        
        guard let data = try? Data(contentsOf: url) else {return nil}
        
        guard let jsons = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any] else {return nil}
        
        var tempArray:[CLLinesModel] = [CLLinesModel]()
        
        for line in jsons {
            var model = CLLinesModel()
            model.line = line.key
            let dict = line.value as! [String:Any]
            model.sid = dict["sid"] as? String
            tempArray.append(model)
        }
        return tempArray
    }
    
}


