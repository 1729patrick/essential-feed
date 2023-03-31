//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 31/03/23.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}
