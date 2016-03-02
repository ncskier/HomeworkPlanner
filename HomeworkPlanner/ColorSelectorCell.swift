//
//  ColorSelectorCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 11/18/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

protocol ColorSelectorCellDelegate {
    
    func colorSelectorCell(newButtonSelected button: ColorSelectButton)
}

class ColorSelectorCell: StaticTableViewCell {
    
    var delegate: ColorSelectorCellDelegate?
    var cellHeight: CGFloat?
    var cellWidth: CGFloat?
    var padding: CGFloat = 10
    var selectedButton: ColorSelectButton?
    let colorArray: [[CGFloat]] = [
        [1.0 , 0.0 , 0.0],
        [1.0 , 0.5 , 0.0],
        [1.0 , 0.0 , 0.5],
        
        [1.0 , 1.0 , 0.0],
        
        [0.0 , 1.0 , 0.0],
        [0.5 , 1.0 , 0.0],
        [0.0 , 1.0 , 0.5],
        
        [1.0 , 0.0 , 1.0],
        
        [0.0 , 0.0 , 1.0],
        [0.5 , 0.0 , 1.0],
        [0.0 , 0.5 , 1.0],
        
        [0.0 , 1.0 , 1.0],
        
        
        [19/255 , 149/255 , 186/255],
        [17/255 , 120/255 , 153/255],
        [15/255 , 91/255 , 120/255],
        [13/255 , 16/255 , 18/255],
        [192/255 , 46/255 , 29/255],
        [217/255 , 78/255 , 31/255],
        [241/255 , 108/255 , 32/255],
        [239/255 , 139/255 , 44/255],
        [236/255 , 170/255 , 56/255],
        [235/255 , 200/255 , 68/255],
        [162/255 , 184/255 , 108/255],
        [92/255 , 167/255 , 147/255]
        ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func configureCell(withWidth width: CGFloat, andSelectedColor selectedColor: UIColor?) {
        
        print("\nConfigure Color Cell")
        
//        let cols = colorArray.count
        let cols = 6
        let rows = colorArray.count / cols
        
        cellWidth = width
        let length = (width - padding*CGFloat(cols+1) )/CGFloat(cols)
        cellHeight = padding*CGFloat(rows+1) + length*CGFloat(rows)
        
        print("Color array: \(colorArray)")
        
        
        for var i = 0; i < colorArray.count; i++ {
            
            // Calculate Origin
            let column = i % cols
            let row = i / cols
            
            let x = padding*CGFloat(column+1) + length*CGFloat(column)
            let y = padding*CGFloat(row+1) + length*CGFloat(row)
            
            // Get Color
            let color = colorArray[i]
            print("color: \(color)")
            
            createColorButton(withX: x, y: y, length: length, colorArray: color, selectedColor: selectedColor)
        }
        
        /*
        for var i = 0; i < cols; i++ {
            
            // Origin X
            let x = padding*CGFloat(i+1) + length*CGFloat(i)
            print("\n\ni: \(i)")
            
            
            for var j = 0; j < rows; j++ {
                
                // Select Color
                var color = colorArray[i]
                
                print("colorBefore: \(color)")
                
                // Adjust Color Brightness
                for var k = 0; k < color.count; k++ {
                    if (color[k] != 0) {
                        color[k] = color[k] - 0.12*CGFloat(j)
                    }
                }
                
                print("Color: \(color)")
                
                // Origin Y
                let y = padding*CGFloat(j+1) + length*CGFloat(j)
                
                createColorButton(withX: x, y: y, length: length, colorArray: color, selectedColor: selectedColor)
            }
        }
        
        */
    }
    
    
    func createColorButton(withX x: CGFloat, y: CGFloat, length: CGFloat, colorArray color: [CGFloat], selectedColor: UIColor?) {
        
        // Create Color Selector Button
        let colorButton = ColorSelectButton()
        colorButton.frame = CGRect(x: x, y: y, width: length, height: length)
        colorButton.fillColor = UIColor(red: color[0], green: color[1], blue: color[2], alpha: 1.0)
        
        if (colorButton.fillColor == selectedColor) {
            colorButton.selected = true
            selectedButton = colorButton
        }
        
        colorButton.addTarget(self, action: "colorButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add Button
        contentView.addSubview(colorButton)
    }
    
    
    func colorButtonPressed(colorButton: ColorSelectButton) {
        
        if (selectedButton != nil) {
            selectedButton!.selected = false
        }
        
        colorButton.selected = true
        selectedButton = colorButton
        
        if (delegate != nil) {
            delegate?.colorSelectorCell(newButtonSelected: colorButton)
        }
    }

}
