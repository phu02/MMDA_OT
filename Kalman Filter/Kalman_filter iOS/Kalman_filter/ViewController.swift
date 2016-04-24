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
    
    var dataMatrix = ABMatrix(matrix:[0.60, 0.73, 0.15,
        0.60, 0.73, 0.16,
        0.59, 0.74, 0.15,
        0.59, 0.73, 0.15,
        0.60, 0.74, 0.14,
        0.60, 0.73, 0.16,
        0.59, 0.73, 0.15,
        0.60, 0.73, 0.15,
        0.59, 0.73, 0.16,
        0.60, 0.74, 0.15,
        0.60, 0.73, 0.16,
        0.60, 0.73, 0.15,
        0.59, 0.73, 0.15,
        0.60, 0.74, 0.15,
        0.59, 0.74, 0.15,
        0.60, 0.73, 0.16,
        0.59, 0.73, 0.15,
        0.60, 0.73, 0.15,
        0.59, 0.74, 0.15,
        0.60, 0.73, 0.16,
        0.60, 0.73, 0.15,
        0.59, 0.74, 0.15,
        0.60, 0.73, 0.16,
        0.59, 0.74, 0.15,
        0.60, 0.74, 0.15,
        0.59, 0.73, 0.15,
        0.60, 0.74, 0.16,
        0.60, 0.74, 0.16,
        0.60, 0.73, 0.15,
        0.60, 0.73, 0.15,
        0.59, 0.74, 0.15,
        0.60, 0.73, 0.16,
        0.59, 0.74, 0.15,
        0.60, 0.73, 0.16,
        0.59, 0.73, 0.15,
        0.60, 0.73, 0.16,
        0.59, 0.73, 0.16,
        0.59, 0.73, 0.15,
        0.59, 0.73, 0.15,
        0.59, 0.74, 0.15,
        0.59, 0.74, 0.16,
        0.59, 0.73, 0.16,
        0.59, 0.73, 0.16,
        0.59, 0.73, 0.15,
        0.56, 0.91, 0.07,
        0.50, 0.79, 0.12,
        0.68, 0.79, 0.10,
        0.33, 0.91, 0.09,
        0.16, 0.96, 0.06,
        0.53, 0.89, -0.02,
        0.34, 0.70, -0.01,
        0.25, 0.89, -0.16,
        0.27, 0.91, -0.16,
        0.40, 1.03, -0.13,
        0.36, 0.90, -0.20,
        0.46, 0.76, -0.14,
        0.37, 0.84, -0.30,
        0.50, 0.90, -0.32,
        0.41, 0.68, -0.20,
        0.38, 1.08, -0.30,
        0.30, 0.85, -0.13,
        0.71, 0.75, -0.08,
        1.31, -0.21, -0.19,
        0.27, 0.82, -0.07,
        0.27, 0.82, -0.23,
        0.60, 0.11, -0.41,
        0.25, -0.17, -1.00,
        -0.79, 0.08, -0.66,
        0.32, -0.18, -0.93,
        0.96, -0.79, -0.87,
        -0.32, -0.43, -0.94,
        0.25, 0.17, -1.01,
        0.53, 0.21, -1.14,
        -0.20, 0.24, -0.93,
        -0.29, 0.09, -0.84,
        -0.29, 0.33, -0.87,
        0.26, -0.03, -0.88,
        -0.30, 0.26, -0.88,
        -0.00, 0.18, -0.87,
        0.04, -0.19, -0.85,
        -0.15, -0.14, -0.85,
        -0.19, -0.11, -0.80,
        -0.06, 0.13, -0.92,
        0.06, 0.25, -0.92,
        0.05, 0.01, -0.89,
        0.02, 0.00, -0.85,
        0.36, 0.05, -0.92,
        0.33, -0.15, -0.81,
        0.36, -0.14, -0.88,
        0.14, 0.23, -0.95,
        0.23, 0.12, -0.88,
        0.35, 0.02, -0.88,
        0.30, 0.01, -0.91,
        0.25, 0.05, -0.93,
        -0.17, -1.67, -1.01,
        -0.10, 0.17, -0.90,
        -0.06, 0.25, -0.88,
        -0.06, 0.23, -0.88,
        0.21, 0.23, -0.93,
        0.00, 0.31, -0.78,
        0.37, 0.42, -0.85,
        0.38, 0.10, -0.81,
        1.08, -0.45, -0.79,
        0.54, 0.41, -0.72,
        0.53, 0.34, -0.62,
        1.13, -0.02, -0.87,
        0.91, -0.05, -0.72,
        -0.07, -0.03, -1.01,
        -0.23, 0.36, -0.78,
        -0.58, 0.20, -0.66,
        -0.88, 0.20, -0.61,
        -1.31, 0.39, -0.21,
        -0.72, 0.23, -0.07,
        -0.91, 0.33, 0.04,
        -0.31, 0.05, -0.68,
        -0.02, -0.14, -0.87,
        -0.27, 0.05, -0.96,
        0.03, -0.06, -0.97,
        0.09, -0.04, -0.89,
        0.08, -0.02, -0.94,
        -0.03, -0.04, -0.90,
        0.01, -0.06, -0.90,
        0.06, -0.03, -0.93,
        -0.06, 0.03, -0.92,
        0.00, -0.02, -0.90,
        -0.00, 0.08, -0.87,
        -0.04, 0.08, -0.98,
        0.04, 0.03, -0.87,
        0.02, 0.05, -0.85,
        0.14, 0.18, -0.92,
        0.19, -0.15, -0.96,
        0.17, 0.27, -0.79,
        0.31, -0.03, -0.68,
        0.06, -0.17, -1.00,
        -0.06, -0.12, -0.94,
        0.00, 0.02, -0.94,
        0.12, -0.02, -1.05,
        0.05, 0.11, -1.08,
        0.01, -0.30, -0.99,
        -0.19, 0.02, -0.96,
        -0.20, -0.04, -0.89,
        -0.08, -0.00, -0.90,
        -0.02, -0.00, -0.91,
        -0.02, -0.03, -0.92,
        0.03, -0.02, -0.92,
        0.04, -0.02, -0.92,
        0.02, -0.02, -0.91, 
        0.06, -0.02, -0.90, 
        0.03, -0.01, -0.92, 
        0.01, -0.02, -0.92, 
        0.02, -0.02, -0.92, 
        0.01, -0.02, -0.92, 
        0.04, -0.02, -0.91, 
        0.00, -0.03, -0.92, 
        0.03, -0.02, -0.91, 
        0.06, -0.01, -0.91, 
        0.08, -0.01, -0.91, 
        0.06, -0.02, -0.91, 
        0.05, -0.02, -0.91, 
        0.04, -0.03, -0.93, 
        0.06, -0.01, -0.91, 
        0.07, -0.02, -0.91, 
        0.06, -0.02, -0.91, 
        0.08, -0.02, -0.91, 
        0.05, -0.02, -0.92, 
        0.08, -0.01, -0.91, 
        0.06, -0.02, -0.92, 
        0.08, -0.02, -0.91, 
        0.08, -0.02, -0.92, 
        0.09, -0.02, -0.91, 
        0.08, -0.02, -0.92, 
        0.10, -0.02, -0.90, 
        0.09, -0.02, -0.91, 
        0.08, -0.01, -0.92, 
        0.09, -0.03, -0.91, 
        0.10, -0.02, -0.91, 
        0.09, -0.02, -0.91, 
        0.11, -0.02, -0.91, 
        0.10, -0.03, -0.91, 
        0.10, -0.03, -0.92, 
        0.09, -0.02, -0.91, 
        0.09, -0.02, -0.91, 
        0.09, -0.02, -0.91, 
        0.09, -0.03, -0.92, 
        0.09, -0.03, -0.92, 
        0.09, -0.02, -0.91, 
        0.10, -0.02, -0.90, 
        0.08, -0.03, -0.91, 
        0.08, -0.03, -0.92, 
        0.07, -0.02, -0.92, 
        0.12, -0.03, -0.91, 
        0.08, -0.02, -0.92, 
        0.15, -0.09, -0.90, 
        0.14, -0.02, -0.90, 
        0.12, -0.03, -0.91, 
        0.15, -0.03, -0.90, 
        0.15, -0.03, -0.91, 
        0.17, -0.03, -0.90, 
        0.15, -0.02, -0.91, 
        0.17, -0.02, -0.90, 
        0.17, -0.03, -0.90],row: 201, col:3)
    
    var counter = 0
    
    let x_axis = 0;
    let y_axis = 1;
    let z_axis = 2;
    
    //matrix multiplication constants
    let dt = 0.1
    var matrix_A = ABMatrix(matrix:[0,0,0,0,0,0,0,0,0], row:3, col:3)
    var newMatrix = ABMatrix(matrix:[0,0,0], row:3, col:1)

    
    //P is our initial guess for the covariance of our state
    var Pn = ABMatrix(matrix:[1,0,0,0,1,0,0,0,1], row:3, col:3)
    var P_pred = ABMatrix(matrix:[1,0,0,0,1,0,0,0,1], row:3, col:3)

    //H = Observation matrix. Multiply a state vector by H to translate it to a measurement vector.
    let matrix_H = ABMatrix(matrix:[1,0,0,0,1,0,0,0,1], row:3, col:3)
 
    var matrix_S = ABMatrix(matrix:[1,0,0,0,1,0,0,0,1], row:3, col:3)

    //Q is our estimate of the process error. Since we created the process (the simulation) and mapped our equations directly from it, we can safely assume there is no process error:
    var matrix_Q = ABMatrix(matrix:[0,0,0,0,0,0,0,0,0], row:3, col:3)
    
    //R is our estimate of the measurement error covariance. We'll just set them all arbitrarily to 0.2. Try playing with this value in the real code.
    var matrix_R = ABMatrix(matrix:[0.2,0,0,0,0.2,0,0,0,0.2], row:3, col:3)
    
    var kalmanGain = ABMatrix(matrix:[0,0,0,0,0,0,0,0,0], row:3, col:3)
    //initial state
    
    var xn = ABMatrix(matrix:[0,0,0], row:3, col:1)
//    var xn_prev = ABMatrix(matrix:[0,0,0], row:3, col:1)
    var x_pred = ABMatrix(matrix:[0,0,0], row:3, col:1)
    var Zn = ABMatrix(matrix:[0,0,0], row:3, col:1)
    var y_tilda = ABMatrix(matrix:[0,0,0], row:3, col:1)
    var identityMatrix3 = ABMatrix(matrix:[1,0,0,0,1,0,0,0,1], row:3, col:3)
//    var flag = 0
    
    
    @IBAction func TestButton(sender: UIButton) {
//        xn = ABMatrix(matrix:[0,0,0], row:3, col:1)
        matrix_A = ABMatrix(matrix:[1,dt,0.5*dt*dt,0,1,dt, 0,0,1], row:3, col:3)
//        x_pred = ABMatrix(matrix:[1,1,1], row:3, col:1)
//        xn = matrix_A.Multiply(x_pred)
        
        matrix_Q = ABMatrix(matrix:[1,1,0,1,1,0,1,1,0], row:3, col:3)
        

        print("\n printing transposed A + Q")
        matrix_A.Transpose().Subtract(matrix_Q).Print()
        

    }
    @IBAction func Trigger_draw(sender: UIButton) {

        if (counter == 0) {
            newMatrix = dataMatrix.Transpose()
            matrix_A = ABMatrix(matrix:[1,dt,0.5*dt*dt,0,1,dt, 0,0,1], row:3, col:3)
//            counter = counter+1
        }

        counter = counter+1
        print("\n counter is ",counter)
        
        //measuring the x_axis acceleration
        Zn.M[0] = 0
        Zn.M[1] = 0
        Zn.M[2] = newMatrix.CopyCol(counter).M[0]    //measurement vector
        print("\n Zn is")
        Zn.Print()
        
        //REMEMBER TO EXTRACT THE AXIS FROM ZN TO APPLY INTO THE EQUATION, ONLY Y-AXIS IS NEEDED HERE.

        x_pred = matrix_A.Multiply(xn)
        print("\n x_pred is")
        x_pred.Print()
        P_pred = matrix_A.Multiply(Pn).Multiply(matrix_A.Transpose()).Add(matrix_Q)
        print("\n P_pred is")
        P_pred.Print()
        y_tilda = Zn.Subtract( matrix_H.Multiply(x_pred))
        print("\n y_tilda is")
        y_tilda.Print()
        matrix_S = matrix_H.Multiply(P_pred).Multiply(matrix_H.Transpose()).Add(matrix_R)
        print("\n matrix_S is")
        matrix_S.Print()
        kalmanGain = P_pred.Multiply(matrix_H.Transpose()).Multiply(matrix_S.Inverse())
        print("\n kalmanGain is")
        kalmanGain.Print()
        xn = x_pred.Add(kalmanGain.Multiply(y_tilda))
        print("\n xn is")
        xn.Print()
        Pn = (identityMatrix3.Subtract(kalmanGain.Multiply(matrix_H))).Multiply(P_pred)
        print("\n Pn is")
        Pn.Print()
        
        Press_button.text = "Start Drawing the projectile graph for kalman filter simulation"
        
        
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

