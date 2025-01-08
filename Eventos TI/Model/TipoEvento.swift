//
//  TipoEvento.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 08/01/25.
//

enum TipoEvento: String, Decodable {
    case ON_LINE, PRESENCIAL, HIBRIDO
}

func getTipoEvento(_ tipoEvento: TipoEvento) -> String {
    switch tipoEvento {
        case .ON_LINE:
            return "ON_LINE"
        case .PRESENCIAL:
            return "PRESENCIAL"
        case .HIBRIDO:
            return "HIBRIDO"
    }
}
