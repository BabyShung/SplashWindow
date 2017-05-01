//
//  LoginViewController.swift
//  Planhola
//
//  Created by Hao Zheng on 4/16/17.
//  Copyright © 2017 Hao Zheng. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!

    @IBAction func didClickLoginBtn(_ sender: Any) {
        let vc = AuthFlowController.init(self).authSettingVC
        let nvc = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.transitionRootTo(nvc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.setTitle("Login", for: UIControlState())
        loginBtn.centerVertically()
        loginBtn.addBelowMotionEffect()
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#EFF0F1")
    }
}
