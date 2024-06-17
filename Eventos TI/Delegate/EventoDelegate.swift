//
//  EventoDelegate.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 21/05/24.
//

import Foundation

protocol EventoDelegate {
    func populateTableView(eventos: [Evento])
    func replaceAll(eventos: [Evento])
    func showError(_ errorCode: Int)
    func showMessage(_ message: String)
    func noInternet()
}
