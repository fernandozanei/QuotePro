//
//  Quote.swift
//  QuotePro
//
//  Created by Fernando Zanei on 2018-02-28.
//  Copyright © 2018 Fernando Zanei. All rights reserved.
//

import Foundation

class Quote {
    var text: String
    var author: String
    var photo: Photo?
    
    init(_ text: String, _ author: String) {
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
