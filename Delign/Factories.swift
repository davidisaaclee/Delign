import Foundation
import UIKit

class IDMaker {
	static let sharedIDMaker = IDMaker()
	private var prefixCounts: [String: Int] = [:]

	func makeID(withPrefix prefix: String) -> String {
		if !self.prefixCounts.keys.contains(prefix) {
			self.prefixCounts[prefix] = 0
		}

		self.prefixCounts[prefix] = self.prefixCounts[prefix]! + 1
		return "\(prefix) \(self.prefixCounts[prefix]!)"
	}
}


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
	class ArtboardImpl: Artboard {
		var name: String
		var root: Object

		private var allObjects: [String: Object] = [:] {
			didSet {
				print(allObjects)
			}
		}

		init(name: String, root: Object) {
			self.name = name
			self.root = root

			func addToDict(object: Object) {
				self.allObjects[object.id] = object
				object.children.values.forEach(addToDict)
			}

			addToDict(root)
		}

		func addObject(object: Object, parent: Object?) {
			let parent = parent ?? self.root

			guard self.contains(parent) else {
				fatalError("Attempted to add object to parent object which is not in this artboard.")
			}

			parent.children[object.id] = object
			self.allObjects[object.id] = object
			object.parent = parent
		}

		func removeObject(object: Object) {
			self.allObjects.removeValueForKey(object.id)
			object.parent?.removeChild(object)
		}

		func find(id: String) -> Object? {
			return self.allObjects[id]
		}

		func contains(object: Object) -> Bool {
			return self.find(object.id) != nil
		}
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



