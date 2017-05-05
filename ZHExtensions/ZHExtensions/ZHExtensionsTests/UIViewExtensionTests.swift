//
//  UIViewExtensionTests.swift
//  ZHExtensions
//
//  Created by Hoa Zheng on 5/4/17.
//  Copyright © 2017 Hao Zheng. All rights reserved.
//

import XCTest
@testable import ZHExtensions

class UIViewExtensionTests: XCTestCase {
    
    func testUIViewShowNotAnimated() {
        let view = UIView()
        //show
        view.showSelf(show: true, animated: false)
        viewShouldBeShowing(view, showing: true)
        //hide
        view.showSelf(show: false, animated: false)
        viewShouldBeShowing(view, showing: false)
        
        //multi show or hide
        for _ in 0...1 {
            view.showSelf(show: true, animated: false)
        }
        viewShouldBeShowing(view, showing: true)
        
        for _ in 0...1 {
            view.showSelf(show: false, animated: false)
        }
        viewShouldBeShowing(view, showing: false)
    }
    
    func testUIViewShowAnimated() {
        let view = UIView()
        //show
        view.showSelf(show: true, animated: true) { _ in
            self.viewShouldBeShowing(view, showing: true)
        }
        //hide
        view.showSelf(show: false, animated: true) { _ in
            self.viewShouldBeShowing(view, showing: false)
        }
        
        //multi show or hide
        for _ in 0...1 {
            view.showSelf(show: true, animated: true) { _ in
                self.viewShouldBeShowing(view, showing: true)
            }
        }
        
        for _ in 0...1 {
            view.showSelf(show: false, animated: true) { _ in
                self.viewShouldBeShowing(view, showing: false)
            }
        }
    }
    
    //MARK: Helpers
    private func viewShouldBeShowing(_ view: UIView, showing: Bool) {
        if showing {
            XCTAssertEqual(view.alpha, 1)
            XCTAssertFalse(view.isHidden)
        } else {
            XCTAssertEqual(view.alpha, 0)
            XCTAssertTrue(view.isHidden)
        }
    }
}
