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
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataValorLabel: UILabel!
    @IBOutlet weak var siteValorLabel: UILabel!
    @IBOutlet weak var tipoEventoLabel: UILabel!
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
        
        let descricaoDoEvento = evento.descricao ?? ""
        if (descricaoDoEvento.isEmpty) {
            self.descricaoLabel.text = String(localized: "no_description")
            self.descricaoLabel.textAlignment = .center
        } else {
            self.descricaoLabel.numberOfLines = 0
            self.descricaoLabel.lineBreakMode = .byWordWrapping
            self.descricaoLabel.sizeToFit()
            self.descricaoLabel.text = descricaoDoEvento
        }
        
        self.dataLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.dataLabel.textAlignment = .center
        self.dataLabel.text = String(localized: "data")
        
        self.dataValorLabel.text = self.evento.formatarData()
        self.dataValorLabel.textAlignment = .center
        
        self.siteValorLabel.text = self.evento.site
        self.siteValorLabel.textAlignment = .center
        
        self.shareButton.setTitle("", for: .normal)
        self.shareButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        
        let tipoEvento = switch(evento.tipoEvento) {
            case TipoEvento.HIBRIDO.rawValue:
                String(localized: "hibrido")
            case TipoEvento.PRESENCIAL.rawValue:
                String(localized: "presencial")
            case TipoEvento.ON_LINE.rawValue:
                String(localized: "on_line")
            default:
                String(localized: "on_line")
        }
        
        self.tipoEventoLabel.text = tipoEvento
        self.tipoEventoLabel.textAlignment = .center
    }
    
    // MARK: - IBActions
    @IBAction func shareEvento(_  sender: UIButton) {
        let baseURL = ApiUrls.baseEventosTIAPIURL()
        
        let eventoId = self.evento.id
        
        let texto = "\(baseURL)/verEvento?id=\(eventoId)"
        
        self.share(text: texto)
    }
    
}
