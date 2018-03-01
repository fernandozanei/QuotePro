//
//  QuoteView.swift
//  QuotePro
//
//  Created by Fernando Zanei on 2018-02-28.
//  Copyright © 2018 Fernando Zanei. All rights reserved.
//

import UIKit

class QuoteView: UIView {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var author: UILabel!
    
    
    var api = APIManager()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //       Bundle.main.loadNibNamed("QuoteView", owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //        Bundle.main.loadNibNamed("QuoteView", owner: self, options: nil)
    }
    
    func setupWithQuote(_ quote: Quote) {
        self.text.text = "\"\(quote.text)\""
        self.author.text = "- \(quote.author)"
    }

    func setupWithPhoto(_ photo: Photo) {
        self.image.image = photo.photo
    }

}
