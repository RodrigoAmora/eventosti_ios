//
//  DetalhesEventoViewController.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 28/05/24.
//

import UIKit

class DetalhesEventoViewController: BaseViewController {

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

        // Do any additional setup after loading the view.
    }

}
