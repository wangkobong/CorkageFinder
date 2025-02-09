//
//  String+Extension.swift
//  Feature
//
//  Created by sungyeon on 12/23/24.
//

import UIKit
import CryptoKit

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
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
