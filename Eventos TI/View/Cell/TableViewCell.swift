//
//  TableViewCell.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 21/05/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataValueLabel: UILabel!
    @IBOutlet weak var verDetalhesLabel: UILabel!
    
    // MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Métodos
    private func initViews() {
        self.nomeLabel.textAlignment = .center
        self.nomeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        self.dataLabel.text = String(localized: "data")
        self.dataLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        self.verDetalhesLabel.text = String(localized: "view_details")
        self.verDetalhesLabel.textAlignment = .center
        self.verDetalhesLabel.textColor = .blue
    }
    
    func configureCell(_ evento: Evento) {
        self.nomeLabel.text = evento.nome
        self.dataValueLabel.text = evento.formatarData()
    }
}
