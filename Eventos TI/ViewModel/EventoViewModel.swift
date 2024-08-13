//
//  EventoViewModel.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 21/05/24.
//

import Foundation
import Network

class EventoViewModel {
    
    // MARK: - Atributos
    private lazy var eventoRepository: EventoRepository = EventoRepository()
    private var eventoDelegate: EventoDelegate
    
    // MARK: - init
    init(eventoDelegate: EventoDelegate) {
        self.eventoDelegate = eventoDelegate
    }
    
    // MARK: - Métodos
    func buscarEventos(page: Int) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.eventoRepository.buscarEventos(page: page, completion: { resource in
                    guard let eventos: [Evento] = resource.result ?? [] else { return }
                    
                    if eventos.count == 0 {
                        self.eventoDelegate.showError(resource.errorCode ?? 0)
                    } else {
                        self.eventoDelegate.populateTableView(eventos: eventos)
                    }
                })
            } else {
                print("Internet connection is not available.")
                
                let eventos = self.eventoRepository.buscarEventosDoBancoDeDados()
                self.eventoDelegate.populateTableView(eventos: eventos)
                self.eventoDelegate.noInternet()
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func buscarEventosPeloNome(nome: String, page: Int) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.eventoRepository.buscarEventosPeloNome(nome: nome, page: page, completion: { resource in
                    guard let eventos: [Evento] = resource.result ?? [] else { return }
                    
                    if eventos.count == 0 {
                        self.eventoDelegate.showError(resource.errorCode ?? 0)
                    } else {
                        self.eventoDelegate.populateTableView(eventos: eventos)
                    }
                })
            } else {
                print("Internet connection is not available.")
                
                let eventos = self.eventoRepository.buscarEventosDoBancoDeDados()
                self.eventoDelegate.populateTableView(eventos: eventos)
                self.eventoDelegate.noInternet()
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
}
