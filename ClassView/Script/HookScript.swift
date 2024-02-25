//
//  HookScript.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation
import FridaSwift
import Cocoa

protocol FridaHook {
    func hook()
}

class Hook: ScriptDelegate, FridaHook {
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
            function hook_class_method(class_name, method_name) {
                var hook = ObjC.classes[class_name][method_name];
                Interceptor.attach(hook.implementation, {
                    onEnter: function (args) {
                        var stack = ObjC.classes.NSThread['+ callStackSymbols']().toString();
                        ObjC.schedule(ObjC.mainQueue, function () {
                            const { UIApplication } = ObjC.classes;
                            var status = UIApplication.sharedApplication().applicationState();
                            console.log(stack + "&" + status);
                        });
                    }
                });
            }

            function run_hook_all_methods_of_specific_class(className_arg) {
                var className = className_arg;
                var methods = ObjC.classes[className].$ownMethods;
                for (var i = 0; i < methods.length; i++) {
                    var className2 = className;
                    var funcName2 = methods[i];
                    hook_class_method(className2, funcName2);
                }
            }

            function hook_all_methods_of_specific_class(className_arg) {
                setImmediate(run_hook_all_methods_of_specific_class, [className_arg]);
            }

            hook_all_methods_of_specific_class("\(className)");
            """
            if methodName.count > 0 {
                s = """
                function hook_specific_method_of_class(class_name, method_name) {
                    var hook = ObjC.classes[class_name][method_name];
                    Interceptor.attach(hook.implementation, {
                        onEnter: function (args) {
                            var stack = ObjC.classes.NSThread['+ callStackSymbols']().toString();
                            ObjC.schedule(ObjC.mainQueue, function () {
                                const { UIApplication } = ObjC.classes;
                                var status = UIApplication.sharedApplication().applicationState();
                                console.log(stack + "&" + status);
                            });
                        }
                    });
                }

                hook_specific_method_of_class("\(className)", "\(methodName)");
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

class HookArgs: ScriptDelegate, FridaHook {
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
            function hook_class_method(class_name, method_name) {
                var hook = ObjC.classes[class_name][method_name];
                Interceptor.attach(hook.implementation, {
                    onEnter: function (args) {
                        const { NSString } = ObjC.classes;
                        var str = NSString.stringWithString_("%@");
                        var array = str["- componentsSeparatedByString:"](":");
                        var count = array.count().valueOf();
                        var result = "&";
                        for (var i = 0; i < count - 1; i++) {
                            result = result + "*" + ObjC.Object(args[2 + i]).toString();
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

            function run_hook_all_methods_of_specific_class(className_arg) {
                var className = className_arg;
                var methods = ObjC.classes[className].$ownMethods;
                for (var i = 0; i < methods.length; i++) {
                    var className2 = className;
                    var funcName2 = methods[i];
                    hook_class_method(className2, funcName2);
                }
            }

            function hook_all_methods_of_specific_class(className_arg) {
                setImmediate(run_hook_all_methods_of_specific_class, [className_arg]);
            }

            hook_all_methods_of_specific_class("\(className)");
            """
            s = String(format: s, methodName)
            if methodName.count > 0 {
                if methodName == "- requestAuthorizationToShareTypes:readTypes:completion:" && className == "HKHealthStore" {
                    s = """
                    function hook_specific_method_of_class(class_name, method_name) {
                        var hook = ObjC.classes[class_name][method_name];
                        Interceptor.attach(hook.implementation, {
                            onEnter: function (args) {
                                const { UIApplication } = ObjC.classes;
                                var status = UIApplication.sharedApplication().applicationState();
                                var stack = ObjC.classes.NSThread['+ callStackSymbols']().toString();

                                var shareSet = new ObjC.Object(args[2]);
                                var shareArr = shareSet.allObjects();
                                var count1 = shareArr.count().valueOf();
                                for (var i = 0; i < count1; i++) {
                                    var str = ObjC.Object(shareArr.objectAtIndex_(i));
                                    var str1 = str.identifier()["- stringByReplacingOccurrencesOfString:withString:"]("HKQuantityTypeIdentifier", "");
                                    console.log(stack + "&" + status + "&" + "Share " + str1);
                                }

                                var readSet = new ObjC.Object(args[3]);
                                var readArr = readSet.allObjects();
                                var count2 = readArr.count().valueOf();
                                for (var i = 0; i < count2; i++) {
                                    var str = ObjC.Object(readArr.objectAtIndex_(i));
                                    var str1 = str.identifier()["- stringByReplacingOccurrencesOfString:withString:"]("HKQuantityTypeIdentifier", "");
                                    console.log(stack + "&" + status + "&" + "Read " + str1);
                                }
                            }
                        });
                    }

                    hook_specific_method_of_class("\(className)", "\(methodName)");
                    """
                } else if methodName == "- executeQuery:" && className == "HKHealthStore" {
                    s = """
                    function hook_specific_method_of_class(class_name, method_name) {
                        var hook = ObjC.classes[class_name][method_name];
                        Interceptor.attach(hook.implementation, {
                            onEnter: function (args) {
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

                    hook_specific_method_of_class("\(className)", "\(methodName)");
                    """
                } else {
                    s = """
                    function hook_specific_method_of_class(class_name, method_name) {
                        var hook = ObjC.classes[class_name][method_name];
                        Interceptor.attach(hook.implementation, {
                            onEnter: function (args) {
                                const { NSString } = ObjC.classes;
                                var str = NSString.stringWithString_("%@");
                                var array = str["- componentsSeparatedByString:"](":");
                                var count = array.count().valueOf();
                                var result = "&";
                                for (var i = 0; i < count - 1; i++) {
                                    result = result + "*" + ObjC.Object(args[2 + i]).toString();
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

                    hook_specific_method_of_class("\(className)", "\(methodName)");
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

class HookDelegate: ScriptDelegate, FridaHook {
    private var script: Script?
    let methodName: String
    let name: String
    let label: String
    let level: String
    let weight: String
    
    init(methodName: String, name: String, label: String, level: String, weight: String) {
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
//            const receiver = ObjC.Object(args[0]).$className;
//            const selector = ObjC.selectorAsString(args[1]);
//            const name = `- [${receiver} ${selector}]`;
            let s = """
            async function hook_delegate_method_of_class(methodName) {
                const resolver = new ApiResolver("objc");
                resolver.enumerateMatches(methodName, {
                    onMatch: function (i) {
                        Interceptor.attach(i.address, {
                            onEnter(args) {
                                ObjC.schedule(ObjC.mainQueue, function () {
                                    const { UIApplication } = ObjC.classes;
                                    var status = UIApplication.sharedApplication().applicationState();
                                    console.log(i.name.toString() + "&" + status);
                                });
                            }
                        });
                    },
                    onComplete: function () {

                    }
                });
            }

            hook_delegate_method_of_class("\(methodName)");
            """
            session.createScript(s, name: "HookDelegate", runtime: ScriptRuntime.auto) { scriptResult in
                do {
                    self.script = try scriptResult()
                    self.script?.delegate = self
                    self.script?.load() { result in
                        do {
                            if try result() {
                                print("Script \(self.methodName) loaded")
                            } else {
                                print("Script \(self.methodName) loaded failed")
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


class HookRequest: ScriptDelegate, FridaHook {
    private var script: Script?

    func scriptDestroyed(_ script: Script) {
        print("\(script) scriptDestroyed")
    }

    func script(_ script: Script, didReceiveMessage message: Any, withData data: Data?) {
        if let dic = message as? NSDictionary {
            if let p = dic["payload"] as? String {
                let arr = p.components(separatedBy: "ƒ")
                let url = arr[0]
                let header = ((arr[1] == "null") ? "" : arr[1])
                let method = arr[2]
                let body = arr[3]
                let background = arr[4]
                SendRequestReport(url: url, header: header, method: method, body: body)
            }
        }
    }
    
    func hook() {
        if let session = USBDeviceManager.shared.session {
            let s = """
            function format(value) {
                const receiver = ObjC.Object(value);
                const request = receiver.originalRequest();
                const NSString = ObjC.classes.NSString;
                var body = "";
                if ( request.HTTPBody() !== null) {
                    body = request.HTTPBody().base64EncodedStringWithOptions_(0);
                }
                ObjC.schedule(ObjC.mainQueue, function () {
                    const { UIApplication } = ObjC.classes;
                    var status = UIApplication.sharedApplication().applicationState();
                    console.log(request.URL() + "ƒ" + request.allHTTPHeaderFields() + "ƒ" + request.HTTPMethod() + "ƒ" + body + "ƒ" + status);
                });
            }

            async function hook_request() {
                const resolver = new ApiResolver("objc");
                resolver.enumerateMatches("-[NSURLSessionTask resume]", {
                    onMatch: function (i) {
                        Interceptor.attach(i.address, {
                            onEnter(args) {
                                format(args[0]);
                            }
                        });
                    },
                    onComplete: function () {

                    }
                });
                resolver.enumerateMatches("-[NSURLConnection start]", {
                    onMatch: function (i) {
                        Interceptor.attach(i.address, {
                            onEnter(args) {
                                format(args[0]);
                            }
                        });
                    },
                    onComplete: function () {

                    }
                });
            }

            hook_request();
            """
            session.createScript(s, name: "HookRequest", runtime: ScriptRuntime.auto) { scriptResult in
                do {
                    self.script = try scriptResult()
                    self.script?.delegate = self
                    self.script?.load() { result in
                        do {
                            if try result() {
                                print("Script HookRequest loaded")
                            } else {
                                print("Script HookRequest loaded failed")
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

class HookWKWebView: ScriptDelegate, FridaHook {
    private var script: Script?

    func scriptDestroyed(_ script: Script) {
        print("\(script) scriptDestroyed")
    }

    func script(_ script: Script, didReceiveMessage message: Any, withData data: Data?) {
        
    }
    
    func hook() {
        if let session = USBDeviceManager.shared.session {
            let s = """
            const NSMutableDictionary = ObjC.classes.NSMutableDictionary;
            const NSNumber = ObjC.classes.NSNumber;
            const NSString = ObjC.classes.NSString;
            const NSURLRequest = ObjC.classes.NSURLRequest;
            const NSURLSession = ObjC.classes.NSURLSession;
            const NSObject = ObjC.classes.NSObject;
            const WKWebViewConfiguration = ObjC.classes.WKWebViewConfiguration;
            const WKWebView = ObjC.classes.WKWebView;
            
            const cache = NSMutableDictionary.alloc().init();
            const MyWKURLSchemeHandler = ObjC.registerClass({
                name: 'MyWKURLSchemeHandler',
                super: NSObject,
                protocols: [ObjC.protocols.WKURLSchemeHandler],
                methods: {
                    '- init': function () {
                        const self = this.super.init();
                        if (self !== null) {
                            ObjC.bind(self, { });
                        }
                        return self;
                    },
                    '- dealloc': function () {
                        ObjC.unbind(this.self);
                        this.super.dealloc();
                    },
                    '- webView:startURLSchemeTask:': function (webView, urlSchemeTask) {
                        cache.setObject_forKey_("1", urlSchemeTask.description());
                        var handler = new ObjC.Block({
                            retType: 'void',
                            argTypes: ['object', 'object', 'object'],
                            implementation: function (data, response, error) {
                                if (cache.objectForKey_(urlSchemeTask.description()) !== null) {
                                    if (error) {
                                        urlSchemeTask.didFailWithError_(error);
                                    } else {
                                        urlSchemeTask.didReceiveResponse_(response);
                                        urlSchemeTask.didReceiveData_(data);
                                        urlSchemeTask.didFinish();
                                    }
                                }
                            }
                        });
                        NSURLSession.sharedSession().dataTaskWithRequest_completionHandler_(urlSchemeTask.request(), handler).resume();
                    },
                    '- webView:stopURLSchemeTask:': function (webView, urlSchemeTask) {
                        cache.removeObjectForKey_(urlSchemeTask.description());
                    }
                }
            });

            function hook_WKWebView1() {
                 const resolver = new ApiResolver('objc');
                 resolver.enumerateMatches("+[* handlesURLScheme:]", {
                     onMatch: function (i) {
                         Interceptor.attach(i.address, {
                             onEnter: function (args) {
                                 this.pass = false;
                                 var scheme = ObjC.Object(args[2]);
                                 if (scheme.isEqualToString_("https") || scheme.isEqualToString_("http")) {
                                     this.pass = true;
                                 }
                             },
                             onLeave(retval) {
                                 if (this.pass) {
                                     retval.replace(0x0);
                                 }
                             }
                         });
                     },
                     onComplete: function () {
                        hook_WKWebView2();
                     }
                 });
            }


            function hook_WKWebView2() {
                var hook = WKWebView['- initWithFrame:configuration:'];
                Interceptor.attach(hook.implementation, {
                    onEnter: function (args) {
                        var config = WKWebViewConfiguration.alloc().init();
                        if (config !== null) {
                            config = ObjC.Object(args[2]).copy();
                        }
                        if (config.urlSchemeHandlerForURLScheme_("http") !== true && WKWebView.handlesURLScheme_("http") !== true) {
                            config.setURLSchemeHandler_forURLScheme_(MyWKURLSchemeHandler.alloc().init(), "http");
                        }
                        if (config.urlSchemeHandlerForURLScheme_("https") !== true && WKWebView.handlesURLScheme_("https") !== true) {
                            config.setURLSchemeHandler_forURLScheme_(MyWKURLSchemeHandler.alloc().init(), "https");
                        }
                        args[2] = config;
                    }
                });
            }

            hook_WKWebView1();
            ObjC.schedule(ObjC.mainQueue, function () {
                
            });

            """
            session.createScript(s, name: "HookWKWebView", runtime: ScriptRuntime.auto) { scriptResult in
                do {
                    self.script = try scriptResult()
                    self.script?.delegate = self
                    self.script?.load() { result in
                        do {
                            if try result() {
                                print("Script HookWKWebView loaded")
                            } else {
                                print("Script HookWKWebView loaded failed")
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


class HookUIView: ScriptDelegate, FridaHook {
    private var script: Script?

    func scriptDestroyed(_ script: Script) {
        print("\(script) scriptDestroyed")
    }

    func script(_ script: Script, didReceiveMessage message: Any, withData data: Data?) {
        if let dic = message as? NSDictionary {
            if let p = dic["payload"] as? String {
                let arr = p.components(separatedBy: "ƒ")
                let className = arr[0]
                let labelText = arr[1]
                let imageStr = arr[2]
                if let d = Data(base64Encoded: imageStr), let image = NSImage(data: d) {
                    print(image)
                }
            }
        }
    }
    
    func hook() {
        if let session = USBDeviceManager.shared.session {
            let s = """
            const NSMutableDictionary = ObjC.classes.NSMutableDictionary;
            const NSData = ObjC.classes.NSData;
            const NSString = ObjC.classes.NSString;
            const UILabel = ObjC.classes.UILabel;
            const UIView = ObjC.classes.UIView;
            const UIViewController = ObjC.classes.UIViewController;
            const UIApplication = ObjC.classes.UIApplication;
            const UIScreen = ObjC.classes.UIScreen;
            const NSTimer = ObjC.classes.NSTimer;
            const paradise_labelDic = NSMutableDictionary.alloc().init();

            function screenshot(labelText, className) {
                paradise_labelDic.setObject_forKey_(labelText, className);
                const handler = new ObjC.Block({
                    retType: 'void',
                    argTypes: ['object'],
                    implementation() {
                        var getNativeFunction = function (ex, retVal, args) {
                            return new NativeFunction(Module.findExportByName('UIKit', ex), retVal, args);
                        };
                        var api = {
                            UIWindow: ObjC.classes.UIWindow,
                            UIGraphicsBeginImageContextWithOptions: getNativeFunction('UIGraphicsBeginImageContextWithOptions', 'void', [['double', 'double'], 'bool', 'double']),
                            UIGraphicsBeginImageContextWithOptions: getNativeFunction('UIGraphicsBeginImageContextWithOptions', 'void', [['double', 'double'], 'bool', 'double']),
                            UIGraphicsEndImageContext: getNativeFunction('UIGraphicsEndImageContext', 'void', []),
                            UIGraphicsGetImageFromCurrentImageContext: getNativeFunction('UIGraphicsGetImageFromCurrentImageContext', 'pointer', []),
                            UIImagePNGRepresentation: getNativeFunction('UIImagePNGRepresentation', 'pointer', ['pointer']),
                            UIImageJPEGRepresentation: getNativeFunction('UIImageJPEGRepresentation', 'pointer', ['pointer', 'double'])
                        };
                        var view = api.UIWindow.keyWindow();
                        var bounds = view.bounds();
                        var size = bounds[1];
                        api.UIGraphicsBeginImageContextWithOptions(size, 0, 0);
                        view.drawViewHierarchyInRect_afterScreenUpdates_(bounds, true);
                
                        var image = api.UIGraphicsGetImageFromCurrentImageContext();
                        api.UIGraphicsEndImageContext();
                
                        var png = new ObjC.Object(api.UIImageJPEGRepresentation(image, 0.5));
                        var str = png.base64EncodedStringWithOptions_(0);
                        console.log(className + "ƒ" + labelText + "ƒ" + str);
                    }
                });
                ObjC.schedule(ObjC.mainQueue, function () {
                    NSTimer.scheduledTimerWithTimeInterval_repeats_block_(0.25, 0x0, handler);
                });
            }

            function hook_layoutSubview() {
                var hook = UIView['- layoutSubviews'];
                Interceptor.attach(hook.implementation, {
                    onEnter: function (args) {
                        var self = ObjC.Object(args[0]);
                        if (self.class().isSubclassOfClass_(UILabel.class())) {
                            var s = self.text();
                            var next = self.nextResponder();
                            while (next !== null) {
                                if (next.isKindOfClass_(UIViewController.class()) || next.$className === "UIApplication") {
                                    var className = next.class().toString()
                                    if (paradise_labelDic.valueForKey_(className) === null) {
                                        if (s.containsString_("隐私权政策")) {
                                            screenshot("隐私权政策", className);
                                        }
                                        if (s.containsString_("用户名")) {
                                            screenshot("用户名", className);
                                            paradise_labelDic.setObject_forKey_("1", next.class().toString());
                                        }
                                        if (s.containsString_("密码")) {
                                            screenshot("密码", className);
                                        }
                                    }
                                    break;
                                }
                                next = next.nextResponder();
                            }
                        }
                    }
                });
            }

            ObjC.schedule(ObjC.mainQueue, function () {
                hook_layoutSubview();
            });
            """
            session.createScript(s, name: "HookUIView", runtime: ScriptRuntime.auto) { scriptResult in
                do {
                    self.script = try scriptResult()
                    self.script?.delegate = self
                    self.script?.load() { result in
                        do {
                            if try result() {
                                print("Script HookUIView loaded")
                            } else {
                                print("Script HookUIView loaded failed")
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
