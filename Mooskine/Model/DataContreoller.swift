//
//  DataContreoller.swift
//  Mooskine
//
//  Created by Mohamed Nouri on 12/08/2020.
//  Copyright © 2020 Mohamed Nouri. All rights reserved.
//

import Foundation

import CoreData


class DataController {
    let preseistentContainer:NSPersistentContainer
    var viewContext:NSManagedObjectContext{
        return preseistentContainer.viewContext
     
    }
    var backgroundContect:NSManagedObjectContext!
    
    
    init(modelName:String) {
        preseistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts(){
        backgroundContect = preseistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContect.automaticallyMergesChangesFromParent = true
        backgroundContect.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump


    }
    
    func load(completion:(()->Void)? = nil ){
        preseistentContainer.loadPersistentStores { (storeDescription, error) in
            
            guard error == nil else {
                fatalError()
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
        
        
    }
    
    
}
// MARK: - Autosaving Every 30

extension DataController {
    func autoSaveViewContext(interval:TimeInterval = 30) {
        print("autosaving")
        
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
