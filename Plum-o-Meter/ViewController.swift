//
//  ViewController.swift
//  Plum-o-Meter
//
//  Created by Simon Gladman on 24/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    let label = UILabel()
    
    var circles = [UITouch: CircleWithLabel]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.multipleTouchEnabled = true
        
        label.text = "lay your fruits or vegetables with soft skin on me."
        
        label.textAlignment = NSTextAlignment.Center
        
        view.addSubview(label)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        label.hidden = true
        
        for touch in touches
        {
            let circle = CircleWithLabel()
            
            circle.drawAtPoint(touch.locationInView(view),
                touch: touch)
            
            circles[touch] = circle
            view.layer.addSublayer(circle)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch in touches where circles[touch] != nil
        {
            let circle = circles[touch]!
            print(touch.force)
            circle.drawAtPoint(touch.locationInView(view),
                touch: touch)
        }

        highlightHeaviest()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch in touches where circles[touch] != nil
        {
            let circle = circles[touch]!
            
            circles.removeValueForKey(touch)
            circle.removeFromSuperlayer()
        }
        
        
        highlightHeaviest()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
    {
        guard let touches = touches else
        {
            return
        }
        
        for touch in touches where circles[touch] != nil
        {
            let circle = circles[touch]!
            
            circle.removeFromSuperlayer()

        }
    }
    
    func highlightHeaviest()
    {
        func getMaxTouch() -> UITouch?
        {
            return circles.sort({
                (a: (UITouch, CircleWithLabel), b: (UITouch, CircleWithLabel)) -> Bool in
                return a.0.force > b.0.force
            }).first?.0
        }
        
        circles.forEach
        {
            $0.1.isMax = $0.0 == getMaxTouch()
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.Landscape
    }
    
    override func viewDidLayoutSubviews()
    {
        label.frame = view.bounds
    }
}

// -------------

class CircleWithLabel: CAShapeLayer
{
    let text = CATextLayer()
    
    override init()
    {
        super.init()
        
        text.foregroundColor = UIColor.blackColor().CGColor
        text.alignmentMode = kCAAlignmentLeft
        text.fontSize = 20
        addSublayer(text)
        
        strokeColor = UIColor.blueColor().CGColor
        lineWidth = 5
        fillColor = nil
    }
    
    override init(layer: AnyObject)
    {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isMax: Bool = false
    {
        didSet
        {
            fillColor = isMax ? UIColor.yellowColor().CGColor : nil
        }
    }
    
    func drawAtPoint(location: CGPoint, touch: UITouch)
    {
        let radius = (touch.force * 75)
        
        path = UIBezierPath(
            ovalInRect: CGRect(
                origin: location.offset(dx: radius, dy: radius),
                size: CGSize(width: radius * 2, height: radius * 2))).CGPath

        text.string = String(format: "%.2f\n%.1f%%\n%.2f g", touch.force, touch.percentStrength, touch.weight)
        
        text.frame = CGRect(origin: location.offset(dx: -radius - 60, dy: radius/4 ), size: CGSize(width: 100, height: 100))
    }
}

// -------------

extension CGPoint
{
    func offset(dx dx: CGFloat, dy: CGFloat) -> CGPoint
    {
        return CGPoint(x: self.x - dx, y: self.y - dy)
    }
}
