//
//  UIButton+Action.swift
//  KCNotificationCenterTool
//
//  Created by FanQiLe on 2021/9/27.
//

import UIKit

//block UIButton
private var ActionBlockKey: UInt8 = 0


/// UIButton的点击事件闭包块声明 <p>
/// 参照 `UIButton.addAction(_:)`
public typealias BlockButtonActionBlock = (_ sender: UIButton) -> Void

private class ActionBlockWrapper : NSObject {
    var block : BlockButtonActionBlock
    init(block: @escaping BlockButtonActionBlock) {
        self.block = block
    }
}

// MARK: - 可闭包捕获点击的按钮
public extension UIButton {
    
    /// 为button添加点击事件
    ///
    /// - Parameter block: 点击捕获的代码块
    func addAction(_ block: @escaping BlockButtonActionBlock) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(handleAction(_:)), for: .touchUpInside)
    }
    
    @objc private func handleAction(_ sender: UIButton) {
        if let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as? ActionBlockWrapper{
            wrapper.block(sender)
        }
    }
}

