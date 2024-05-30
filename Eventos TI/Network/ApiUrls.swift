//
//  ApiUrls.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 28/05/24.
//

import Foundation

class ApiUrls {
    class func baseEventosTIAPIURL() -> String {
        #if DEBUG
            return "http://localhost:8080"
        #else
            return "http://eventosti.com.br"
        #endif
    }
}
