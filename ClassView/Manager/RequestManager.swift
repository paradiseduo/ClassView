//
//  RequestManager.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation

let LocalAddress = "http://127.0.0.1:10086"
let TestAddress = ""
let ReleaseAddress = ""

let Address = LocalAddress

func Body(name: String, label: String, level: String, weight: String, stack: String) -> [String: String] {
    var body = ["name": name, "label": label, "level": level, "weight": weight]
    let arr = stack.components(separatedBy: "\n").dropFirst().dropLast()
    var resultStack = ""
    for (index, item) in arr.enumerated() {
        if item.contains("???") {
            continue
        }
        let s = item.components(separatedBy: "0x")
        if let ss = s.last {
            let subString = String(ss[ss.index(ss.startIndex, offsetBy: 17)..<ss.endIndex])
//            let funcName = subString.components(separatedBy: " + ").first!
//            if let c = swift_demangle(funcName) {
//                print(c)
//            }
            resultStack += "\(index) \(subString)\n"
            if body["abstract"] == nil {
                body["abstract"] = subString
            }
        } else {
            continue
        }
    }
    body["stack"] = resultStack
    return body
}

func SendPermissionReport(name: String, label: String, level: String, weight: String, stack: String, background: String) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var body = Body(name: name, label: label, level: level, weight: weight, stack: stack)
    body["calldate"] = dateFormatter.string(from: Date())
    body["udid"] = AppDataManager.shared.udid
    body["background"] = background
    
    do {
        var request = URLRequest(url: URL(string: "\(Address)/ios")!)
        request.httpMethod = "POST"
        request.httpBody = try JSONSerialization.data(withJSONObject: ["datas": [body]], options: JSONSerialization.WritingOptions.sortedKeys)
        URLSession.shared.dataTask(with: request) { data, response, err in

        }.resume()
    } catch let err {
        print(err)
    }
}

func SendDeviceInfo() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let body = [
        "device_name": AppDataManager.shared.name,
        "platform": "ios",
        "udid": AppDataManager.shared.udid,
        "device_id": AppDataManager.shared.deviceid,
        "version": AppDataManager.shared.version,
        "build": AppDataManager.shared.build,
        "app": AppDataManager.shared.appName
    ]
    
    do {
        var request = URLRequest(url: URL(string: "\(Address)/device/upload")!)
        request.httpMethod = "POST"
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.sortedKeys)
        URLSession.shared.dataTask(with: request) { data, response, err in
            
        }.resume()
    } catch let err {
        print(err)
    }
}
