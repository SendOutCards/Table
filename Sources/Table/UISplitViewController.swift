//
//  UISplitViewController.swift
//  AlertBuilder
//
//  Created by Bradley Hilton on 3/14/18.
//

#if canImport(UIKit)
import UIKit

public class SplitNavigationController : UISplitViewController, UISplitViewControllerDelegate {
    
    public typealias State = (master: NavigationItem, detail: NavigationItem, showDetailWhenCompact: Bool)
    
    public var state: State {
        didSet {
            detailNavigationController.root = state.detail
            update(isCompact: traitCollection.horizontalSizeClass == .compact)
        }
    }
    public let masterNavigationController: UINavigationController
    public let detailNavigationController: UINavigationController
    
    public init() {
        state = (NavigationItem { _ in }, NavigationItem { _ in }, false)
        masterNavigationController = UINavigationController()
        detailNavigationController = UINavigationController()
        super.init(nibName: nil, bundle: nil)
        preferredDisplayMode = .allVisible
        masterNavigationController.root = state.master
        detailNavigationController.root = state.detail
        delegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [masterNavigationController, detailNavigationController]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        update(isCompact: true)
        return true
    }
    
    public func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        update(isCompact: false)
        return detailNavigationController
    }
    
    private var willPop: (() -> ())?
    
    func update(isCompact: Bool) {
        if isCompact, state.showDetailWhenCompact {
            state.detail.willPop = state.detail.willPop ?? willPop
            if !state.master.stack.contains(where: { $0 === state.detail }) {
                state.master.stack.last?.next = state.detail
            }
            masterNavigationController.root = state.master
        } else {
            if let item = state.master.stack.first(where: { $0.next === state.detail }) {
                willPop = state.detail.willPop.pop()
                item.next = nil
            }
            masterNavigationController.root = state.master
            // MARK: Performance equality check
            if viewControllers != [masterNavigationController, detailNavigationController] {
                viewControllers = [masterNavigationController, detailNavigationController]
            }
        }
    }
    
}
#endif
