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
        self.color = .green
        self.layer.cornerRadius = CGRectGetWidth(self.frame)/4.0
    }
    
    func hide() {
        self.isHidden = true
        self.stopAnimating()
    }
    
    func show() {
        self.isHidden = false
        self.startAnimating()
    }
}
