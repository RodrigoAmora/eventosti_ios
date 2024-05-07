//
//  Evento.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 07/05/24.
//

import Foundation
import UIKit
import CoreData


class Evento: NSManagedObject, Decodable {
    
    // MARK: - Atributes
    @NSManaged var id: Int64
    @NSManaged var nome: String
    @NSManaged var descricao: String
    @NSManaged var site: String
    @NSManaged var dataInicio: Date
    @NSManaged var dataFim: Date
    
    // MARK: - Inits
    convenience init(id: Int64, nome: String, descricao: String, site: String, dataInicio: Date, dataFim: Date) {
        let managedContext = UIApplication.shared.delegate as! AppDelegate
        self.init(context: managedContext.persistentContainer.viewContext)
        self.id = id
        self.nome = nome
        self.descricao = descricao
        self.site = site
        self.dataInicio = dataInicio
        self.dataFim = dataFim
    }
    
    required convenience init(from decoder: Decoder) throws {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: managedContext)
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int64.self, forKey: .id)
            self.nome = try container.decode(String.self, forKey: .nome)
            self.descricao = try container.decode(String.self, forKey: .descricao)
            self.site = try container.decode(String.self, forKey: .site)
            self.dataInicio = try container.decode(Date.self, forKey: .dataInicio)
            self.dataFim = try container.decode(Date.self, forKey: .dataFim)
        } catch {
            print("Error retriving questions \(error)")
        }
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nome = "nome"
        case descricao = "descricao"
        case site = "site"
        case dataInicio = "dataInicio"
        case dataFim = "dataFim"
    }
    
    // MARK: - Core Data - DAO
    class func fetchRequest() -> NSFetchRequest<Evento> {
        return NSFetchRequest(entityName: "Evento")
    }
    
    func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func load(_ fetchedResultController: NSFetchedResultsController<Evento>) {
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func buscarEventos() -> NSFetchedResultsController<Evento> {
        let searcher: NSFetchedResultsController<Evento> = {
            var fetchRequest: NSFetchRequest<Evento> = Evento.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return NSFetchedResultsController(fetchRequest: fetchRequest,
                                              managedObjectContext: appDelegate.persistentContainer.viewContext,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        }()
        
        return searcher
    }
    
}
