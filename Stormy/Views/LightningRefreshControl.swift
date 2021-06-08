//
//  LightningRefreshControl.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import UIKit

class LightningRefreshControl: UIRefreshControl {
    
    var nvActivityIndicator: NVActivityIndicatorView?
    
    override func draw(_ rect: CGRect) {
        
        self.tintColor = UIColor.clear
        
        nvActivityIndicator = NVActivityIndicatorView(frame: self.bounds, type: NVActivityIndicatorType.lightning, color: .white, padding: 0)
        nvActivityIndicator?.backgroundColor = self.backgroundColor
        nvActivityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(nvActivityIndicator!)
        
        let nvActivityIndicator_top = NSLayoutConstraint(item: nvActivityIndicator!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let nvActivityIndicator_bottom = NSLayoutConstraint(item: nvActivityIndicator!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let nvActivityIndicator_leading = NSLayoutConstraint(item: nvActivityIndicator!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let nvActivityIndicator_trailing = NSLayoutConstraint(item: nvActivityIndicator!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.addConstraint(nvActivityIndicator_top)
        self.addConstraint(nvActivityIndicator_bottom)
        self.addConstraint(nvActivityIndicator_leading)
        self.addConstraint(nvActivityIndicator_trailing)
        
    }
    
    
}
