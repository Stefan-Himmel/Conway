//
//  GridView.swift
//  Assignment3
//
//  Created by Stefan Himmel on 7/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

@IBDesignable
class GridView: UIView {

    var currentGrid : GridProtocol = StandardEngine.singleton.grid {didSet {setNeedsDisplay()}
    }
    
    @IBInspectable var livingColor: UIColor = UIColor.black
    @IBInspectable var emptyColor: UIColor = UIColor.white
    @IBInspectable var bornColor: UIColor = UIColor.green
    @IBInspectable var diedColor: UIColor = UIColor.red
    @IBInspectable var gridColor: UIColor = UIColor.black
    @IBInspectable var gridWidth: CGFloat = 1
    
    var delegate: UIViewController?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else {
            return
        }

        let heightOfCell = self.bounds.size.height/CGFloat(StandardEngine.singleton.cols)
        let widthOfCell = self.bounds.size.width/CGFloat(StandardEngine.singleton.rows)
        
        // compute cell being clicked in
        let clickRow : Int = Int(floor(touchPoint.x / widthOfCell))
        let clickCol : Int = Int(floor(touchPoint.y / heightOfCell))
        
        // toggle clicked cell
        let oldState = currentGrid[clickRow,clickCol]
        let newState = oldState.toggle(value: oldState)
        currentGrid[clickRow, clickCol] = newState
        
        
        if let delegate = delegate as? SimulationViewController{
            delegate.toggleModel(row: clickRow, col: clickCol)
        }
        
        //redraw
        setNeedsDisplay()
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let heightOfCell = self.bounds.size.height/CGFloat(StandardEngine.singleton.cols)
        let widthOfCell = self.bounds.size.width/CGFloat(StandardEngine.singleton.rows)
        
        
        for i in 0 ... StandardEngine.singleton.rows{
            for j in 0 ... StandardEngine.singleton.cols{
                
                var cellColor: UIColor {
                switch currentGrid[i,j] {
                case .alive: return livingColor
                case .born: return bornColor
                case .died: return diedColor
                default: return emptyColor
                }
                }
                
                drawSquare((x: widthOfCell * CGFloat(i), y: heightOfCell * CGFloat(j)),
                           squareWidth: widthOfCell,
                           squareHeight: heightOfCell,
                           rect: rect)
                
                var myRadius = widthOfCell/2
                
                if widthOfCell > heightOfCell {
                    myRadius = heightOfCell/2
                }
                
                drawCircle(midPoint: CGPoint(x: (widthOfCell * CGFloat(i)) + widthOfCell/2,
                                             y: heightOfCell * CGFloat(j) + heightOfCell/2),
                           radius: myRadius,
                           color: cellColor)
            }
        }
    }
    
    
    func drawSquare(_ origin: (x: CGFloat, y: CGFloat), squareWidth: CGFloat, squareHeight: CGFloat, rect: CGRect) {
        
        //set the color
        let edgeColor = gridColor
         
        // Define the edge path
        let edgePath = UIBezierPath()
         
        // Define how the edges will be drawn
        edgePath.lineWidth = gridWidth
        // Draw the lines for the outline/edges
        edgePath.move(to: CGPoint(x: rect.origin.x + origin.x,
                                  y: rect.origin.y + origin.y))
        edgePath.addLine(to: CGPoint(x: rect.origin.x + origin.x,
                                     y: rect.origin.y + squareHeight))
        edgePath.addLine(to: CGPoint(x: rect.origin.x + squareWidth,
                                     y: rect.origin.y + squareHeight))
        edgePath.addLine(to: CGPoint(x: rect.origin.x + squareWidth,
                                     y: rect.origin.y + origin.y))
        edgePath.addLine(to: CGPoint(x: rect.origin.x + origin.x,
                                     y: rect.origin.y + origin.y))
        // Define the color
        edgeColor.setStroke()
        // Draw them
        edgePath.stroke()
        
    }
    
    func drawCircle(midPoint: CGPoint,
                        radius: CGFloat,
                        color: UIColor) {
        // Define our circular path for a quarter of the screen
        // Define the parts of the circle that we're drawing
        let circlePath = UIBezierPath(arcCenter: midPoint,
                                      radius: radius * (4/5),
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(Double.pi * 2),
                                      clockwise: true)
        
        // Define the line color
        color.setStroke()
        circlePath.stroke()
        // Define the fill color
        color.withAlphaComponent(0.4).setFill()
        circlePath.fill()
    }
    
    func setupListener() {
        let notificationSelector = #selector(actOnNotification(notification:))
        NotificationCenter.default.addObserver(self, selector: notificationSelector, name: NSNotification.Name(rawValue: "newGrid"), object: nil)
    }
    
    
    func actOnNotification(notification: Notification) {
        guard let newGrid = notification.userInfo?["infoGrid"] as? GridProtocol else {
            return
        }
        
        currentGrid = newGrid
        setNeedsDisplay()
    }
    
}
