//
//  ContainerViewController.swift
//  Table
//
//  Created by Bradley Hilton on 4/23/18.
//  Copyright © 2018 Brad Hilton. All rights reserved.
//

func ContainerController(childController: Controller) -> Controller {
    return Controller(
        updateController: { (controller: ContainerViewController) in
            controller.setChildController(childController)
        }
    )
}

class ContainerViewController : UIViewController {
    
    func setChildController(_ controller: Controller) {
        if let viewController = childViewControllers.last {
            if viewController.type == controller.type {
                viewController.update(with: controller)
            } else {
                let newViewController = controller.newViewController()
                addChildViewController(newViewController)
                addChildView(newViewController.view)
                if viewIsVisible {
                    transition(
                        from: viewController,
                        to: newViewController,
                        duration: UIView.inheritedAnimationDuration,
                        options: [.transitionCrossDissolve],
                        animations: {},
                        completion: { _ in
                            viewController.removeFromParentViewController()
                            newViewController.didMove(toParentViewController: self)
                        }
                    )
                } else {
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParentViewController()
                    newViewController.didMove(toParentViewController: self)
                }
            }
        } else {
            let newViewController = controller.newViewController()
            addChildViewController(newViewController)
            addChildView(newViewController.view)
            newViewController.didMove(toParentViewController: self)
        }
    }
    
    func addChildView(_ childView: UIView) {
        UIView.performWithoutAnimation {
            view.addSubview(childView)
            childView.translatesAutoresizingMaskIntoConstraints = false
            childView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            childView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            childView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
}
