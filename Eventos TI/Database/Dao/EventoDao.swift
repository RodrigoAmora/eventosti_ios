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
        return NSFetchRequest(entityName: "Evento")
    }
    
    func salvar(_ context: NSManagedObjectContext) {
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
    
    class func saveEvento(_ evento: Evento) {
        let context = CoreDataManager.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Evento", in: context)
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(evento.id, forKey: "id")
        managedObj.setValue(evento.dataFim, forKey: "dataFim")
        managedObj.setValue(evento.dataInicio, forKey: "dataInicio")
        managedObj.setValue(evento.descricao, forKey: "descricao")
        managedObj.setValue(evento.nome, forKey: "nome")
        managedObj.setValue(evento.site, forKey: "site")
        managedObj.setValue(evento.site, forKey: "tipoEvento")
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func buscarEventos() -> NSFetchedResultsController<Evento> {
        let searcher: NSFetchedResultsController<Evento> = {
            var fetchRequest: NSFetchRequest<Evento> = self.fetchRequest()
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
