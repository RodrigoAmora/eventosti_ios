//
//  EventoViewModel.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 21/05/24.
//

import Foundation

class EventoViewModel {
    
    private lazy var repository: EventoRepository = EventoRepository()
    private var eventoDelegate: EventoDelegate
    
    // MARK: - init
    init(eventoDelegate: EventoDelegate) {
        self.eventoDelegate = eventoDelegate
    }
    
    // MARK: - Methods
    func buscarEventos(page: Int) {
        self.repository.buscarEventos(page: page, completion: { [weak self] resource in
            guard let eventos: [Evento] = resource.result ?? [] else { return }

            if eventos.count == 0 {
                self?.eventoDelegate.showError(resource.errorCode ?? 0)
            } else {
                
                self?.eventoDelegate.populateTableView(eventos: eventos)
            }
        })
    }
}
