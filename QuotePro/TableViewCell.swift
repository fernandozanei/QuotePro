//
//  TableViewCell.swift
//  QuotePro
//
//  Created by Fernando Zanei on 2018-03-01.
//  Copyright © 2018 Fernando Zanei. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var quote: Quote? {
        didSet {
            loadView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    private func loadView() {
        if let objects = Bundle.main.loadNibNamed("QuoteView", owner: nil, options: nil), let quoteview = objects.first as? QuoteView {
            quoteview.setupWithQuote(self.quote!)
            quoteview.setupWithPhoto((self.quote?.photo!)!)
            
            self.contentView.addSubview(quoteview)
            quoteview.frame = self.contentView.bounds
            quoteview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            quoteview.text.font = UIFont(name: "Gill Sans-Bold", size: 17.0)
            quoteview.author.font = UIFont(name: "Gill Sans-Bold", size: 13.0)
            
            quoteview.centerConstraint.constant -= 25

        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
