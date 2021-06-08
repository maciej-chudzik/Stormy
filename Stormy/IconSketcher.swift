//
//  IconSketcher.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import ImageSketcher
import CoreGraphics

class IconSketcher: ImageSketcher{
    
    
    func drawUVIndexIcon(mode: DrawingMode) -> Self{
        
        let piece = getCanvasPiece(part: .middle)!
        let area = TextArea(area: piece)
        
        scheduleInstruction(with:area.drawText(text: "UV", mode: mode)!)
            
        return self
    }
    
    
    func drawWindDirectionIcon(mode:DrawingMode, windBearing: Int) -> Self {
        
        let centerArea = getCanvasPiece(part: .middle)!.boundingBox
            
        let radius = centerArea.width/2
            
        let center = CGPoint(x: centerArea.origin.x + centerArea.width/2, y: centerArea.origin.y + centerArea.height/2)
            
        let angle = CGFloat(windBearing).toRadians() - CGFloat(90.0).toRadians()
        
        let circle = Circle(radius: radius, center: center)
       
        
        let pointOnCircle = circle!.findPointOnCircle(angle: angle)
        
        let arrow = Arrow(start: pointOnCircle, end: center, angle: 30.0, wingLength: 5.0)
        scheduleInstruction(instruction: arrow!.draw(mode: mode))
        
        let northPiece = getCanvasPiece(part: .topMiddle)!
        let northArea = TextArea(area: northPiece)
        
        scheduleInstruction(with:northArea.drawText(text: "N", mode: mode)!)
        
        let textSize =  northArea.getLastDrawable()?.getTextSize()
        
        let eastPiece = getCanvasPiece(part: .right)!
        let eastArea = TextArea(area: eastPiece)
        
        eastArea.drawText(text: "E", mode: mode, centerVertically: true)!.adjustSizeToLastDrawable(size: textSize!)
        
        
        scheduleInstruction(with:eastArea)
        
        let southPiece = getCanvasPiece(part: .bottomMiddle)!
        let southArea = TextArea(area: southPiece)
        
        let _ =  southArea.drawText(text: "S", mode: mode)
        
        scheduleInstruction(with:southArea)
        
        let westPiece = getCanvasPiece(part: .left)!
        let westArea = TextArea(area: westPiece)
        
        westArea.drawText(text: "w", mode: mode, centerVertically: true)!.adjustSizeToLastDrawable(size: textSize!)
        
        scheduleInstruction(with:westArea)
 

        return self

        
    }
    
    func drawMoonIcon(mode: DrawingMode, moonPhaseData: Double) -> Self {
        
        let piece = getCanvasPiece(part: .middle)!
        
        let moon = Moon(in: piece.boundingBox, moonPhaseData: moonPhaseData)
        
        scheduleInstruction(instruction: moon!.draw(mode: mode))
        
        return self
    }

}
