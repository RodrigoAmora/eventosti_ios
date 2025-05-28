//
//  UISearchBarExtension.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 15/08/24.
//

import Foundation
import UIKit

extension UISearchBar {
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
    
    func posY() {
        let searchBarPosY: CGFloat = switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                75
            
            case .phone:
                95
            
            default:
                85
        }
        
        self.frame.origin.y = searchBarPosY
    }
}
