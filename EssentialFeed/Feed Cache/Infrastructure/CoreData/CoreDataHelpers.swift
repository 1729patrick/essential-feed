//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import CoreData

extension NSPersistentContainer {
	static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {		
		let description = NSPersistentStoreDescription(url: url)
		let container = NSPersistentContainer(name: name, managedObjectModel: model)
		container.persistentStoreDescriptions = [description]
		
		var loadError: Swift.Error?
		container.loadPersistentStores { loadError = $1 }
		try loadError.map { throw $0 }
		
		return container
	}
}

extension NSManagedObjectModel {
	static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
		return bundle
			.url(forResource: name, withExtension: "momd")
			.flatMap { NSManagedObjectModel(contentsOf: $0) }
	}
}
