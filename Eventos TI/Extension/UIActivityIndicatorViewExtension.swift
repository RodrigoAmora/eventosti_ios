//
//  UIExtension.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 08/05/24.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    func configureActivityIndicatorView() {
        self.backgroundColor = .gray
        self.layer.cornerRadius = CGRectGetWidth(self.frame)/4.0
        self.color = .blue
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
}
