//
//  RequestManager.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation

func Body(hook: Hook, stack: String) -> [String: String] {
    var body = ["name": hook.name, "label": hook.label, "level": hook.level, "weight": hook.weight]
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