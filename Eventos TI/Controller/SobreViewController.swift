//
//  SobreViewController.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 17/08/24.
//

import UIKit

class SobreViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var versaoLabel: UILabel!
    @IBOutlet weak var siteAppLabel: UILabel!
    
    @IBOutlet weak var criadoPorLabel: UILabel!
    @IBOutlet weak var emailAutorLabel: UILabel!
    @IBOutlet weak var siteAutorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
    }

    private func initViews() {
        let versao = String(localized: "version_app")
        self.versaoLabel.text = String(format: versao, self.getVersionApp() ?? "")
        self.versaoLabel.textAlignment = .center
        
        self.siteAppLabel.text = String(localized: "site_app")
        self.siteAppLabel.textAlignment = .center
        
        self.criadoPorLabel.text = String(localized: "created_by")
        self.criadoPorLabel.textAlignment = .center
        
        self.emailAutorLabel.text = String(localized: "email_author")
        self.emailAutorLabel.textAlignment = .center
        
        self.siteAutorLabel.text = String(localized: "site_author")
        self.siteAutorLabel.textAlignment = .center
    }
}
