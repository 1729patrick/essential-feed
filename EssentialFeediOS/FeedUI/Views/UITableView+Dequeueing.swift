//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Patrick Battisti Forsthofer on 15/04/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
