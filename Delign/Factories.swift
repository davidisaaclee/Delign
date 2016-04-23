//
//  Factories.swift
//  Delign
//
//  Created by David Lee on 4/23/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import UIKit

class IDMaker {
	private var prefixCounts: [String: Int] = [:]

	func makeID(withPrefix prefix: String) -> String {
		if !self.prefixCounts.keys.contains(prefix) {
			self.prefixCounts[prefix] = 0
		}

		self.prefixCounts[prefix] = self.prefixCounts[prefix]! + 1
		return "\(prefix) \(self.prefixCounts[prefix]!)"
	}
}

let SharedIDMaker = IDMaker()


struct Drawings {
	struct DrawingImpl: Drawing {
		var layer: CALayer
		var children: [String : Drawing]
	}

	static func make(layer layer: CALayer, children: [String: Drawing]) -> Drawing {
		return DrawingImpl(layer: layer, children: children)
	}
}


struct Properties {
	struct PropertyImpl: Property {
		var name: String
		var stream: Stream
	}

	static func make(name name: String, value: CGFloat) -> Property {
		return PropertyImpl(name: name, stream: Streams.make(initialValue: value))
	}
}

struct Artboards {
	struct ArtboardImpl: Artboard {
		var name: String
		var root: Object
	}

	static func make(name name: String, root: Object) -> Artboard {
		return ArtboardImpl(name: name, root: root)
	}

	static func makeEmpty(name name: String) -> Artboard {
		let root = Group(name: "Root", children: [:], positionX: Properties.make(name: "posX", value: 0), positionY: Properties.make(name: "posY", value: 0))
		return ArtboardImpl(name: name, root: root)
	}
}

struct HistoryItems {
	struct HistoryItemImpl: HistoryItem {
		let undoBlock: Workspace -> Workspace
		let redoBlock: Workspace -> Workspace

		init(undoBlock: Workspace -> Workspace, redoBlock: Workspace -> Workspace) {
			self.undoBlock = undoBlock
			self.redoBlock = redoBlock
		}

		func undo(context: Workspace) -> Workspace {
			return self.undoBlock(context)
		}

		func redo(context: Workspace) -> Workspace {
			return self.redoBlock(context)
		}
	}

	static func make(undoBlock undoBlock: Workspace -> Workspace, redoBlock: Workspace -> Workspace) -> HistoryItem {
		return HistoryItemImpl(undoBlock: undoBlock, redoBlock: redoBlock)
	}
}



