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
    
    var quoteView: QuoteView!
    let api = APIManager()
    var quote: Quote?
    var photo: Photo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let objects = Bundle.main.loadNibNamed("QuoteView", owner: nil, options: nil), let quotview = objects.first as? QuoteView {
            quoteView = quotview
        }
        
        
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
            photo = quote?.photo
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

    @objc func share() {
        UIGraphicsBeginImageContextWithOptions(quoteView.bounds.size, true, 0)
        quoteView.drawHierarchy(in: quoteView.bounds, afterScreenUpdates: true)
        let quoteImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let share = UIActivityViewController(activityItems: [quoteImage], applicationActivities:nil)
        
        self.present(share, animated: true, completion: nil)
    }

    @objc func changeQuote() {
        self.api.getRandomQuote(completionHandler: { (qut) in
            OperationQueue.main.addOperation {
                guard let quote = qut else {
                    self.cancel()
                    return
                }
                self.quote = quote
                if self.photo != nil && self.quote != nil {
                    self.quoteView.setupWithQuote(quote)
                }
            }
        })
    }
    
    @objc func changePhoto() {
        self.api.getRandomPhoto(completionHandler: { (pht) in
            OperationQueue.main.addOperation {
                guard let photo = pht else {
                    return
                }
                
                self.photo = photo
                if self.photo != nil && self.quote != nil {
                    self.quoteView.setupWithPhoto(self.photo!)
                }
            }
        })
    }
    
    func loadBuilderView() {
        quoteView.setupWithQuote(self.quote!)
        quoteView.setupWithPhoto(self.photo!)
        self.view.addSubview(quoteView)
        quoteView.frame = self.view.bounds
        quoteView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        closeButton()

        if quote?.photo == nil {
            saveButton()
            photoButton()
            quoteButton()
        } else {
            shareButton()
        }
        
    }
    
    private func saveButton() {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30.0)
        button.setShadow()
        
        button.addTarget(self, action: #selector(self.save), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -32).isActive = true
    }
    
    private func closeButton() {
        let button = UIButton()
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30.0)
        button.setShadow()

        button.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 32).isActive = true
    }
    
    private func quoteButton() {
        let button = UIButton()
        button.setTitle("Change\nQuote", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setShadow()

        button.addTarget(self, action: #selector(self.changeQuote), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -32).isActive = true
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 32).isActive = true
    }

    private func photoButton() {
        let button = UIButton()
        button.setTitle("Change\nPhoto", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setShadow()

        button.addTarget(self, action: #selector(self.changePhoto), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -32).isActive = true
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -32).isActive = true
        
    }

    private func shareButton() {
        let button = UIButton()
        button.setTitleShadowColor(.black, for: .normal)
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30.0)
        button.setShadow()
        
        button.addTarget(self, action: #selector(self.share), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -32).isActive = true
    }

}

extension UIButton {
    func setShadow() {
        self.titleLabel?.layer.shadowOpacity = 1.0;
        self.titleLabel?.layer.shadowRadius = 0.0;
        self.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        self.titleLabel?.layer.shadowOffset = CGSize(width: 0.0, height: -1.0);
    }
}
