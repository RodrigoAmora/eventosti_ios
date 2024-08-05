//
//  UIViewExtension.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 04/08/24.
//

import Foundation
import UIKit

extension UIView {
    
    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
    
}
