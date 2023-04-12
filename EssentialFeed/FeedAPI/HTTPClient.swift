//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 31/03/23.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void)
}
