import UIKit
import VectorKit

/// A spatial and lexical context for objects.
protocol Artboard: class, Named {
	var root: Object { get set }
	var allObjects: [String: Object] { get }

	func find(id: String) -> Object?
	func contains(object: Object) -> Bool

	func addObject(object: Object, parent: Object?)
	func removeObject(object: Object)
}


/// A hierarchical object that can be drawn to a `CALayer`.
protocol Drawable: Identifiable {
	func drawSelf() -> CALayer

	var boundingBox: CGRect { get }
}

extension Drawable where Self: Object {
	func updateDrawing(drawing: Drawing?) -> Drawing {
		let updatedLayer = self.drawSelf()
		let children: [String: Drawing] = self.children
			.map { (id, child) in (id, child.updateDrawing(drawing?.children[id])) }
			.reduce([:]) {
				var d = $0
				d[$1.0] = $1.1
				return d
		}

		children.values.forEach {
			updatedLayer.addSublayer($0.layer)
		}

		return Drawings.make(layer: updatedLayer, children: children)
	}
}


protocol Drawing {
	var layer: CALayer { get set }
	var children: [String: Drawing] { get set }
}


/// A spatial object to be positioned on an artboard.
protocol Object: class, Named, Identifiable, Transformable, Drawable {
	weak var parent: Object? { get set }
	var children: [String: Object] { get set }
	
	var locked: Bool { get set }
}

extension Object {
	func removeChild(child: Object) {
		self.children.removeValueForKey(child.id)
	}
}

/// Describes something which can be translated.
protocol Transformable {
	var positionX: Property { get set }
	var positionY: Property { get set }
}