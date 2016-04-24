//
//  Drawings.swift
//  Delign
//
//  Created by David Lee on 4/23/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import UIKit

struct Drawings {
	struct DrawingImpl: Drawing {
		var layer: CALayer
		var children: [String : Drawing]
	}

	static func make(layer layer: CALayer, children: [String: Drawing]) -> Drawing {
		return DrawingImpl(layer: layer, children: children)
	}
}
