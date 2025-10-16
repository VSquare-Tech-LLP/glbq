//
//  CoreDataManager.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 16/10/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    private var ctx: NSManagedObjectContext { PersistenceController.shared.container.viewContext }

    @discardableResult
    func saveLocalHistory(
        locals: [URL],
        remotes: [URL?],
        prompt: String?,
        source: String?
    ) throws -> [NSManagedObjectID] {
        let now = Date()
        var ids: [NSManagedObjectID] = []
        
        // Get the base folder to calculate relative paths
        let baseFolder = getImagesDirectory()
        
        for (idx, fileURL) in locals.enumerated() {
            let rec = NSEntityDescription.insertNewObject(forEntityName: "ImageRecord", into: ctx)
            rec.setValue(UUID().uuidString, forKey: "id")
            
            // FIXED: Store relative path instead of full path
            let relativePath = fileURL.lastPathComponent // Just the filename
            rec.setValue(relativePath, forKey: "localPath")
            
            rec.setValue(remotes[idx]?.absoluteString, forKey: "remoteURL")
            rec.setValue(now,                 forKey: "createdAt")
            rec.setValue(prompt,              forKey: "prompt")
            rec.setValue(source,              forKey: "source")
            ids.append(rec.objectID)
        }
        if ctx.hasChanges { try ctx.save() }
        return ids
    }
    
    func fetchHistory(newestFirst: Bool) throws -> [ImageRecord] {
        let req = NSFetchRequest<NSManagedObject>(entityName: "ImageRecord")
        var preds: [NSPredicate] = []

        if !preds.isEmpty {
            req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: preds)
        }
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: !newestFirst)]
        return try (ctx.fetch(req) as? [ImageRecord]) ?? []
    }
    
    func deleteHistory() throws {
         let req = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageRecord")
         var preds: [NSPredicate] = []


         if !preds.isEmpty {
             req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: preds)
         }
         
         let deleteRequest = NSBatchDeleteRequest(fetchRequest: req)
         try ctx.execute(deleteRequest)
         try ctx.save()
     }
    
    // ADDED: Helper function to get the images directory (same as LocalImageStore)
    private func getImagesDirectory() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = appSupport.appendingPathComponent("GLBQ", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let images = folder.appendingPathComponent("Images", isDirectory: true)
        try? FileManager.default.createDirectory(at: images, withIntermediateDirectories: true)
        return images
    }
}
