//
//  ViewController.swift
//  FunWithPaint
//
//  Created by Avra Ghosh on 20/03/18.
//  Copyright © 2018 Avra Ghosh. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore

class ViewController: UIViewController, TWTRComposerViewControllerDelegate {

    var startPoint = CGPoint()
    var layer : CAShapeLayer?
    var selectedColor : UIColor = UIColor.white
    var selectedShape = 0
    var freeStylePath: UIBezierPath = UIBezierPath()
    var eraserColor = UIColor()
    var width : CGFloat = 5.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var img: UIView!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        // Using the stepper to change the line width
        width = CGFloat(sender.value)
        print(width)
    }
    
    @IBAction func Delete(_ sender: UIButton) {
        if (img.layer.sublayers != nil)  {
            // Throwing an Alert to check whether user wants to really delete the drawing
            let alert = UIAlertController(title: "Clear Image", message: "Are you sure you want to clear the Image?", preferredStyle: .alert)
            let clearAction = UIAlertAction(title: "Clear", style: .destructive) { (alert: UIAlertAction!) -> Void in
                self.ImageClear()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
                print("You Pressed Cancel")
            }
            alert.addAction(clearAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    func ImageClear()
    {
        // Function for deleting the entire drawing
        for layer in img.layer.sublayers!
             {
                if (layer.isKind(of: CAShapeLayer.self))
                   {
                       layer.removeFromSuperlayer()
                   }
             }
    }
    
    
    @IBAction func saveImage(_ sender: Any) {
        if (img.layer.sublayers == nil)  {
            // Throwing an Alert if User wants to Save Image without any drawing
            let alert = UIAlertController(title: "Save Image", message: "Please draw something", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                print("You Pressed Ok")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:nil)
        }
        else  {
            // Saving the Image in photos Album
            UIGraphicsBeginImageContext(img.frame.size)
            img.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let save = UIActivityViewController(activityItems: [image!],applicationActivities: nil)
            present(save, animated: true, completion: nil)
        }
    }
    
    @IBAction func Share(_ sender: UIButton) {
        // Sharing the drawing on Twitter
        UIGraphicsBeginImageContext(img.frame.size)
        img.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            let composer = TWTRComposerViewController(initialText: "My drawing on FunWithPaint", image: image, videoData: nil)
            composer.delegate = self
            self.present(composer, animated: true, completion: nil)
        } else {
            TWTRTwitter.sharedInstance().logIn {session, error in
                if session == nil {
                    //self.showAlert(title: "Error", message: "Please login before sharing.")
                } else {
                    let composer = TWTRComposerViewController(initialText: "My drawing on FunWithPaint", image: image, videoData: nil)
                    composer.delegate = self
                    self.present(composer, animated: true, completion: nil)
                }
            }
        }
    }
    
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
    }
    
    func composerDidCancel(_ controller: TWTRComposerViewController) {
    }
    
    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
    }
    
    @IBAction func ShapeSelect(_ sender: UIButton) {
        // Function for selecting the shapes, free style drawing and eraser options
        let button = sender as UIButton
        selectedShape = button.tag
    }
    
    @IBAction func ColorSlect(_ sender: UIButton) {
        // Function for selecting the color to be used in drawing
        let button = sender as UIButton
        selectedColor = button.backgroundColor!
    }
    
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began
        {
            startPoint = sender.location(in: sender.view)
            layer = CAShapeLayer()
            freeStylePath = UIBezierPath()
            layer?.fillColor = selectedColor.cgColor
            layer?.opacity = 0.2
            layer?.strokeColor = UIColor.black.cgColor
            layer?.lineWidth = width
            img.layer.addSublayer(layer!)
        }
        else if sender.state == .changed
        {
            let translation = sender.translation(in: sender.view)
            let currentPoint = sender.location(in: sender.view)
            switch selectedShape
            {
            case 1:
                // Drawing Eclipse
                layer?.path = (UIBezierPath(ovalIn:CGRect(x:startPoint.x,
                                                              y: startPoint.y,
                                                              width: translation.x,
                                                              height: translation.y))).cgPath
            case 2:
                // Drawing Rectangle
                layer?.path = (UIBezierPath(rect: CGRect(x:startPoint.x,
                                                         y:startPoint.y,
                                                         width:translation.x,
                                                         height:translation.y))).cgPath
            
            case 3:
                // Drawing Rounded Rectangle
                layer?.path = (UIBezierPath)(roundedRect:CGRect(x:startPoint.x,
                                                                y:startPoint.y,
                                                                width:translation.x,
                                                                height:translation.y), cornerRadius: 10).cgPath
            case 4:
                // Drawing Straight Line
                layer?.strokeColor = selectedColor.cgColor
                let linespath = UIBezierPath()
                linespath.move(to: startPoint)
                linespath.addLine(to: currentPoint)
                linespath.close()
                layer?.path = linespath.cgPath
                
            case 5:
                // Drawing Circle
                layer?.path = (UIBezierPath(ovalIn:CGRect(x:startPoint.x,
                                                          y:startPoint.y,
                                                          width: currentPoint.x - startPoint.x,
                                                          height: currentPoint.x - startPoint.x))).cgPath
            
            case 6:
                // Drawing Square
                layer?.path = (UIBezierPath(rect:CGRect(x:startPoint.x,
                                                          y:startPoint.y,
                                                          width: translation.x,
                                                          height: translation.x))).cgPath
            
            case 7:
                // Free Style Drawing
                layer?.strokeColor = selectedColor.cgColor
                layer?.lineWidth = width
                freeStylePath.move(to: startPoint)
                freeStylePath.addLine(to: currentPoint)
                layer?.path = freeStylePath.cgPath
                startPoint = currentPoint
                
            case 8:
                // Eraser
                eraserColor = img.backgroundColor!
                layer?.strokeColor = eraserColor.cgColor
                layer?.lineWidth = 7
                layer?.opacity = 1.0
                freeStylePath.move(to: startPoint)
                freeStylePath.addLine(to: currentPoint)
                layer?.path = freeStylePath.cgPath
                startPoint = currentPoint
            default:
                // Default drawing is Free Style Drawing
                layer?.strokeColor = selectedColor.cgColor
                layer?.lineWidth = width
                freeStylePath.move(to: startPoint)
                freeStylePath.addLine(to: currentPoint)
                layer?.path = freeStylePath.cgPath
                startPoint = currentPoint
            }
        }
        
    }
    
}

