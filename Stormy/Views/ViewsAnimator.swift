//
//  ViewsAnimator.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import UIKit
import SweeterSwift


class ViewsAnimator {
    
    private var hasAnimatedAllCells = false
    private let tableViewCellsAnimation: ((UITableViewCell, IndexPath, UITableView) -> ())?
    private let viewAnimation: ((UIView)-> ())?
    
    init(animation: @escaping (UITableViewCell, IndexPath, UITableView) -> ()) {
        self.tableViewCellsAnimation = animation
        self.viewAnimation = nil
    }
    
    init(animation:  @escaping (UIView) -> ()) {
        self.tableViewCellsAnimation = nil
        self.viewAnimation = animation
    }
    
    
    
    func animateTableViewCells(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }
        
        tableViewCellsAnimation!(cell, indexPath, tableView)
        
        hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
    }
    
    
    func animateView(view: UIView) {
        
        viewAnimation!(view)
        
    }
    
    
}


struct viewsAnimations {
    
    static func rollUp(duration: TimeInterval, delayFactor: Double) -> (UIView) -> (){
        
        return { view in
            
            if let viewConfromedToRolledUp = view as? RollableUp {
                
                UIView.animate(withDuration: duration, delay: delayFactor, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
                    
                    if viewConfromedToRolledUp.zeroHeightConstraint == nil {
                        
                        viewConfromedToRolledUp.zeroHeightConstraint = view.constrain(NSLayoutConstraint.Attribute.height, to: 0)
                        
                        view.superview?.layoutSubviews()
                        
                    }else{
                        
                        view.removeConstraint(viewConfromedToRolledUp.zeroHeightConstraint!)
                        viewConfromedToRolledUp.zeroHeightConstraint = nil
                        view.superview?.layoutSubviews()
                        
                    }
                    
                    
                    
                })
            }
            
        }
    }
    
    
    
    static func pulseAndBlink(duration: TimeInterval, scale: CGFloat) -> (UIView) -> (){
        
        return { view in
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [.repeat, .autoreverse],
                animations: {
                    view.alpha = 0
                    view.transform = CGAffineTransform(scaleX: scale, y: scale)
                    view.alpha = 1
                    view.transform = CGAffineTransform.identity
                })
            
            
            
            
        }
    }
    
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> (UIView) -> () {
        return { view in
            view.transform = CGAffineTransform(translationX: view.superview!.bounds.width, y: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor,
                options: [.curveEaseInOut],
                animations: {
                    view.transform = CGAffineTransform(translationX: 0, y: 0)
                })
        }
    }
    
    static func fadeView(duration: TimeInterval, delayFactor: Double) -> (UIView) -> () {
        
        return { view in
            
            if let viewConfromedToFadable = view as? Fadable {
                
                UIView.animate(withDuration: duration, delay: delayFactor, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
                    
                    if !viewConfromedToFadable.isFaded {
                        
                        view.alpha = 0.0
                        viewConfromedToFadable.isFaded.toggle()
                        
                    }else{
                        
                        
                        view.alpha = 1.0
                        viewConfromedToFadable.isFaded.toggle()
                    }
                    
                    
                    
                })
            }
            
        }
        
        
    }
    static func goFullscreen(duration: TimeInterval, delayFactor: Double, direction: Directions) -> (UIView) -> () {
        return { view in
            
            if let viewConfromedToFullscreenable = view as? Fullscreenable {
                
                
                UIView.animate(withDuration: duration, delay: delayFactor, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
                    
                    if let ownViewController = view.findViewController(){
                        
                        let fullscreenCenter = ownViewController.view.center
                        
                        let insetY = ownViewController.view.safeAreaInsets.top/2
                        
                        let ratio =  insetY / ownViewController.view.frame.height
                        
                        let insetX = ownViewController.view.frame.width * ratio
                        
                        let fullscreenSafeFrame = ownViewController.view.frame.insetBy(dx: insetX, dy: insetY)
                        

                        if !viewConfromedToFullscreenable.fullscreened {
                            
                            ownViewController.navigationController?.navigationBar.alpha = 0.0
                            
                            view.layer.borderColor = UIColor.clear.cgColor
                            
                            let angle = UnitsConverter.degreesToCGFloatRadians(direction.rawValue)
                            
                            let scale = (x: fullscreenSafeFrame.width/view.frame.height, y: fullscreenSafeFrame.height/view.frame.width)
                            
                            let translation = (x: fullscreenCenter.x - view.center.x, y: fullscreenCenter.y - view.center.y)
                            
                            view.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(scaleX: scale.x, y: scale.y)).concatenating(CGAffineTransform(translationX: translation.x, y: translation.y))
                            
                            viewConfromedToFullscreenable.fullscreened = true
                            
                        }else{
                            
                            view.transform = CGAffineTransform.identity
                            
                            ownViewController.navigationController?.navigationBar.alpha = 1.0
                            
                            view.layer.borderColor = UIColor.white.cgColor
                            
                            viewConfromedToFullscreenable.fullscreened.toggle()
                            
                        }
                        
                    }
                    
                    
                })
            }
            
        }
    }
    
}
    


struct tableViewCellsAnimations {
    
    static func makeFadeAnimation(duration: TimeInterval, delayFactor: Double) -> (UITableViewCell, IndexPath, UITableView) -> () {
        return { cell, indexPath, _ in
            cell.alpha = 0
            
            UIView.animate(withDuration: duration, delay: delayFactor * Double(indexPath.row),animations:{
                cell.alpha = 1
            })
        }
    }
    
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> (UITableViewCell, IndexPath, UITableView) -> () {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
        }
    }
    
    
}
