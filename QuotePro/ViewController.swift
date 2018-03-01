//
//  ViewController.swift
//  QuotePro
//
//  Created by Fernando Zanei on 2018-02-28.
//  Copyright © 2018 Fernando Zanei. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, QuoteViewDelegate {
    
    var quotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let api = APIManager()
        //        api.getRandomQuote { (quote) in
        //            print("\"\(quote.text)\", \(quote.author)")
        //        }
        
        
        //        api.getRandomPhoto { (photo) in
        //            print("KD A photo????????????")
        //        }
        
    }
    
    // MARK - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = quotes[indexPath.row].text
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

    
    
    func saveQuote(quoteBuilder: QuoteViewController, didCreateQuote quote: Quote) {
        quotes.append(quote)
        tableView.reloadData()
    }
    
    
}

