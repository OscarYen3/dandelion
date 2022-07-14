//
//  SlideInTransition.swift
//  DandelionExpenses
//
//  Created by Oscar Yen on 2022/7/14.
//

import Foundation
import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewCOntroller = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from)
              else { return }
        
        let containerView = transitionContext .containerView
        let finalWidth = toViewCOntroller.view.bounds.width
        let finalHeight = toViewCOntroller.view.bounds.height
        
        if isPresenting {
            containerView.addSubview(toViewCOntroller.view)
            toViewCOntroller.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        
        let transform = {
            toViewCOntroller.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        let identity = {
            fromViewController.view.transform = .identity
        }
        
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration) {
                self.isPresenting ? transform() : identity()
        } completion: { (_ ) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
        
}
