import Foundation
import UIKit

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