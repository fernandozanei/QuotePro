//
//  NetworkManager.swift
//  QuotePro
//
//  Created by Fernando Zanei on 2018-02-28.
//  Copyright © 2018 Fernando Zanei. All rights reserved.
//

import Foundation

class NetworkManager: NetworkerType {
    
    func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = urlSession.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
}
