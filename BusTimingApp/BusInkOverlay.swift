//
//  BusInkOverlay.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 8/9/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import MaterialComponents

class BusInkOverlay: UIView, MDCInkTouchControllerDelegate {
    
    private var inkTouchController: MDCInkTouchController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let cyan = UIColor(red: 22 / 255, green: 240 / 255, blue: 240 / 255, alpha: 0.2)
        self.inkTouchController = MDCInkTouchController(view: self)
        self.inkTouchController?.delegate = self
        self.inkTouchController?.defaultInkView.inkColor = MDCPalette.grey.tint100
        self.inkTouchController?.addInkView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
