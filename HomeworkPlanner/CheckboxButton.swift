//
//  CheckboxButton.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 11/18/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

@IBDesignable
class CheckboxButton: UIButton {
    
    var color: UIColor?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        // Draw Circle
        let circleLineWidth: CGFloat = 2
        let circleDiameter: CGFloat = 22 - 2*circleLineWidth
        let circleBoundingRect: CGRect = CGRect(x: rect.midX-circleDiameter/2, y: rect.midY-circleDiameter/2, width: circleDiameter, height: circleDiameter)
        
        let circlePath = UIBezierPath(ovalInRect: circleBoundingRect)
        circlePath.lineWidth = circleLineWidth
        
        if (color != nil) {
            color!.setStroke()
        } else {
            tintColor.setStroke()
        }
        
        circlePath.stroke()
        
        
        // Draw Checkmark
        if (state == UIControlState.Highlighted || state == UIControlState.Selected) {
            let checkmarkLineWidth: CGFloat = circleLineWidth
            
            let checkmarkPath = UIBezierPath()
            checkmarkPath.lineWidth = checkmarkLineWidth
            
            checkmarkPath.moveToPoint(CGPoint(
                x: circleBoundingRect.minX + circleDiameter/4,
                y: circleBoundingRect.minY + circleDiameter*(7/12)))
            
            checkmarkPath.addLineToPoint(CGPoint(
                x: circleBoundingRect.minX + circleDiameter/2,
                y: circleBoundingRect.minY + circleDiameter*(3/4)))
            
            checkmarkPath.addLineToPoint(CGPoint(
                x: circleBoundingRect.minX + circleDiameter*(3/4),
                y: circleBoundingRect.minY + circleDiameter*(1/4)))
            
            if (color != nil) {
                color!.setStroke()
            } else {
                tintColor.setStroke()
            }
            
            checkmarkPath.stroke()
        }
    }

}
