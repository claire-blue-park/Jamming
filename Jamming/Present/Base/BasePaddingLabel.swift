//
//  BasePaddingLabel.swift
//  Jamming
//
//  Created by Claire on 1/29/25.
//

import UIKit

class BasePaddingLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 2.0, left: 4.0, bottom: 2.0, right: 4.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
