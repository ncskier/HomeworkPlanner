//
//  ColorSelectButton.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 11/18/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

@IBDesignable
class ColorSelectButton: UIButton {
    
    var fillColor: UIColor?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        // Fill Box
        let boxRect = rect
        let circle = UIBezierPath(ovalInRect: boxRect)
//        let box = UIBezierPath(rect: boxRect)
        
        if (fillColor != nil) {
            fillColor!.setFill()
        }
        
        circle.fill()
        
        
        // Stroke Box
        if (selected) {
            let strokeWidth: CGFloat = boxRect.width/20
            let offset: CGFloat = boxRect.width/5
            let length: CGFloat = boxRect.width - 2*(strokeWidth + offset)
            let strokeRect = CGRect(x: boxRect.minX + strokeWidth + offset, y: boxRect.minY + strokeWidth + offset, width: length, height: length)
//            let strokeBox = UIBezierPath(rect: strokeRect)
            let strokeCircle = UIBezierPath(ovalInRect: strokeRect)
            
            UIColor.whiteColor().setStroke()
            UIColor.whiteColor().setFill()
            strokeCircle.lineWidth = strokeWidth
            
//            strokeCircle.stroke()
            strokeCircle.fill()
        }
    }

}
