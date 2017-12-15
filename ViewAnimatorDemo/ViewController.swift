//
//  ViewController.swift
//  ViewAnimatorDemo
//
//  Created by Ritu on 09/12/17.
//  Copyright © 2017 Bingo. All rights reserved.
//

import UIKit

enum AnimationState {

    case fullScreen
    case thumbNail

}


class ViewController: UIViewController {

    @IBOutlet weak var panningView: UIView!
    @IBOutlet weak var darkView: UIView!
    
    var propertyAnimator : UIViewPropertyAnimator!
    var thumbNailFrame : CGRect!
    var currentState : AnimationState!
    var panGesture : UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbNailFrame = panningView.frame
        currentState = AnimationState.thumbNail
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        panningView.addGestureRecognizer(panGesture)
    
    }
    
    func panGestureAction(_ gesture: UIPanGestureRecognizer){
       
        let translation = gesture.translation(in: self.view.superview)
        
        switch gesture.state {
        case .began:
            startPanning()
            print("panning started")
            break
        case .changed:
            scrubEffect(translation)
            print("panning changed")
            break
        case .ended:
            print("panning ended")
            break
        case .cancelled:
            print("panning cancelled")
            break;
        case .failed:
            print("panning failed")
            break
        case .possible:
            print("panning possible")
            break
        }
    }
    
    
    func startPanning(){
        var finalFrame : CGRect
        var alphaVal : CGFloat
        if currentState == AnimationState.thumbNail {
            finalFrame = thumbNailFrame
            alphaVal = 0
        }
        else{
            finalFrame = view.frame
            alphaVal = 1
        }
        
        propertyAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.8, animations: { 
            self.panningView.frame = finalFrame
            self.darkView.alpha = alphaVal
        })
        
    }
    
    func scrubEffect(_ translation : CGPoint){
        
        if let animator = propertyAnimator {
            let yTranslation = self.view.center.y + translation.y
            var progress : CGFloat
            if currentState == AnimationState.thumbNail {
                progress = 1 - (yTranslation / self.view.center.y)
            }
            else{
                progress = (yTranslation / self.view.center.y) - 1
            }
            print(translation)
            print(progress)
            
            progress = max(0.0001, min(0.9999, progress))
            
            animator.fractionComplete = progress
        }
        
    }
}

