//
//  BackgroundView.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import UIKit

class BackgroundView: UIView {

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        let purpleGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [lightPurple.cgColor, darkPurple.cgColor] as CFArray, locations: [0,1])
  
        let backgroundPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        context!.saveGState()
        backgroundPath.addClip()
        context?.drawLinearGradient(purpleGradient!,
            start: CGPoint(x: 160, y: 0),
            end: CGPoint(x: 160, y: 568),
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context!.restoreGState()
    }


}
