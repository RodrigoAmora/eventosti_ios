//
//  EventoRepository.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 21/05/24.
//

import Foundation
import UIKit

class EventoRepository {
    
    // MARK: - Atributes
    private lazy var eventoService: EventoService = EventoService()
    private var resource: Resource<[Evento]?>?
    
    // MARK: - Methods
    func buscarEventos(page: Int, completion: @escaping(_ resource: Resource<[Evento]?>) -> Void) -> Resource<[Evento]?>? {
        self.resource = Resource(result: [Evento]())
        
        self.eventoService.buscarEventos(page: page, completion: { [weak self] eventos, error in
            if eventos.count == 0 {
                completion(Resource(result: nil, errorCode: error))
            } else {
                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                for evento in eventos {
                    EventoDao.saveEvento(evento)
                }
                completion(Resource(result: eventos))
            }
        })
        
        return self.resource
    }
    
}
