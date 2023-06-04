//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import XCTest
import EssentialFeed

class SharedLocalizationTests: XCTestCase {
	
	func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
		let table = "Shared"
		let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
		
		assertLocalizedKeyAndValuesExist(in: bundle, table)
	}
	
	private class DummyView: ResourceView {
		func display(_ viewModel: Any) {}
	}
	
}
