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
    private var fbBuscarEventosPorNome: MDCFloatingButton!
    private var fbListarTodosEventos: MDCFloatingButton!
    
    private var page = 0
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicatorView.configureActivityIndicatorView()
        self.configureSearchBar()
        self.configureFloatingButton()
        self.configureTableView()
        self.configureDelegate()
        self.buscarEventos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBarAndRightBarButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {}
    
    // MARK: - Métodos
    private func configureSearchBar() {
        self.eventosSearchBar.accessibilityIdentifier = "eventosSearchBar"
        self.eventosSearchBar.showsLargeContentViewer = true
        self.eventosSearchBar.isHidden = true
        self.eventosSearchBar.placeholder = String(localized: "search_event_by_name")
        self.eventosSearchBar.posY()
    }
    
    private func configureTableView() {
        self.evntosTableView.accessibilityIdentifier = "evntosTableView"
        self.evntosTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.evntosTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.evntosTableView.isScrollEnabled = true
        self.evntosTableView.remembersLastFocusedIndexPath = true

        var separatorColor = UIColor.black
        if traitCollection.userInterfaceStyle == .dark {
            separatorColor = UIColor.green
        }

        evntosTableView.separatorStyle = .singleLine
        evntosTableView.separatorColor = separatorColor
        evntosTableView.separatorInset = .zero
        
        self.refreshControl.addTarget(self, action: #selector(self.refreshTableView), for: .valueChanged)
        self.evntosTableView.refreshControl = self.refreshControl
        self.refreshControl.endRefreshing()
    }
    
    private func configureFloatingButton() {
        let widwonWidth = UIScreen.main.bounds.width - 50 - 25
        let windowHeight = UIScreen.main.bounds.height - 50 - 25
        
        self.fbBuscarEventosPorNome = MDCFloatingButton(frame: CGRect(x: widwonWidth, y: windowHeight, width: 50, height: 50))
        self.fbBuscarEventosPorNome.backgroundColor = .green
        self.fbBuscarEventosPorNome.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        self.fbBuscarEventosPorNome.addTarget(self, action: #selector(showOrHideSearchView), for: .touchUpInside)
        self.fbBuscarEventosPorNome.accessibilityIdentifier = "fabSearchBar"
        
        self.view.addSubview(self.fbBuscarEventosPorNome)
        
        self.fbListarTodosEventos = MDCFloatingButton(frame: CGRect(x: widwonWidth, y: windowHeight-60, width: 50, height: 50))
        self.fbListarTodosEventos.backgroundColor = .green
        self.fbListarTodosEventos.setImage(UIImage(systemName: "repeat"), for: .normal)
        self.fbListarTodosEventos.addTarget(self, action: #selector(buscarEventos), for: .touchUpInside)
        self.fbListarTodosEventos.accessibilityIdentifier = "fbListarTodosEventos"
        
        self.view.addSubview(self.fbListarTodosEventos)
    }
    
    private func configureNavigationBarAndRightBarButtonItem() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.green

        let textColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.titleTextAttributes = textColor
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        
        self.navigationItem.title = String(localized: "app_name")
        
        let about = UIAction(title: String(localized: "menu_about"), image: UIImage(systemName: "info.circle.fill")) { _ in
            self.changeViewControllerWithPresent(SobreViewController())
        }
        
        let btRightMenu = UIBarButtonItem()
        btRightMenu.image = UIImage(systemName: "text.justify")
        btRightMenu.menu = UIMenu(title: "", children: [about])
        
        self.navigationItem.rightBarButtonItem = btRightMenu
    }
    
    private func configureDelegate() {
        self.evntosTableView.dataSource = self
        self.evntosTableView.delegate = self
        
        self.eventosSearchBar.delegate = self
    }
    
    @objc private func buscarEventos() {
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
            self.eventosSearchBar.show()
        } else {
            self.eventosSearchBar.hide()
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
        let detailsAction = UIContextualAction(style: .normal, title: String(localized: "view_details")) { [weak self] _, _, completionHandler in
            guard let self = self else {
                completionHandler(false)
                return
            }

            let evento = self.eventos[indexPath.row]
            self.viewDetails(evento)
            completionHandler(true)
        }

        detailsAction.backgroundColor = .systemGray

        let configuration = UISwipeActionsConfiguration(actions: [detailsAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.eventos.count-1, self.eventos.count >= 20 {
            self.paginateTableView()
        }
        
//        if let lastCellRowIndex = tableView.indexPathsForVisibleRows?.last?.row {
//            if self.eventos.count - 1 > lastCellRowIndex + 1 {
//                self.fbBuscarEventosPorNome?.isHidden = false
//                self.fbListarTodosEventos?.isHidden = false
//            } else {
//                self.fbBuscarEventosPorNome?.isHidden = true
//                self.fbListarTodosEventos?.isHidden = true
//            }
//        }
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
            self.eventosSearchBar.hide()
            
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
            self.eventosSearchBar.hide()
            
            self.eventos.removeAll()
            self.eventos = eventos
            self.evntosTableView.reloadData()
            
            if eventos.count > 10 {
                let targetRonIdexPath = IndexPath(row: 0, section: 0)
                self.evntosTableView.scrollToRow(at: targetRonIdexPath, at: .top, animated: false)
            }
        }
    }
    
    func showError(_ errorCode: Int) {
        self.activityIndicatorView.hide()
        self.eventosSearchBar.hide()
        self.showErrorMessage(errorCode: errorCode)
    }
    
    func showMessage(_ message: String) {
        self.activityIndicatorView.hide()
        self.eventosSearchBar.hide()
        self.showAlert(title: "", message: message)
    }

    func noInternet() {
        DispatchQueue.main.async {
            self.activityIndicatorView.hide()
            self.showAlert(title: "", message: String(localized: "no_internet"))
        }
    }
}
