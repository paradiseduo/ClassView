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
                let body = Body(hook: self, stack: p)
                print(body)
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
                        console.log(ObjC.classes.NSThread['+ callStackSymbols']().toString());
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
                            console.log(ObjC.classes.NSThread['+ callStackSymbols']().toString());
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