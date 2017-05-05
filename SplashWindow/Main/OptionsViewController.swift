//
//  OptionsViewController.swift
//  Planhola
//
//  Created by Hao Zheng on 4/15/17.
//  Copyright © 2017 Hao Zheng. All rights reserved.
//

import UIKit

public class OptionsViewController: UIViewController {
    
    public var touchIDBtnImage: UIImage?
    public var logoutBtnBtnImage: UIImage?
    
    @IBOutlet weak var touchIDBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var didClickTouchID: (UIButton) -> () = { _ in }
    var didClicklogout: () -> () = { _ in }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = touchIDBtnImage {
            touchIDBtn.setImage(image, for: UIControlState())
        }
        if let image = logoutBtnBtnImage{
            logoutBtn.setImage(image, for: UIControlState())
        }
        
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
