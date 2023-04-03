//
//  Date+adding.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 03/04/23.
//

import Foundation

extension Date {
   func adding(days: Int) -> Date {
       return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
   }

   func adding(seconds: TimeInterval) -> Date {
       return self + seconds
   }
}
