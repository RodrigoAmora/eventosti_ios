//
//  EventoDao.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 09/05/24.
//

import Foundation
import UIKit
import CoreData

class EventoDao {
    
    private class func fetchRequest() -> NSFetchRequest<Evento> {
        return NSFetchRequest<Evento>(entityName: "Evento")
    }
    
    class func load(_ fetchedResultController: NSFetchedResultsController<Evento>) {
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func saveEvento(_ evento: Evento) {
        let context = CoreDataManager.getContext()
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Evento", into: context)
        entity.setValue(evento.id, forKey: "id")
        entity.setValue(evento.dataFim, forKey: "dataFim")
        entity.setValue(evento.dataInicio, forKey: "dataInicio")
        entity.setValue(evento.descricao, forKey: "descricao")
        entity.setValue(evento.nome, forKey: "nome")
        entity.setValue(evento.site, forKey: "site")
        entity.setValue(evento.site, forKey: "tipoEvento")
    }
    
    class func deleteEvento(_ evento: Evento) {
        let context = CoreDataManager.getContext()
        let coord = context.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Evento")
        
        //Here is the field on which u need to chk which record u want to delete just pass here in value ( acutal value) unique key = field in coredata
        let predicate = NSPredicate(format: "id == %@", evento.id)
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord!.execute(deleteRequest, with: context)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func buscarEventos() -> [Evento] {
        let sort = NSSortDescriptor(key: "id", ascending: true)
        
        let fetchRequest: NSFetchRequest<Evento> = self.fetchRequest()
        fetchRequest.sortDescriptors = [sort]
        
        do {
            return try CoreDataManager.getContext().fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    class func cleanCoreData() {
        let fetchRequest:NSFetchRequest<Evento> = self.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try CoreDataManager.getContext().execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}
