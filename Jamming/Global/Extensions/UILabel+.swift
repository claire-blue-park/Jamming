//
//  UILabel+.swift
//  Jamming
//
//  Created by Claire on 2/13/25.
//

import UIKit

extension UILabel {
    
    func calculateNumberOfLines() -> Int {
        
        self.layoutIfNeeded()
        
        guard let text = self.text as? NSString,
              let font = self.font else {
            return 0
        }
        
        print(text)
        print(font)
        
        let attributes = [NSAttributedString.Key.font: font as Any]
       
        let labelSize = text.boundingRect(
            with: CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        print(self.bounds.width)
        print(labelSize)

        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }
    
    func requiredMaxHeight(labelText: String) -> CGFloat {

        frame = CGRect(x: 0, y: 0, width: 200, height: .max)
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        font = .systemFont(ofSize: 12)
        text = labelText
        sizeToFit()
        return frame.height

    }
    
    func requiredSpecificHeight(labelText: String, lines: Int) -> CGFloat {
        frame = CGRect(x: 0, y: 0, width: 200, height: .max)
        lineBreakMode = .byWordWrapping
        numberOfLines = lines
        font = .systemFont(ofSize: 12)
        text = labelText
        sizeToFit()
        return frame.height

    }
}
