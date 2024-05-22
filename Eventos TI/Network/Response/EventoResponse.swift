//
//  EventoResponse.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 21/05/24.
//

import Foundation

class EventoResponse: Decodable {
    
    // MARK: - Atributes
    var eventos: [Evento]?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case eventos = "content"
    }
    
}
