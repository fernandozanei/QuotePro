//
//  QuoteDetailViewController.swift
//  QuotePro
//
//  Created by Fernando Zanei on 2018-02-28.
//  Copyright © 2018 Fernando Zanei. All rights reserved.
//

import UIKit

protocol QuoteViewDelegate
{
    func saveQuote(quoteBuilder: QuoteViewController, didCreateQuote quote: Quote)
}

class QuoteViewController: UIViewController {
    
    var delegate: QuoteViewDelegate?
    
    let api = APIManager()
    var quote: Quote?
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if quote == nil {
            self.api.getRandomQuote(completionHandler: { (qut) in
                OperationQueue.main.addOperation {
                    guard let quote = qut else {
                        self.cancel()
                        return
                    }
                    self.quote = quote
                    if self.photo != nil && self.quote != nil {
                        self.loadBuilderView()
                    }
                }
            })
            
            self.api.getRandomPhoto(completionHandler: { (pht) in
                OperationQueue.main.addOperation {
                    guard let photo = pht else {
                        self.cancel()
                        return
                    }
                    
                    
                    self.photo = photo
                    if self.photo != nil && self.quote != nil {
                        self.loadBuilderView()
                    }
                }
            })
        } else {
            loadBuilderView()
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    //    @IBAction func cancel(_ sender: UIBarButtonItem) {
    //        dismiss(animated: true, completion: nil)
    //    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        quote?.photo = photo
        delegate?.saveQuote(quoteBuilder: self, didCreateQuote: quote!)
        
        dismiss(animated: true, completion: nil)
    }
    
    func loadBuilderView() {
        if let objects = Bundle.main.loadNibNamed("QuoteView", owner: nil, options: nil), let quoteview = objects.first as? QuoteView {
            quoteview.setupWithQuote(self.quote!)
            quoteview.setupWithPhoto(self.photo!)
            self.view.addSubview(quoteview)
            quoteview.frame = self.view.bounds
            quoteview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let button = UIButton()
            
            button.setTitle("X", for: .normal)
            button.titleLabel?.sizeToFit()
            
            button.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
            self.view.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 8).isActive = true
            NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 8).isActive = true
            NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 50).isActive = true
            NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 50).isActive = true
            
            let button2 = UIButton()
            button2.setTitleShadowColor(.black, for: .normal)
            button2.setTitle("Save", for: .normal)
            button2.addTarget(self, action: #selector(self.save), for: .touchUpInside)
            self.view.addSubview(button2)
            
            button2.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: button2, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 8).isActive = true
            NSLayoutConstraint(item: button2, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -8).isActive = true
            NSLayoutConstraint(item: button2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 50).isActive = true
            NSLayoutConstraint(item: button2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 50).isActive = true
            
        }
    }
    
}
