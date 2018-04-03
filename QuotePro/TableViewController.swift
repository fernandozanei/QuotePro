//
//  ViewController.swift
//  QuotePro
//
//  Created by Fernando Zanei on 2018-02-28.
//  Copyright © 2018 Fernando Zanei. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, QuoteViewDelegate {
    
    var quotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
        
    }
    
    // MARK - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath) as! TableViewCell
        cell.quote = quotes[indexPath.row]
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "add" {
            if let destinationVC = segue.destination as? QuoteViewController
            {
                destinationVC.delegate = self
            }
        }
        
        if segue.identifier == "row" {
            if let destinationVC = segue.destination as? QuoteViewController
            {
                let indexPath = tableView.indexPathForSelectedRow!
                destinationVC.quote = quotes[indexPath.row]
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    
    func saveQuote(quoteBuilder: QuoteViewController, didCreateQuote quote: Quote) {
        quotes.append(quote)
        tableView.reloadData()
        tableView.setNeedsDisplay()
        
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
    
    
}

