import UIKit
import VectorKit

/// A spatial and lexical context for objects.
protocol Artboard: class, Named {
	var root: Object { get set }

	func find(id: String) -> Object?
	func contains(object: Object) -> Bool

	func addObject(object: Object, parent: Object?)
	func removeObject(object: Object)
}


/// A hierarchical object that can be drawn to a `CALayer`.
protocol Drawable: Identifiable {
	func drawSelf() -> CALayer
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
}

extension Object {
	func removeChild(child: Object) {
		self.children.removeValueForKey(child.id)
	}
}

protocol Stylable {
	var styles: [Style] { get set }

	func applyStyles(toLayer layer: CALayer) -> CALayer
}

extension Stylable {
	func applyStyles(toLayer layer: CALayer) -> CALayer {
		return self.styles.reduce(layer) { layer, style in
			style.apply(toLayer: layer)
			return layer
		}
	}
}

protocol Style {
	func apply(toLayer layer: CALayer) -> CALayer
}


/// Describes something which can be translated.
protocol Transformable {
	var positionX: Property { get set }
	var positionY: Property { get set }
}