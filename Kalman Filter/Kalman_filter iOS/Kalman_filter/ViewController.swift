//
//  ViewController.swift
//  Kalman_filter
//
//  Created by mac-p on 4/10/16.
//  Copyright © 2016 Tufts University. All rights reserved.
//

import UIKit
//import ABMatrix.swift
import CoreGraphics
//UIBezierPath *myPath=[[UIBezierPath, alloc],init];
//myPath.lineWidth=10;
//brushPattern=[UIColor redColor]; //This is the color of my stroke




class ViewController: UIViewController {
    @IBOutlet weak var Press_button: UILabel!
    
    let dataMatrix = ABMatrix(row: 5, col:5)
    
    
    func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        UIColor.blueColor().setFill()
        path.fill()
    }
    
    @IBAction func Trigger_draw(sender: UIButton) {
//        Press_button.frame = CGRectMake(20, 20, 200.0, 200.0)
//        drawRect(Press_button.frame)
        
        Press_button.text = "Start Drawing the projectile graph for kalman filter simulation"
        dataMatrix.Print()
        dataMatrix.MakeOne()
        dataMatrix.Print()
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

