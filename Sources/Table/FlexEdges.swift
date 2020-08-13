//
//  FlexEdges.swift
//  Table
//
//  Created by Bradley Hilton on 2/19/18.
//  Copyright © 2018 Brad Hilton. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import CYoga

public struct FlexEdges {
    
    public var all: FlexValue?
    public var horizontal: FlexValue?
    public var vertical: FlexValue?
    public var start: FlexValue?
    public var top: FlexValue?
    public var end: FlexValue?
    public var bottom: FlexValue?
    public var left: FlexValue?
    public var right: FlexValue?
    
    public init(_ build: (inout FlexEdges) -> () = { _ in }) {
        build(&self)
    }
    
    func updateNode(
        _ node: YGNodeRef,
        setEdge: @escaping (YGNodeRef, YGEdge, Float) -> (),
        setEdgePercent: @escaping (YGNodeRef, YGEdge, Float) -> ()
    ) {
        func updateNode(with value: FlexValue?, edge: YGEdge) {
            value.map { value in
                value.updateNode(
                    node,
                    setValue: { node, value in
                        setEdge(node, edge, value)
                    }, setValuePercent: { node, percentage in
                        setEdgePercent(node, edge, percentage)
                    }
                )
            }
        }
        updateNode(with: all, edge: YGEdgeAll)
        updateNode(with: horizontal, edge: YGEdgeHorizontal)
        updateNode(with: vertical, edge: YGEdgeVertical)
        updateNode(with: start, edge: YGEdgeStart)
        updateNode(with: top, edge: YGEdgeTop)
        updateNode(with: end, edge: YGEdgeEnd)
        updateNode(with: bottom, edge: YGEdgeBottom)
        updateNode(with: left, edge: YGEdgeLeft)
        updateNode(with: right, edge: YGEdgeRight)
    }
    
}

extension FlexEdges : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    
    public init(integerLiteral value: Int) {
        self = FlexEdges { (edges: inout FlexEdges) in
            edges.all = FlexValue(integerLiteral: value)
        }
    }
    
    public init(floatLiteral value: Float) {
        self = FlexEdges { (edges: inout FlexEdges) in
            edges.all = FlexValue(floatLiteral: value)
        }
    }
    
}

public postfix func % (value: Float) -> FlexEdges {
    return FlexEdges { (edges: inout FlexEdges) in
        edges.all = FlexValue(value: value, isPercentage: true)
    }
}
#endif
