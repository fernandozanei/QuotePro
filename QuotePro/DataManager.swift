//
//  DataManager.swift
//  QuotePro
//
//  Created by Fernando Zanei on 2018-04-03.
//  Copyright © 2018 Fernando Zanei. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    static func saveQuoteData(_ quote: Quote) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Quotes", in: context)
        let newQuote = NSManagedObject(entity: entity!, insertInto: context)
        
        
        let photoData = UIImagePNGRepresentation(quote.photo!.photo)
        
        newQuote.setValue(photoData, forKey: "photo")
        newQuote.setValue(quote.text, forKey: "text")
        newQuote.setValue(quote.author, forKey: "author")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    
    static func loadQuoteData() -> [Quote]? {
        var quotes = [Quote]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quotes")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let text = data.value(forKey: "text") as! String
                let author = data.value(forKey: "author") as! String
                let photo = Photo(photo: UIImage(data: data.value(forKey: "photo") as! Data)!)
                
                let quote = Quote(text, author)
                quote.photo = photo
                
                quotes.append(quote)
            }
        } catch {
            print("Failed")
            return nil
        }
        
        return quotes
    }
    
    static func deleteQuoteData(_ quote: Quote) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quotes")
        request.predicate = NSPredicate(format: "author = %@", quote.author)
        request.predicate = NSPredicate(format: "text = %@", quote.text)
        request.predicate = NSPredicate(format: "photo = %@", UIImagePNGRepresentation(quote.photo!.photo)! as CVarArg)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
            }

            do {
                try context.save()
            } catch {
                print("Failed saving")
            }

        } catch {
            print("Failed")
        }
    }

//        if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [UserInfo] {
//            for result in fetchResults {
//                managedContext.deleteObject(result)
//            }
//        }
//        var err: NSError?
//        if !managedContext.save(&err) {
//            println("User Info deleteData - Error : \(err!.localizedDescription)")
//            abort()
//        } else {
//            println("User Info deleteData - Success")
//        }
    
}
