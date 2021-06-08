//
//  Moon.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import ImageSketcher
import CoreGraphics

struct Moon: RectCalculatable{
    
    enum MoonPhases{
        
        case newMoon
        case waxingCrescent
        case firstQuarter
        case waxingGibbous
        case fullMoon
        case waningGibbous
        case thirdQuarter
        case waningCrescent
        
    }
    
    var boundingBox: CGRect
    let moonPhaseData: Double
    
    var moonPhase: MoonPhases?{
        
        if moonPhaseData == 0.0 {
            
            return .newMoon
            
        }else if moonPhaseData > 0.0 && moonPhaseData < 0.25{
            
            return .waxingCrescent
            
        }else if moonPhaseData == 0.25{
            
            return .firstQuarter
            
        }else if moonPhaseData > 0.25 && moonPhaseData < 0.5{
            
            return .waxingGibbous
            
        }else if moonPhaseData == 0.5{
            
            return .fullMoon
            
        }else if moonPhaseData > 0.5 && moonPhaseData < 0.75{
            
            return .waningGibbous
            
        }else if moonPhaseData == 0.75{
            
            return .thirdQuarter
            
        }else if moonPhaseData > 0.75 && moonPhaseData < 1.0{
            
            return .waningCrescent
            
        }
        return nil
    }
    
    
    init?(in boundingBox: CGRect, moonPhaseData: Double){
        guard moonPhaseData >= 0.0 &&  moonPhaseData < 1.0 else {return nil}
        self.boundingBox = boundingBox
        self.moonPhaseData = moonPhaseData
        
    }
    
    static func determinePhaseName(moonPhaseData: Double) -> String {
        
        
        if moonPhaseData == 0.0 {
            
            return "new moon"
            
        }else if moonPhaseData > 0.0 && moonPhaseData < 0.25{
            
            return "waxing crescent"
            
        }else if moonPhaseData == 0.25{
            
            return "first quarter"
            
        }else if moonPhaseData > 0.25 && moonPhaseData < 0.5{
            
            return "waxing gibbous"
            
        }else if moonPhaseData == 0.5{
            
            return "full moon"
            
        }else if moonPhaseData > 0.5 && moonPhaseData < 0.75{
            
            return "waning gibbous"
            
        }else if moonPhaseData == 0.75{
            
            return "third quarter"
            
        }else if moonPhaseData > 0.75 && moonPhaseData < 1.0{
            
            return "waning crescent"
            
        }
        
        return ""
        
    }
    
}

@available(iOS 10.0, *)

extension Moon: Drawable{

func draw(mode:DrawingMode) -> ImageRendererContextModification{

    return { (context) in
        
        context.cgContext.saveGState()
        let _ =  mode.apply(context)
        
        let arcCenter = CGPoint(x: self.boundingBox.origin.x + self.boundingBox.width/2, y: self.boundingBox.origin.y + self.boundingBox.height/2)
     
        var clockwise: Bool?
        var multipier: Double
        let radius = boundingBox.width/2
        var centerXShift: CGFloat
        var angle: CGFloat
        var startAngle: CGFloat
        var endAngle: CGFloat
        
        switch moonPhase{
            
            
        case .newMoon?:
            
             context.cgContext.addEllipse(in: self.boundingBox)
            
        case .firstQuarter?:
            
            context.cgContext.addArc(center: arcCenter, radius: radius, startAngle: CGFloat(270.0).toRadians(), endAngle: CGFloat(90.0).toRadians(), clockwise: false)
            context.cgContext.closePath()
            
            context.cgContext.fillPath()
            
            context.cgContext.addEllipse(in: self.boundingBox)
            
        case .fullMoon?:
            
            context.cgContext.addEllipse(in: self.boundingBox)
            
            context.cgContext.fillPath()
            
            
        case .thirdQuarter?:
            
            context.cgContext.addArc(center: arcCenter, radius: radius, startAngle: CGFloat(270.0).toRadians(), endAngle: CGFloat(90.0).toRadians(), clockwise: true)
            
            context.cgContext.closePath()
            
            context.cgContext.fillPath()
            
            context.cgContext.addEllipse(in: self.boundingBox)
            
        case .waningGibbous?:
                
            multipier = (moonPhaseData - 0.5) * 4
                
            angle = CGFloat(90.0).toRadians() * CGFloat(multipier)
                
            centerXShift =  radius * CGFloat(tan(angle))
                
            centerXShift *= 1
             clockwise = true
                
            context.cgContext.addArc(center: arcCenter, radius: radius, startAngle: CGFloat(270.0).toRadians(), endAngle: CGFloat(90.0).toRadians(), clockwise: true)
                
            context.cgContext.closePath()
                
            
            startAngle = CGFloat(90.0).toRadians() - CGFloat(angle)
                
            endAngle = CGFloat(270.0).toRadians() + CGFloat(angle)
            
            context.cgContext.addArc(center: CGPoint(x: arcCenter.x - centerXShift, y: arcCenter.y), radius: radius / CGFloat(cosf(Float(angle))), startAngle: startAngle, endAngle:
                    endAngle, clockwise: clockwise!)
                
            context.cgContext.closePath()
                
            context.cgContext.fillPath()
                
            context.cgContext.addEllipse(in: self.boundingBox)
            
        case .waxingGibbous?:
            
            multipier = (1 - moonPhaseData - 0.5) * 4
            
            angle = CGFloat(90.0).toRadians() * CGFloat(multipier)
            
            centerXShift =  radius * CGFloat(tan(angle))
            
            centerXShift *= -1
            clockwise = true
            
            context.cgContext.addArc(center: arcCenter, radius: radius, startAngle: CGFloat(270.0).toRadians(), endAngle: CGFloat(90.0).toRadians(), clockwise: false)
            context.cgContext.closePath()
            
            startAngle = -CGFloat(90.0).toRadians() - CGFloat(angle)
            
            endAngle = -CGFloat(270.0).toRadians() + CGFloat(angle)
            
            context.cgContext.addArc(center: CGPoint(x: arcCenter.x - centerXShift, y: arcCenter.y), radius: radius / CGFloat(cosf(Float(angle))), startAngle: startAngle, endAngle:
                endAngle, clockwise: clockwise!)
            
            
            context.cgContext.closePath()
            context.cgContext.fillPath()
            context.cgContext.addEllipse(in: self.boundingBox)
            
      
        case .waningCrescent?:
                
            multipier = (1 - moonPhaseData) * 4

            angle = CGFloat(90.0).toRadians() * CGFloat(multipier)
                
            centerXShift =  radius * CGFloat(tan(angle))

            centerXShift *= -1
            
            clockwise = false
            
            context.cgContext.addArc(center: arcCenter, radius: radius, startAngle: CGFloat(270.0).toRadians(), endAngle: CGFloat(90.0).toRadians(), clockwise: true)
            startAngle = -CGFloat(270.0).toRadians() + CGFloat(angle)
                
            endAngle = -CGFloat(90.0).toRadians() - CGFloat(angle)
            
            context.cgContext.addArc(center: CGPoint(x: arcCenter.x - centerXShift, y: arcCenter.y), radius: radius / CGFloat(cosf(Float(angle))), startAngle: startAngle, endAngle:
                    endAngle, clockwise: clockwise!)
                
            context.cgContext.closePath()
                
            context.cgContext.fillPath()
                
            context.cgContext.addEllipse(in: self.boundingBox)
            
        case .waxingCrescent?:
            
            multipier = moonPhaseData * 4
            
            angle = CGFloat(90.0).toRadians() * CGFloat(multipier)
            
            centerXShift = radius * CGFloat(tan(angle))
            
            centerXShift *= 1
            clockwise = true
           
            
            context.cgContext.addArc(center: arcCenter, radius: radius, startAngle: CGFloat(270.0).toRadians(), endAngle: CGFloat(90.0).toRadians(), clockwise: false)
            
            
            startAngle = -CGFloat(270.0).toRadians() - CGFloat(angle)
            
            endAngle =  -CGFloat(90.0).toRadians() + CGFloat(angle)

            context.cgContext.addArc(center: CGPoint(x: arcCenter.x - centerXShift, y: arcCenter.y), radius:  radius / CGFloat(cosf(Float(angle))), startAngle: startAngle, endAngle:
                endAngle, clockwise: clockwise!)
            
            context.cgContext.closePath()
            context.cgContext.fillPath()
            context.cgContext.addEllipse(in: self.boundingBox)
            

        case .none:
            
            return context
        
        }
        
        switch mode {
        case .stroke(_, _):
            context.cgContext.drawPath(using: .stroke)
        case .strokeAndFill(_, _, _):
            context.cgContext.drawPath(using: .stroke)
        case .dashedStroke(strokecolor: _, width: _, phase: _, pattern: _):
            context.cgContext.drawPath(using: .stroke)
        }
        
      
        context.cgContext.restoreGState()
        
      return context}
}

}
