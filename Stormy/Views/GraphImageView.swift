//
//  GraphImageView.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import UIKit

class GraphImageView: UIImageView, Fullscreenable, RollableUp{
  
 
    var fullscreened: Bool = false
    var zeroHeightConstraint: NSLayoutConstraint? = nil
  
    
 
    override init (frame : CGRect) {
        super.init(frame : frame)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fullScreenToggle))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
   
    @objc private func fullScreenToggle(){
        let fullscreenanimation = viewsAnimations.goFullscreen(duration: 0.8, delayFactor: 0, direction: .right)
        let animator1 = ViewsAnimator(animation: fullscreenanimation)
        animator1.animateView(view: self)
        
        let hourlyVC = self.findViewController() as! HourlyWeatherVC
        let weatherDataScrollView = hourlyVC.weatherDataScrollView
        let multiSelectSegmentedControl = hourlyVC.segementedSelectionView
        
        let fadeanimation = viewsAnimations.fadeView(duration: 0.8, delayFactor: 0)
        let animator2 = ViewsAnimator(animation: fadeanimation)
        animator2.animateView(view: weatherDataScrollView!)
        animator2.animateView(view: multiSelectSegmentedControl!)

    }

}






