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
    @IBOutlet weak var dataInicioLabel: UILabel!
    @IBOutlet weak var dataInicioValueLabel: UILabel!
    @IBOutlet weak var dataFimLabel: UILabel!
    @IBOutlet weak var dataFimValueLabel: UILabel!
    
    // MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Métodos
    private func initViews() {
        self.nomeLabel.textAlignment = .center
        self.nomeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        self.dataFimValueLabel.textAlignment = .right
        
        self.dataFimLabel.text = String(localized: "data_fim")
        self.dataFimLabel.textAlignment = .right
        self.dataFimLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        self.dataInicioLabel.text = String(localized: "data_inicio")
        self.dataInicioLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
    }
    
    func configureCell(_ evento: Evento) {
        self.nomeLabel.text = evento.nome
        self.dataFimValueLabel.text = evento.dataFim
        self.dataInicioValueLabel.text = evento.dataInicio
    }
}
