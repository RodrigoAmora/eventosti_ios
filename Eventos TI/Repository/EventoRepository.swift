//
//  EventoRepository.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 21/05/24.
//

import Foundation
import UIKit

class EventoRepository {
    
    // MARK: - Atributos
    private lazy var eventoService: EventoService = EventoService()
    private var resource: Resource<[Evento]?>?
    
    // MARK: - Métodos
    func buscarEventos(page: Int, completion: @escaping(_ resource: Resource<[Evento]?>) -> Void) {
        self.resource = Resource(result: [Evento]())
        
        self.eventoService.buscarEventos(page: page, completion: { eventos, error in
            if eventos.count == 0 {
                completion(Resource(result: nil, errorCode: error))
            } else {
                self.apagarTodos()
                //self.salvarEventos(eventos)
                completion(Resource(result: eventos))
            }
        })
    }
    
    func buscarEventosDoBancoDeDados() -> [Evento] {
        return EventoDao.buscarEventos()
    }
    
    func salvarEventos(_ eventos: [Evento]) {
        for evento in eventos {
            EventoDao.saveEvento(evento)
        }
    }
    
    func apagarTodos() {
        EventoDao.cleanCoreData()
    }
    
}
