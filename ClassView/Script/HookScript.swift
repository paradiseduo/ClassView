//
//  HookScript.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation
import Frida

class Hook: ScriptDelegate {
    private var script: Script?
    let className: String
    let methodName: String
    let name: String
    let label: String
    let level: String
    let weight: String
    
    init(className: String, methodName: String, name: String, label: String, level: String, weight: String) {
        self.className = className
        self.methodName = methodName
        self.name = name
        self.label = label
        self.level = level
        self.weight = weight
    }

    func scriptDestroyed(_ script: Script) {
        print("\(script) scriptDestroyed")
    }

    func script(_ script: Script, didReceiveMessage message: Any, withData data: Data?) {
        if let dic = message as? NSDictionary {
            if let p = dic["payload"] as? String {
                let arr = p.components(separatedBy: "&")
                var background = "1"
                if let b = arr.last, b == "0" {
                    background = b
                }
                SendPermissionReport(name: name, label: label, level: level, weight: weight, stack: arr.first ?? "", background: background)
            }
        }
    }
    
    func hook() {
        if let session = USBDeviceManager.shared.session {
//            var dic = ObjC.classes.NSMutableDictionary.alloc().init();
//            dic.setObject_forKey_(class_name.toString(), "className");
//            dic.setObject_forKey_(method_name.toString(), "methodName");
//            dic.setObject_forKey_(ObjC.classes.NSThread['+ callStackSymbols']().toString(), "stack");
            var s = """
            function hook_class_method(class_name, method_name)
            {
                var hook = ObjC.classes[class_name][method_name];
                Interceptor.attach(hook.implementation, {
                    onEnter: function(args) {
                       var stack = ObjC.classes.NSThread['+ callStackSymbols']().toString();
                       ObjC.schedule(ObjC.mainQueue, function () {
                           const { UIApplication } = ObjC.classes;
                           var status = UIApplication.sharedApplication().applicationState();
                           console.log(stack + "&" + status);
                       });
                    }
                });
            }

            function run_hook_all_methods_of_specific_class(className_arg)
            {
                var className = className_arg;
                var methods = ObjC.classes[className].$ownMethods;
                for (var i = 0; i < methods.length; i++)
                {
                    var className2 = className;
                    var funcName2 = methods[i];
                    hook_class_method(className2, funcName2);
                }
            }

            function hook_all_methods_of_specific_class(className_arg)
            {
                setImmediate(run_hook_all_methods_of_specific_class,[className_arg])
            }

            hook_all_methods_of_specific_class("\(className)")
            """
            if methodName.count > 0 {
                s = """
                function hook_specific_method_of_class(class_name, method_name)
                {
                    var hook = ObjC.classes[class_name][method_name];
                    Interceptor.attach(hook.implementation, {
                        onEnter: function(args) {
                            var stack = ObjC.classes.NSThread['+ callStackSymbols']().toString();
                            ObjC.schedule(ObjC.mainQueue, function () {
                                const { UIApplication } = ObjC.classes;
                                var status = UIApplication.sharedApplication().applicationState();
                                console.log(stack + "&" + status);
                            });
                        }
                    });
                }

                hook_specific_method_of_class("\(className)", "\(methodName)")
                """
            }
            session.createScript(s, name: "Hook", runtime: ScriptRuntime.auto) { scriptResult in
                do {
                    self.script = try scriptResult()
                    self.script?.delegate = self
                    self.script?.load() { result in
                        do {
                            if try result() {
                                print("Script \(self.className) \(self.methodName) loaded")
                            } else {
                                print("Script \(self.className) \(self.methodName) loaded failed")
                            }
                        } catch let e {
                            print(e)
                        }
                    }
                } catch let e {
                    print(e)
                }
            }
        } else {
            print("USBDeviceManager.shared.session not found")
        }
    }
}

class HookArgs: ScriptDelegate {
    public typealias HookResult = (_ className: String, _ methodName: String, _ callStack: String, _ background: String, _ args: [String]) -> Void
    
    private var script: Script?
    let className: String
    let methodName: String
    private var handle: HookResult
    
    init(className: String, methodName: String, resultHandle: @escaping HookResult) {
        self.className = className
        self.methodName = methodName
        self.handle = resultHandle
    }

    func scriptDestroyed(_ script: Script) {
        print("\(script) scriptDestroyed")
    }

    func script(_ script: Script, didReceiveMessage message: Any, withData data: Data?) {
        if let dic = message as? NSDictionary {
            if let p = dic["payload"] as? String {
                let arr = p.components(separatedBy: "&")
                var background = "1"
                if arr[1] == "0" {
                    background = arr[1]
                }
                self.handle(self.className, self.methodName, arr.first ?? "", background, (arr.last ?? "").components(separatedBy: "*").filter({ s in
                    return s != ""
                }))
            }
        }
    }
    
    func hook() {
        if let session = USBDeviceManager.shared.session {
            var s = """
            function hook_class_method(class_name, method_name)
            {
                var hook = ObjC.classes[class_name][method_name];
                Interceptor.attach(hook.implementation, {
                    onEnter: function(args) {
                        const { NSString } = ObjC.classes;
                        var str = NSString.stringWithString_("%@");
                        var array = str["- componentsSeparatedByString:"](":");
                        var count = array.count().valueOf();
                        var result = "&";
                        for (var i = 0; i < count-1; i++)
                        {
                            result = result + "*" + ObjC.Object(args[2+i]).toString();
                        }
                        var stack = ObjC.classes.NSThread['+ callStackSymbols']().toString();
                        ObjC.schedule(ObjC.mainQueue, function () {
                            const { UIApplication } = ObjC.classes;
                            var status = UIApplication.sharedApplication().applicationState();
                            console.log(stack + "&" + status + result);
                        });
                    }
                });
            }

            function run_hook_all_methods_of_specific_class(className_arg)
            {
                var className = className_arg;
                var methods = ObjC.classes[className].$ownMethods;
                for (var i = 0; i < methods.length; i++)
                {
                    var className2 = className;
                    var funcName2 = methods[i];
                    hook_class_method(className2, funcName2);
                }
            }

            function hook_all_methods_of_specific_class(className_arg)
            {
                setImmediate(run_hook_all_methods_of_specific_class,[className_arg])
            }

            hook_all_methods_of_specific_class("\(className)")
            """
            s = String(format: s, methodName)
            if methodName.count > 0 {
                if methodName == "- requestAuthorizationToShareTypes:readTypes:completion:" && className == "HKHealthStore" {
                    s = """
                    function hook_specific_method_of_class(class_name, method_name)
                    {
                        var hook = ObjC.classes[class_name][method_name];
                        Interceptor.attach(hook.implementation, {
                            onEnter: function(args) {
                                const { UIApplication } = ObjC.classes;
                                var status = UIApplication.sharedApplication().applicationState();
                                var stack = ObjC.classes.NSThread['+ callStackSymbols']().toString();
                                
                                var shareSet = new ObjC.Object(args[2]);
                                var shareArr = shareSet.allObjects();
                                var count1 = shareArr.count().valueOf();
                                for (var i = 0; i < count1; i++)
                                {
                                    var str = ObjC.Object(shareArr.objectAtIndex_(i));
                                    var str1 = str.identifier()["- stringByReplacingOccurrencesOfString:withString:"]("HKQuantityTypeIdentifier", "");
                                    console.log(stack + "&" + status + "&" + "Share " + str1);
                                }
                                
                                var readSet = new ObjC.Object(args[3]);
                                var readArr = readSet.allObjects();
                                var count2 = readArr.count().valueOf();
                                for (var i = 0; i < count2; i++)
                                {
                                    var str = ObjC.Object(readArr.objectAtIndex_(i));
                                    var str1 = str.identifier()["- stringByReplacingOccurrencesOfString:withString:"]("HKQuantityTypeIdentifier", "");
                                    console.log(stack + "&" + status + "&" + "Read " + str1);
                                }
                            }
                        });
                    }

                    hook_specific_method_of_class("\(className)", "\(methodName)")
                    """
                } else if methodName == "- executeQuery:" && className == "HKHealthStore" {
                    s = """
                    function hook_specific_method_of_class(class_name, method_name)
                    {
                        var hook = ObjC.classes[class_name][method_name];
                        Interceptor.attach(hook.implementation, {
                            onEnter: function(args) {
                                var stack = ObjC.classes.NSThread['+ callStackSymbols']().toString();
                                var query = new ObjC.Object(args[2]);
                                ObjC.schedule(ObjC.mainQueue, function () {
                                    const { UIApplication } = ObjC.classes;
                                    var status = UIApplication.sharedApplication().applicationState();
                                    var iden = query.objectType().identifier()["- stringByReplacingOccurrencesOfString:withString:"]("HKQuantityTypeIdentifier", "");
                                    console.log(stack + "&" + status + "&" + iden);
                                });
                            }
                        });
                    }

                    hook_specific_method_of_class("\(className)", "\(methodName)")
                    """
                } else {
                    s = """
                    function hook_specific_method_of_class(class_name, method_name)
                    {
                        var hook = ObjC.classes[class_name][method_name];
                        Interceptor.attach(hook.implementation, {
                            onEnter: function(args) {
                                const { NSString } = ObjC.classes;
                                var str = NSString.stringWithString_("%@");
                                var array = str["- componentsSeparatedByString:"](":");
                                var count = array.count().valueOf();
                                var result = "&";
                                for (var i = 0; i < count-1; i++)
                                {
                                    result = result + "*" + ObjC.Object(args[2+i]).toString();
                                }
                                var stack = ObjC.classes.NSThread['+ callStackSymbols']().toString();
                                ObjC.schedule(ObjC.mainQueue, function () {
                                    const { UIApplication } = ObjC.classes;
                                    var status = UIApplication.sharedApplication().applicationState();
                                    console.log(stack + "&" + status + result);
                                });
                            }
                        });
                    }

                    hook_specific_method_of_class("\(className)", "\(methodName)")
                    """
                    s = String(format: s, methodName)
                }
            }
            session.createScript(s, name: "HookReturn", runtime: ScriptRuntime.auto) { scriptResult in
                do {
                    self.script = try scriptResult()
                    self.script?.delegate = self
                    self.script?.load() { result in
                        do {
                            if try result() {
                                print("Script \(self.className) \(self.methodName) loaded")
                            } else {
                                print("Script \(self.className) \(self.methodName) loaded failed")
                            }
                        } catch let e {
                            print(e)
                        }
                    }
                } catch let e {
                    print(e)
                }
            }
        } else {
            print("USBDeviceManager.shared.session not found")
        }
    }
}
