//
//  HookManager.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation

let SENSITIVE = "1"
let NORMAL = "0"

func HookUIPasteboard() {
    USBDeviceManager.shared.add(Hook(className: "_UIConcretePasteboard", methodName: "- string", name: "获取剪切板字符串", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.shared.add(Hook(className: "_UIConcretePasteboard", methodName: "- strings", name: "获取剪切板字符串数组", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.shared.add(Hook(className: "_UIConcretePasteboard", methodName: "- URL", name: "获取剪切板URL", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.shared.add(Hook(className: "_UIConcretePasteboard", methodName: "- URLs", name: "获取剪切板URLs", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.shared.add(Hook(className: "_UIConcretePasteboard", methodName: "- image", name: "获取剪切板图片", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.shared.add(Hook(className: "_UIConcretePasteboard", methodName: "- images", name: "获取剪切板图片数组", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.shared.add(Hook(className: "_UIConcretePasteboard", methodName: "- color", name: "获取剪切板颜色", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.shared.add(Hook(className: "_UIConcretePasteboard", methodName: "- colors", name: "获取剪切板颜色数组", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
}
