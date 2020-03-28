//
//  CanvasView.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 07/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    fileprivate var lines = [Line]()
    var lineColor : CGColor = UIColor.black.cgColor
    var lineWidth : CGFloat = 5.0
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
                
        lines.forEach { (line) in
            context.setStrokeColor(line.color)
            context.setLineWidth(line.width)
            for (index, point) in line.points.enumerated() {
                if index == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line(points: [], color: lineColor, width: lineWidth))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        
        lines.append(lastLine)
        self.setNeedsDisplay()
    }
    
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func clearAll() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    func setPenColour(color:CGColor){
        self.lineColor = color
    }
    
    func setPenWidth(width: CGFloat){
        self.lineWidth = width
    }

}
