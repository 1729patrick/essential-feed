//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import UIKit

extension UIView {
	
	public func makeContainer() -> UIView {
		let container = UIView()
		container.backgroundColor = .clear
		container.addSubview(self)
		
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			leadingAnchor.constraint(equalTo: container.leadingAnchor),
			container.trailingAnchor.constraint(equalTo: trailingAnchor),
			topAnchor.constraint(equalTo: container.topAnchor),
			container.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
		
		return container
	}
	
}
