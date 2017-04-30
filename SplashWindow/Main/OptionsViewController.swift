//
//  OptionsViewController.swift
//  Planhola
//
//  Created by Hoa Zheng on 4/15/17.
//  Copyright © 2017 Hao Zheng. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var touchIDBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var didClickTouchID: (UIButton) -> () = { _ in }
    var didClicklogout: () -> () = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchIDBtn.setTitle(AuthStrings.touchID, for: UIControlState())
        logoutBtn.setTitle(AuthStrings.logout, for: UIControlState())
        touchIDBtn.centerVertically()
        logoutBtn.centerVertically()
        
        touchIDBtn.addBelowMotionEffect()
        logoutBtn.addBelowMotionEffect()
        
        view.addBlurView()
    }
    
    @IBAction func didClickTouchIDBtn(_ sender: UIButton) {
        didClickTouchID(sender)
    }
    
    @IBAction func didClickLogoutBtn(_ sender: UIButton) {
        didClicklogout()
    }
}
