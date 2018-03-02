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
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    
    var api = APIManager()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //       Bundle.main.loadNibNamed("QuoteView", owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func setupWithQuote(_ quote: Quote) {
        self.text.text = "\"\(quote.text)\""
        self.text.setShadow()
        self.author.text = "- \(quote.author)"
        self.author.setShadow()
    }

    func setupWithPhoto(_ photo: Photo) {
        self.image.image = photo.photo
    }

}

extension UILabel {
    func setShadow() {
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 0.0;
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: -1.0);
    }
}
