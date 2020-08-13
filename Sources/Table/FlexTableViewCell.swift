//
//  FlexTableViewCell.swift
//  Table
//
//  Created by Bradley Hilton on 2/14/18.
//  Copyright © 2018 Brad Hilton. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public class FlexTableViewCell : UITableViewCell {
    
    public var child: Flex {
        get {
            return flexView.child
        }
        set {
            flexView.child = newValue
        }
    }
    
    private let flexView = FlexView()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(flexView)
        flexView.translatesAutoresizingMaskIntoConstraints = false
        flexView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        flexView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1).isActive = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
#endif
