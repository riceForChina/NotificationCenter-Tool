//
//  NotificationCenter+Tool.swift
//  KCNotificationCenterTool
//
//  Created by FanQiLe on 2021/9/27.
//

import UIKit

/// 包装来自于NotificationCenter.addObserver(forName:object:queue:using:)观察者token
/// 当token deinit的时候，自动删除观察者。
public final class NotificationToken: NSObject {
    let notificationCenter: NotificationCenter
    let token: Any
    
    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }
    deinit {
        notificationCenter.removeObserver(token)
    }
}

extension NotificationCenter {
    /// 封装NotificationCenter.addObserver(forName:object:queue:using:)
    /// 返回自定义的NotificationToken
    public func observe(forName name: NSNotification.Name,
                        object obj: Any?,
                        queue: OperationQueue?,
                        using block: @escaping (Notification) -> ()) -> NotificationToken {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }
}


private var tokensKey = "KCNotificationTokensKey"
public protocol KCNotificationObserverProtocol: NSObjectProtocol {}

extension KCNotificationObserverProtocol {
    /// 封装NotificationCenter.addObserver(forName:object:queue:using:)
    /// 动态给当前对象增加观察者token字典 [NSNotification.Name: NotificationToken]
    public func addNotificationObserver(forName name: NSNotification.Name,
                                        object obj: Any?,
                                        queue: OperationQueue?,
                                        using block: @escaping (Notification) -> ()) {
        var tokens = getTokens()
        let token = NotificationCenter.default.observe(forName: name, object: nil, queue: queue, using: block)
        tokens[name] = token
        setTokens(tokens)
    }
    
    /// 删除某个观察
    /// - Parameter name: NSNotification.Name
    public func removeNotificationObserver(forName name: NSNotification.Name) {
        var tokens = getTokens()
        tokens.removeValue(forKey: name)
        setTokens(tokens)
    }
        
    private func getTokens() -> [NSNotification.Name: NotificationToken] {
        synchronized(self) {
            if let observers = objc_getAssociatedObject(self, &tokensKey) as? [NSNotification.Name: NotificationToken] {
                return observers
            }
            return [NSNotification.Name: NotificationToken]()
        }
    }
    
    private func setTokens(_ tokens: [NSNotification.Name: NotificationToken]) {
        synchronized(self) {
            objc_setAssociatedObject(self, &tokensKey, tokens, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try body()
}
