//
//  ListaEventosViewController.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 08/05/24.
//
import Foundation
import UIKit
import MaterialComponents.MaterialButtons

class ListaEventosViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var evntosTableView: UITableView!
    @IBOutlet weak var eventosSearchBar: UISearchBar!
    
    // MARK: - Atributos
    private var eventos: [Evento] = []
    private lazy var eventoViewModel: EventoViewModel = EventoViewModel(eventoDelegate: self)
    private let refreshControl = UIRefreshControl()
    private var fab: MDCFloatingButton!
    private var page = 0
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicatorView.configureActivityIndicatorView()
        self.configureNavigationBar()
        self.configureSearchBar()
        self.configureFloatingButton()
        self.configureTableView()
        self.configureDelegate()
        self.buscarEventos()
    }

    override func viewDidAppear(_ animated: Bool) {}
    
    // MARK: - Métodos
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .green
        self.navigationItem.title = String(localized: "app_name")
    }
    
    private func configureSearchBar() {
        self.eventosSearchBar.accessibilityIdentifier = "eventosSearchBar"
        self.eventosSearchBar.showsLargeContentViewer = true
        self.eventosSearchBar.isHidden = true
        self.eventosSearchBar.placeholder = String(localized: "search_event_by_name")
    }
    
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
    
    private func configureFloatingButton() {
        let widwonWidth = UIScreen.main.bounds.width - 50 - 25
        let windowHeight = UIScreen.main.bounds.height - 50 - 25
        
        self.fab = MDCFloatingButton(frame: CGRect(x: widwonWidth, y: windowHeight, width: 50, height: 50))
        self.fab.backgroundColor = .green
        self.fab.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        self.fab.addTarget(self, action: #selector(showOrHideSearchView), for: .touchUpInside)
        self.fab.accessibilityIdentifier = "fabSearchBar"
        
        self.view.addSubview(self.fab)
        }
    
    private func configureDelegate() {
        self.evntosTableView.dataSource = self
        self.evntosTableView.delegate = self
        
        self.eventosSearchBar.delegate = self
    }
    
    private func buscarEventos() {
        self.activityIndicatorView.show()
        self.eventoViewModel.buscarEventos(page: self.page)
    }
    
    private func buscarEventosPeloNome(nome: String) {
        self.activityIndicatorView.show()
        self.eventoViewModel.buscarEventosPeloNome(nome: nome, page: self.page)
    }
    
    private func viewDetails(_ evento: Evento) {
        let detalhesEventoViewController = DetalhesEventoViewController.intanciate(evento)
        self.changeViewControllerWithPushViewController(detalhesEventoViewController)
    }
    
    @objc private func refreshTableView() {
        self.page = 0
        self.buscarEventos()
        self.refreshControl.endRefreshing()
    }
    
    @objc private func paginateTableView() {
        self.page += 1
        self.buscarEventos()
        self.refreshControl.endRefreshing()
    }
    
    @objc func showOrHideSearchView() {
        if self.eventosSearchBar.isHidden {
            self.eventosSearchBar.isHidden = false
        } else {
            self.eventosSearchBar.isHidden = true
        }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favouriteaction = UIContextualAction(style: .normal, title: String(localized: "view_details")) {
            (action, view, completionHandler) in
            guard let evento: Evento? = self.eventos[indexPath.row] else { return }
            self.viewDetails(evento!)
            completionHandler(true)
        }
        favouriteaction.backgroundColor = UIColor.systemGray
        
        return UISwipeActionsConfiguration(actions: [favouriteaction])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.eventos.count-1, self.eventos.count >= 20 {
            self.paginateTableView()
        }
    }
}

// MARK: - UITableViewDelegate
extension ListaEventosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.evntosTableView.deselectRow(at: indexPath, animated: true)
        
        let evento: Evento = self.eventos[indexPath.row]
        self.viewDetails(evento)
    }
}

// MARK: - UISearchBarDelegate
extension ListaEventosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.hideKeyboard()
        let nomeEvento = searchBar.text?.replacingOccurrences(of: " ", with: "%20") ?? ""
        self.buscarEventosPeloNome(nome: nomeEvento)
    }
}

// MARK: - EventoDelegate
extension ListaEventosViewController: EventoDelegate {
    func populateTableView(eventos: [Evento]) {
        DispatchQueue.main.async {
            self.activityIndicatorView.hide()
            
            self.eventos = eventos
            self.evntosTableView.reloadData()
            
            if self.page != 0 {
                let targetRonIdexPath = IndexPath(row: self.eventos.count-5, section: 0)
                self.evntosTableView.scrollToRow(at: targetRonIdexPath, at: .middle, animated: false)
            }
        }
    }
    
    func replaceAll(eventos: [Evento]) {
        DispatchQueue.main.async {
            self.activityIndicatorView.hide()
            
            self.eventos.removeAll()
            self.eventos = eventos
            self.evntosTableView.reloadData()
            //        self.searchBar.isHidden = true
            
            if eventos.count > 10 {
                let targetRonIdexPath = IndexPath(row: 0, section: 0)
                self.evntosTableView.scrollToRow(at: targetRonIdexPath, at: .top, animated: false)
            }
        }
    }
    
    func showError(_ errorCode: Int) {
        self.activityIndicatorView.hide()
        self.showErrorMessage(errorCode: errorCode)
    }
    
    func showMessage(_ message: String) {
        self.showAlert(title: "", message: message)
    }

    func noInternet() {
        DispatchQueue.main.async {
            self.activityIndicatorView.hide()
            self.showAlert(title: "", message: String(localized: "no_internet"))
        }
    }
}
