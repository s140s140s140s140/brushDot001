//
//  ViewController.swift
//  brushDot001
//
//  Created by 佐藤一成 on 2019/06/08.
//  Copyright © 2019 s140. All rights reserved.
//

import UIKit
class ControlDot{
    
    var dotView:UIImageView!
    var targetPoint:CGPoint!
    var dotVelocity = CGPoint(x: 0, y: 0)
    
    
    init(rootView:UIView,dotImage:UIImage,dotTag:Int,dotNum:Int){
        let myRad:CGFloat = 2 * CGFloat.pi * CGFloat(dotTag)/CGFloat(dotNum)
        let myX = rootView.center.x + cos(myRad) * ViewController.screenRadius / 2
        let myY = rootView.center.y + sin(myRad) * ViewController.screenRadius / 2
        targetPoint = CGPoint(x: myX, y: myY)
        dotView = UIImageView(image: dotImage)
        dotView.tag = dotTag
        dotView.center = rootView.center
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.moveDot), userInfo: nil, repeats: true)
        rootView.addSubview(dotView)
    }
    @objc func moveDot(){
        let myX:CGFloat = (targetPoint.x - dotView.center.x) * 0.1
        let myY:CGFloat = (targetPoint.y - dotView.center.y) * 0.1
        dotVelocity.x += myX
        dotVelocity.y += myY
        dotVelocity.x *= 0.7
        dotVelocity.y *= 0.7
        dotView.center.x += dotVelocity.x
        dotView.center.y += dotVelocity.y
    }
}






class ViewController: UIViewController {
    
    var rootView:UIView!
    
    let dotNum = 3000
    var dotCount:Int = 0
    
    var tappedPoint:CGPoint!
    
    let backGroundColor = UIColor(red: 21/255, green: 38/255, blue: 66/255, alpha: 1.0)
    let dotColor = UIColor.white
    
    static var screenRadius:CGFloat!
    static var screenWidth:CGFloat!
    static var screenHeight:CGFloat!
    
    var myControlDots = [ControlDot]()
    var dotImage:UIImage!
    
    
    func makeDotUIImage()->UIImage{
        let size = CGSize(width: 5, height: 5)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
            let context = UIGraphicsGetCurrentContext()
            let drawRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            let drawPath = UIBezierPath(ovalIn: drawRect)
            context?.setFillColor(self.dotColor.cgColor)
            drawPath.fill()
            context?.setStrokeColor(self.backGroundColor.cgColor)
            drawPath.stroke()
            let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func setScreenLength(){
        ViewController.screenWidth = self.rootView.bounds.width
        ViewController.screenHeight = self.rootView.bounds.height
        ViewController.screenRadius = sqrt(pow(ViewController.screenWidth/2, 2) + pow(ViewController.screenHeight/2,2)) //* 2
    }
    
    func duplicateDots(){
        for itr in 0..<dotNum{
            myControlDots.append(ControlDot(rootView: self.rootView, dotImage: dotImage, dotTag: itr, dotNum: dotNum))
        }
    }
    func changeTargetPointOfDot(){

    
            myControlDots[self.dotCount].targetPoint = self.tappedPoint
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rootView = self.view
        
        self.setScreenLength()
        dotImage = makeDotUIImage()
        self.rootView.backgroundColor =  backGroundColor
        self.duplicateDots()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tappedPoint = touches.first?.location(in: view)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let myPoint = touches.first?.location(in: view)
        if myPoint != self.tappedPoint{
        self.changeTargetPointOfDot()
            dotCount += 1
            dotCount %= dotNum
            self.tappedPoint = myPoint
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

