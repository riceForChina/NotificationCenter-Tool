//
//  DemoVc.swift
//  KCNotificationCenterTool
//
//  Created by FanQiLe on 2021/9/27.
//

import UIKit

class DemoVc: UIViewController,KCNotificationObserverProtocol,KCKVOObserverProtocol {
    static let CLICK_BTN = Notification.Name(rawValue: "click_Btn")
    
    lazy var btn: UIButton = {
        let temp = UIButton(type: .custom)
        self.view.addSubview(temp)
        temp.setTitle("clickBtn", for: .normal)
        temp.setTitleColor(UIColor.black, for: .normal)
        temp.addAction { [weak self](button) in
            NotificationCenter.default.post(name: DemoVc.CLICK_BTN, object: nil)
        }
        return temp
    }()
    
    lazy var disMissBtn: UIButton = {
        let temp = UIButton(type: .custom)
        self.view.addSubview(temp)
        temp.setTitle("disMissBtn", for: .normal)
        temp.setTitleColor(UIColor.black, for: .normal)
        temp.addAction { [weak self](button) in
            self?.dismiss(animated: true, completion: nil)
        }
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addKVOObserver(target: btn, keyPath: "frame", option: [.new,.old]) { (change) in
            print("change -----\(change)")
        }
        self.view.backgroundColor = .white
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        disMissBtn.frame = CGRect(x: 100, y: 300, width: 100, height: 100)
        addNotificationObserver(forName: DemoVc.CLICK_BTN, object: nil, queue: OperationQueue.main) { [weak self](notification) in
            print("clickBtn")
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
