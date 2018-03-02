 //
 //  ForismaticAPI.swift
 //  QuotePro
 //
 //  Created by Fernando Zanei on 2018-02-28.
 //  Copyright © 2018 Fernando Zanei. All rights reserved.
 //
 
 import UIKit
 
 protocol NetworkerType {
    func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)
 }
 
 enum APIType {
    case forismatic
    case lorempixel
    case unsplash
 }
 
 enum APIError: Error {
    case badURL
    case requestError
    case invalidJSON
 }
 
 class APIManager {
    
    var url: URL?
    func buildURL(api: APIType) -> URL? {
        var componenets = URLComponents()
        componenets.scheme = "https"
        
        var componentsURL: URL!
        
        switch api {
        case .forismatic:
            componenets.host = "api.forismatic.com"
            
            let method = URLQueryItem(name: "method", value: "getQuote")
            let lang = URLQueryItem(name: "lang", value: "en")
            let format = URLQueryItem(name: "format", value: "json")
            
            componenets.queryItems = [method, lang, format]
            componentsURL = componenets.url
            componentsURL = componentsURL?.appendingPathComponent("api")
            componentsURL = componentsURL?.appendingPathComponent("1.0/")
            
        case .lorempixel:
            componenets.host = "lorempixel.com"
            
            componentsURL = componenets.url
            componentsURL = componentsURL?.appendingPathComponent("500")
            componentsURL = componentsURL?.appendingPathComponent("800")
            componentsURL = componentsURL?.appendingPathComponent("nature")
            
        case .unsplash:
            //https://api.unsplash.com/photos/random/?client_id=ceb65ddb91507e504e745c112b04ae717c7dab9b7037a37b8e270e748cc73dee&w=500&h=800&query=landscape
            
            componenets.host = "api.unsplash.com"
            let client_id = URLQueryItem(name: "client_id", value: "ceb65ddb91507e504e745c112b04ae717c7dab9b7037a37b8e270e748cc73dee")
            let w = URLQueryItem(name: "w", value: "500")
            let h = URLQueryItem(name: "h", value: "800")
            let query = URLQueryItem(name: "query", value: "dark")

            componenets.queryItems = [client_id, w, h, query]
            componentsURL = componenets.url
            componentsURL = componentsURL?.appendingPathComponent("photos")
            componentsURL = componentsURL?.appendingPathComponent("random/")
        }
        
        return componentsURL
    }
    
    func getRandomQuote(completionHandler: @escaping (Quote?) -> ()) {
        guard let url = buildURL(api: .forismatic) else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error: \(String(error!.localizedDescription)) -quote")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode != 200 {
                    print("error - quote")
                }
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
            
            guard let qt = json else {
                completionHandler(nil)
                return
            }

            let quote = Quote(qt["quoteText"]!, qt["quoteAuthor"]!)
            completionHandler(quote)
            
            URLSession.shared.invalidateAndCancel()
        }
        task.resume()
    }
    
    func getRandomPhoto(completionHandler: @escaping (Photo?) -> ()) {
        guard let url = buildURL(api: .unsplash) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error: \(String(error!.localizedDescription)) - photo")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode != 200 {
                    print("error - photo")
                }
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            let urls = json["urls"] as! [String:String]
            
            guard let string = urls["custom"] else {
                completionHandler(nil)
                return
            }
            
            let dataUrl = URL(string: string)
            let imageData = try? Data(contentsOf: dataUrl!)
            let image = UIImage(data: imageData!)
            let photo = Photo(photo: image!)
            
            completionHandler(photo)
            
            URLSession.shared.invalidateAndCancel()
        }
        
        task.resume()
    }
    
 }
 
