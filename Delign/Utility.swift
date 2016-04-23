//
//  Utility.swift
//  Delign
//
//  Created by David Lee on 4/23/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

/// Describes a value which has a human-readable, non-unique name.
protocol Named {
	/// A human-readable name for this value. This is not guaranteed to be unique.
	var name: String { get set }
}

protocol Identifiable {
	var id: String { get }
}