//
//  KVO+Tool.swift
//  KCNotificationCenterTool
//
//  Created by FanQiLe on 2021/9/28.
//

import UIKit

private var kvoTokensKey = "KCKVOObserverProtocol"
public protocol KCKVOObserverProtocol: NSObjectProtocol {}

public typealias KVOBlock = (([NSKeyValueChangeKey : Any]) -> ())
class KCKVOItemObj: NSObject {
    var block:KVOBlock?
    var target:NSObject?
    var keyPath: String?
    class func createOBj(target:NSObject,keyPath:String,option:NSKeyValueObservingOptions,block:KVOBlock?) -> KCKVOItemObj {
        let temp = KCKVOItemObj()
        temp.target = target
        temp.keyPath = keyPath
        temp.block = block
        target.addObserver(temp, forKeyPath: keyPath, options: option, context: nil)
        return temp
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.block?(change ?? [:])
    }
    deinit {
        self.target?.removeObserver(self, forKeyPath: self.keyPath ?? "")
    }
}

extension KCKVOObserverProtocol {
    public func addKVOObserver(target:NSObject,keyPath:String,option:NSKeyValueObservingOptions,block:KVOBlock?) {
        var tokens = getTokens()
        let obj = KCKVOItemObj.createOBj(target: target, keyPath: keyPath, option: option, block: block)
        let objStr = String(describing: target.self)
        tokens["\(objStr)\(keyPath)"] = obj;
        setTokens(tokens)
    }

        
    private func getTokens() -> [String: KCKVOItemObj] {
        synchronized(self) {
            if let observers = objc_getAssociatedObject(self, &kvoTokensKey) as? [String: KCKVOItemObj] {
                return observers
            }
            return [String: KCKVOItemObj]()
        }
    }
    
    private func setTokens(_ tokens: [String: KCKVOItemObj]) {
        synchronized(self) {
            objc_setAssociatedObject(self, &kvoTokensKey, tokens, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
