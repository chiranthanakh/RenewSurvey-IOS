//
//  SideAnimatable.swift
//  RecordingStudio
//
//  Created by KETAN SODVADIYA on 02/01/19.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit

protocol SideAnimatable {
    func push<ViewControllerType>(_ viewController: ViewControllerType,
                                  with animation: SideAnimationType,
                                  duration: CFTimeInterval)
        where ViewControllerType: UIViewController
    
    func pop(with animation: SideAnimationType,
             duration: CFTimeInterval)
    
    func setViewControllers(_ viewControllers: [UIViewController],
                            with animation: SideAnimationType,
                            duration: CFTimeInterval)
    
    func setViewController<ViewControllerType>(_ viewController: ViewControllerType,
                                               with animation: SideAnimationType,
                                               duration: CFTimeInterval,
                                               completion: ((ViewControllerType) -> Void)?)
        where ViewControllerType: UIViewController
}

enum SideAnimationType {
    case fromRight,
    fromLeft,
    fromTop,
    fromBottom
    
    var description: String {
        switch self {
        case .fromRight:
            return CATransitionSubtype.fromRight.rawValue
            
        case .fromLeft:
            return CATransitionSubtype.fromLeft.rawValue
            
        case .fromTop:
            return CATransitionSubtype.fromTop.rawValue
            
        case .fromBottom:
            return CATransitionSubtype.fromBottom.rawValue
        }
    }
}


enum OrderType {
    case Delivery
    case DineIn
    case PickUp
    case OrderStatus
    case OrderHistory
    
    var name: String {
        switch self {
        case .Delivery:
            return "Delivery"
            
        case .DineIn:
            return "Dine In"
            
        case .PickUp:
            return "Pick Up"
            
        case .OrderStatus:
            return "Order Status"
            
        case .OrderHistory:
            return "Order History"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Delivery:
            return #imageLiteral(resourceName: "ic_delivery")
            
        case .DineIn:
            return #imageLiteral(resourceName: "ic_dinein")
            
        case .PickUp:
            return #imageLiteral(resourceName: "ic_pickup")
            
        case .OrderStatus:
            return #imageLiteral(resourceName: "ic_order_status")
            
        case .OrderHistory:
            return #imageLiteral(resourceName: "ic_order_history")
        }
    }
}
// MARK: - Default implementation & UINavigationController
extension SideAnimatable where Self: UINavigationController {
    func push<ViewControllerType>(_ viewController: ViewControllerType,
                                  with animation: SideAnimationType,
                                  duration: CFTimeInterval = 0.3)
        where ViewControllerType: UIViewController {
            addCustomAnimation(to: view, with: animation, duration: duration)
            pushViewController(viewController, animated: false)
    }
    
    func pop(with animation: SideAnimationType,
             duration: CFTimeInterval = 0.3) {
        addCustomAnimation(to: view, with: animation, duration: duration)
        _ = popViewController(animated: false)
    }
    
    func setViewControllers(_ viewControllers: [UIViewController],
                            with animation: SideAnimationType,
                            duration: CFTimeInterval = 0.3) {
        addCustomAnimation(to: view, with: animation, duration: duration)
        setViewControllers(viewControllers, animated: false)
    }
    
    func setViewController<ViewControllerType>(_ viewController: ViewControllerType,
                                               with animation: SideAnimationType,
                                               duration: CFTimeInterval = 0.3,
                                               completion: ((ViewControllerType) -> Void)? = nil)
        where ViewControllerType: UIViewController {
            CATransaction.begin()
            
            CATransaction.setCompletionBlock {
                completion?(viewController)
            }
            
            setViewControllers([viewController], with: animation, duration: duration)
            
            CATransaction.commit()
    }
    
    fileprivate func addCustomAnimation(to view: UIView,
                                        using timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
                                        with animation: SideAnimationType,
                                        duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = timingFunction
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype(rawValue: animation.description)
        
        view.layer.add(transition, forKey: nil)
    }
}

