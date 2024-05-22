//
//  ListaEventosViewController.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 08/05/24.
//

import UIKit

class ListaEventosViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var evntosTableView: UITableView!
    
    // MARK: - Atributos
    private var eventos: [Evento] = []
    private lazy var eventoViewModel: EventoViewModel = EventoViewModel(eventoDelegate: self)
    private let refreshControl = UIRefreshControl()
    private var page = 0
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureDelegate()
        self.buscarEventos()
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Métodos
    private func configureTableView() {
        self.evntosTableView.accessibilityIdentifier = "evntosTableView"
        self.evntosTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.evntosTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.evntosTableView.isScrollEnabled = true
        self.evntosTableView.remembersLastFocusedIndexPath = true
        
        self.refreshControl.addTarget(self, action: #selector(self.refreshTableView), for: .valueChanged)
        self.evntosTableView.refreshControl = self.refreshControl
        self.refreshControl.endRefreshing()
    }
    
    private func configureDelegate() {
        self.evntosTableView.dataSource = self
        self.evntosTableView.delegate = self
    }
    
    private func buscarEventos() {
//        self.activityIndicatorView.configureActivityIndicatorView()
        self.eventoViewModel.buscarEventos(page: self.page)
    }
    
    @objc private func refreshTableView() {
        self.page = 0
        self.buscarEventos()
        self.refreshControl.endRefreshing()
    }
    
    @objc private func paginateTableView() {
        self.page += 10
        self.buscarEventos()
        self.refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension ListaEventosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            fatalError("error creating TableViewCell")
        }

        let evento = self.eventos[indexPath.row]
        cell.configureCell(evento)
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let favouriteaction = UIContextualAction(style: .normal, title: String(localized: "view_details")) {
//            [weak self] (action, view, completionHandler) in
//            guard let character: Character = self?.eventos[indexPath.row] else { return }
//            self?.viewDetails(character)
//            completionHandler(true)
//        }
//        favouriteaction.backgroundColor = .systemGray
//        
//        return UISwipeActionsConfiguration(actions: [favouriteaction])
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.eventos.count-1, self.eventos.count >= 20 {
            self.paginateTableView()
        }
    }
}

// MARK: - UITableViewDelegate
extension ListaEventosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.evntosTableView.deselectRow(at: indexPath, animated: true)
        
        let evento: Evento = self.eventos[indexPath.row]
        //self.viewDetails(evento)
    }
}

// MARK: - EventoDelegate
extension ListaEventosViewController: EventoDelegate {
    func populateTableView(eventos: [Evento]) {
//        self.activityIndicatorView.hideActivityIndicatorView()
                
        self.eventos = eventos
        self.evntosTableView.reloadData()
        
        if page != 0 {
            let targetRonIdexPath = IndexPath(row: self.eventos.count-5, section: 0)
            self.evntosTableView.scrollToRow(at: targetRonIdexPath, at: .middle, animated: false)
        }
    }
    
    func replaceAll(eventos: [Evento]) {
//        self.activityIndicatorView.hideActivityIndicatorView()
                
        self.eventos.removeAll()
        self.eventos = eventos
        self.evntosTableView.reloadData()
//        self.searchBar.isHidden = true
        
        if eventos.count > 10 {
            let targetRonIdexPath = IndexPath(row: 0, section: 0)
            self.evntosTableView.scrollToRow(at: targetRonIdexPath, at: .top, animated: false)
        }
    }
    
    func showError(_ errorCode: Int) {
        //
    }
    
    func showMessage(_ message: String) {
        //
    }
    
}
