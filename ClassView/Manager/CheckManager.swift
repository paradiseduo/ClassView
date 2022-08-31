//
//  CheckManager.swift
//  ClassView
//
//  Created by admin on 2022/8/31.
//

import Foundation

func RequestCheck(url: String, header: String, method: String, body: String) -> [String: String] {
    var newBody = ["url": url, "header": header, "method": method, "body": body, "query": "", "host": "", "weight": "1", "level": SENSITIVE]
    
    if let bodyData = Data(base64Encoded: body) {
        if let s = bodyData.jsonString() {
            newBody["body"] = s
        } else if let s = bodyData.utf8String() {
            newBody["body"] = s
        } else {
            if let d = try? bodyData.gunzipped() {
                if let s = d.jsonString() {
                    newBody["body"] = s
                } else if let s = d.utf8String() {
                    newBody["body"] = s
                }
            }
        }
    }
    var query = ""
    
    if let u = URL(string: url) {
        query = u.query ?? ""
        let host = u.host ?? ""
        newBody["query"] = query
        newBody["host"] = host
        newBody["url"] = u.scheme! + "://" + host + u.path
    }
    
    if MobileCheck(query) {
        newBody["name"] = "Query包含手机号"
        newBody["label"] = "手机号"
        return newBody
    }
    if MobileCheck(header) {
        newBody["name"] = "Header包含手机号"
        newBody["label"] = "手机号"
        return newBody
    }
    if MobileCheck(body) {
        newBody["name"] = "Body包含手机号"
        newBody["label"] = "手机号"
        return newBody
    }
    
    if IDFACheck(query) {
        newBody["name"] = "Query包含IDFA"
        newBody["label"] = "IDFA"
        return newBody
    }
    if IDFACheck(header) {
        newBody["name"] = "Query包含IDFA"
        newBody["label"] = "IDFA"
        return newBody
    }
    if IDFACheck(body) {
        newBody["name"] = "Query包含IDFA"
        newBody["label"] = "IDFA"
        return newBody
    }
    
    if IDFVCheck(query) {
        newBody["name"] = "Query包含IDFV"
        newBody["label"] = "IDFV"
        return newBody
    }
    if IDFVCheck(header) {
        newBody["name"] = "Query包含IDFV"
        newBody["label"] = "IDFV"
        return newBody
    }
    if IDFVCheck(body) {
        newBody["name"] = "Query包含IDFV"
        newBody["label"] = "IDFV"
        return newBody
    }
    
    newBody["name"] = "其他请求"
    newBody["label"] = "其他"
    newBody["weight"] = "100"
    newBody["level"] = GENERAL
    return newBody
}

func PermissionCheck(name: String, label: String, level: String, weight: String, stack: String) -> [String: String] {
    var body = ["name": name, "label": label, "level": level, "weight": weight]
    if stack.hasPrefix("(") {
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
                if subString.count > 36 {
                    if let _ = UUID(uuidString: subString[..<36]) {
                        continue
                    }
                }
                resultStack += "\(index) \(subString)\n"
                if body["abstract"] == nil {
                    body["abstract"] = subString
                }
            } else {
                continue
            }
        }
        body["stack"] = resultStack
    } else if stack.hasPrefix("-") {
        body["stack"] = stack
        body["abstract"] = stack
    }
    return body
}

func MobileCheck(_ string: String) -> Bool {
    if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue) {
        let matches = detector.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: string.count))
        for match in matches {
            if match.resultType == .phoneNumber, var n = match.phoneNumber {
                if n.hasPrefix("86") {
                    n = n.replacingOccurrences(of: "86", with: "")
                }
                if n.count == 11 {
                    let monile = "^1(3[0-9]|4[579]|5[0-35-9]|6[6]|7[0-35-9]|8[0-9]|9[89])\\d{8}$"
                    let rege = NSPredicate(format: "SELF MATCHES %@", monile)
                    return rege.evaluate(with: n)
                }
            }
        }
    }
    return false
}

func IDFACheck(_ string: String) -> Bool {
    return (string.uppercased().contains("IDFA") || string.uppercased().contains(AppDataManager.shared.idfa))
}

func IDFVCheck(_ string: String) -> Bool {
    return (string.uppercased().contains("IDFV") || string.uppercased().contains(AppDataManager.shared.idfv))
}
