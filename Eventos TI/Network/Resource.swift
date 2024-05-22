//
//  Resource.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 21/05/24.
//

import Foundation

class Resource<T> {
    
    var result: T?
    var errorCode: Int? = nil
    
    init(result: T? = [], errorCode: Int? = nil) {
        self.result = result
        self.errorCode = errorCode
    }
   
}
