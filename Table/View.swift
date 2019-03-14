//
//  View.swift
//  Table
//
//  Created by Bradley Hilton on 5/10/18.
//  Copyright © 2018 Brad Hilton. All rights reserved.
//

struct UniqueDeclaration : Hashable {
    let file: String
    let line: Int
    let column: Int
}

public struct View {
    
    fileprivate let type: AnyHashable
    private let create: () -> UIView
    private let configure: (UIView) -> ()
    private let update: (UIView) -> ()
    
    public init<View : UIView>(
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        class: View.Type = View.self,
        create: @escaping () -> View = { View() },
        configure: @escaping (View) -> () = { _ in },
        update: @escaping (View) -> () = { _ in }
    ) {
        self.type = UniqueDeclaration(file: file, line: line, column: column)
        self.create = create
        self.configure = { ($0 as? View).map(configure) }
        self.update = { ($0 as? View).map(update) }
    }
    
    func view(from pool: inout [UIView], with key: AnyHashable) -> UIView {
        guard let view = pool.popFirst(where: { $0.typeAndKey == TypeAndKey(type: type, key: key) })
            else { return newView(with: key) }
        return reuse(view)
    }
    
    func view(reusing view: UIView?, with key: AnyHashable = .auto) -> UIView {
        guard let view = view,
            view.typeAndKey == TypeAndKey(type: type, key: key)
            else { return newView(with: key) }
        return reuse(view)
    }
    
    @discardableResult
    func reuse(_ view: UIView) -> UIView {
        update(view)
        return view
    }
    
    func newView(with key: AnyHashable = .auto) -> UIView {
        let view = create()
        view.type = type
        view.key = key
        UIView.performWithoutAnimation {
            configure(view)
            update(view)
        }
        return view
    }
    
}

struct AutoKeys {
    private var keys: [AnyHashable: Key] = [:]
    
    struct Key : Hashable {
        var key: Int
    }
    
    subscript(type: AnyHashable) -> Key {
        mutating get {
            defer { self[type].key += 1 }
            return keys[type, default: Key(key: 0)]
        }
        set {
            keys[type] = newValue
        }
    }
    
}

extension Array where Element == (AnyHashable, View) {
    
    func views(reusing pool: inout [TypeAndKey: UIView]) -> [UIView] {
        var autoKeys = AutoKeys()
        return map { (key, view) in
            let key = key == .auto ? autoKeys[view.type] : key
            let typeAndKey = TypeAndKey(type: view.type, key: key)
            return view.view(reusing: pool.removeValue(forKey: typeAndKey), with: key)
        }
    }
    
    func views(reusingSubviewsOf superview: UIView) -> (reusedViews: [UIView], unusedViews: [UIView]) {
        var pool = superview.subviews.indexedPool
        var lastIndexAndView: (Int, UIView)?
        return (
            map { (key, view) in
                let (index, uiview) = indexAndView(for: view, with: key, reusing: &pool)
                if let (lastIndex, lastView) = lastIndexAndView, index <= lastIndex {
                    superview.insertSubview(uiview, aboveSubview: lastView)
                    lastIndexAndView = (lastIndex, uiview)
                } else {
                    if uiview.superview != superview {
                        superview.insertSubview(uiview, at: 0)
                    }
                    lastIndexAndView = (index, uiview)
                }
                return uiview
            },
            pool.values.flatMap { $0.lazy.map { $1 } }
        )
    }
    
}

extension Array where Element : NSObject {
    
    // Returns a pool with instances grouped by type and key and sorted by indices in descending order
    var indexedPool: [TypeAndKey: [(Int, Element)]] {
        return Dictionary(
            grouping: zip(indices, self).reversed(),
            by: { $1.typeAndKey ?? TypeAndKey(type: .auto, key: .auto) }
        )
    }
    
}

func indexAndView(for view: View, with key: AnyHashable, reusing pool: inout [TypeAndKey: [(Int, UIView)]]) -> (Int, UIView) {
    guard let (index, uiview) = pool[TypeAndKey(type: view.type, key: key)]?.popLast() else { return (0, view.newView(with: key)) }
    return (index, view.reuse(uiview))
}

