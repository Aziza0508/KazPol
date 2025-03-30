//
//  UIImageView+Extensions.swift
//  PoliceApp
//
//  Created by Aziza Gilash on 30.03.2025.
//

import UIKit

extension UIImageView {
    
    func reset() {
        image = nil
    }
    
    func resetToPlaceholderImage() {
        image = .placeholder
    }
}
