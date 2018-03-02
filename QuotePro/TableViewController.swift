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
    }
    
    
}

