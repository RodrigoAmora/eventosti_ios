//
//  DetalhesEventoViewController.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 28/05/24.
//

import UIKit

class DetalhesEventoViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nomeEventoLabel: UILabel!
    @IBOutlet weak var descricaoLabel: UILabel!
    @IBOutlet weak var dataInicioLabel: UILabel!
    @IBOutlet weak var dataInicioValorLabel: UILabel!
    @IBOutlet weak var dataFimLabel: UILabel!
    @IBOutlet weak var dataFimValorLabel: UILabel!
    @IBOutlet weak var siteValorLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    // MARK: - Atributes
    private var evento: Evento!
    
    // MARK: - init
   class func intanciate(_ evento: Evento) -> DetalhesEventoViewController {
       let controller = DetalhesEventoViewController()
       controller.evento = evento
       
       return controller
   }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.initViews()
    }

    // MARK: - Methods
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.topItem?.backButtonTitle = String(localized: "back")
        self.navigationController?.navigationBar.backgroundColor = .green
        self.navigationItem.title = String(localized: "app_name")
    }
    
    private func initViews() {
        self.nomeEventoLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.nomeEventoLabel.text = self.evento.nome
        self.nomeEventoLabel.textAlignment = .center
        
        if ((self.evento.descricao?.isEmpty) != nil) {
            self.descricaoLabel.text = String(localized: "no_description")
            self.descricaoLabel.textAlignment = .center
        } else {
            self.descricaoLabel.numberOfLines = 0
            self.descricaoLabel.lineBreakMode = .byWordWrapping
            self.descricaoLabel.sizeToFit()
            self.descricaoLabel.text = self.evento.descricao
        }
        
        self.dataInicioLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.dataInicioLabel.textAlignment = .left
        self.dataInicioLabel.text = String(localized: "data_inicio")
        
        self.dataInicioValorLabel.textAlignment = .right
        self.dataInicioValorLabel.text = self.evento.dataInicio
        
        self.dataFimLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.dataFimLabel.textAlignment = .left
        self.dataFimLabel.text = String(localized: "data_fim")
        
        self.dataFimValorLabel.textAlignment = .right
        self.dataFimValorLabel.text = self.evento.dataFim
        
        self.siteValorLabel.text = self.evento.site
        self.siteValorLabel.textAlignment = .center
        
        self.shareButton.setTitle("", for: .normal)
        self.shareButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
    }
    
    // MARK: - IBActions
    @IBAction func shareEvento(_  sender: UIButton) {
        let baseURL = ApiUrls.baseEventosTIAPIURL()
        
        let eventoId = self.evento.id
        let titulo = self.evento.nome
        
        let texto = "\(baseURL)/verEvento?id=\(eventoId)"
        
        self.share(text: texto)
    }
    
}
