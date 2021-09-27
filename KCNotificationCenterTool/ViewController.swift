//
//  ViewController.swift
//  KCNotificationCenterTool
//
//  Created by FanQiLe on 2021/9/27.
//

import UIKit

class ViewController: UIViewController {


    lazy var presentBtn: UIButton = {
        let temp = UIButton(type: .custom)
        self.view.addSubview(temp)
        temp.setTitle("presentBtn", for: .normal)
        temp.setTitleColor(UIColor.black, for: .normal)
        temp.addAction { [weak self](button) in
            let vc = DemoVc()
            self?.present(vc, animated: true, completion: nil)
        }
        return temp
    }()
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        presentBtn.frame = CGRect(x: 100, y: 300, width: 100, height: 100)
    }


}

