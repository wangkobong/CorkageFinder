//
//  String+Extension.swift
//  Feature
//
//  Created by sungyeon on 12/23/24.
//

import UIKit

extension String {
    func toImage(withAttributes attributes: [NSAttributedString.Key: Any]? = nil) -> UIImage? {
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16)  // 크기 조절 가능
        ]
        
        // default를 current나 other 등 다른 이름으로 변경
        let mergedAttributes = (attributes ?? [:]).merging(defaultAttributes) { (current, new) in new }
        
        let size = (self as NSString).size(withAttributes: mergedAttributes)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        (self as NSString).draw(at: CGPoint.zero, withAttributes: mergedAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
