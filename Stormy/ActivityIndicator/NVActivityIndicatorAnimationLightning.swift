//
//  NVActivityIndicatorAnimationLightning.swift
//  Stormy
//
//  Created by Maciej Chudzik on 11/11/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//
import UIKit


class NVActivityIndicatorAnimationLightning: NVActivityIndicatorAnimationDelegate {

    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let duration: CFTimeInterval = 1

        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")

        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1

        // Opacity animation
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")

        opacityAnimation.duration = duration
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        
        //Shake Animation
        
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.01
        shakeAnimation.repeatCount = 8
        shakeAnimation.autoreverses = true
        let offset  = layer.bounds.size.width / 120
        shakeAnimation.fromValue = CGPoint(x: layer.bounds.size.width / 2 - offset, y: layer.bounds.size.height / 2)
        shakeAnimation.toValue = CGPoint(x: layer.bounds.size.width / 2 + offset, y: layer.bounds.size.height / 2)

        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [opacityAnimation,shakeAnimation]
        #if swift(>=4.2)
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        #else
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        #endif
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        // Draw circle
        let lightning = NVActivityIndicatorShape.lightning.layerWith(size: size, color: color)

        lightning.frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                              y: (layer.bounds.size.height - size.height) / 2,
                              width: size.width,
                              height: size.height)
        lightning.add(animation, forKey: "animation")
        layer.addSublayer(lightning)
    }
}

