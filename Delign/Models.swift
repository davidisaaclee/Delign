import UIKit
import VectorKit

/// Holds any state necessary for an application session.
struct Workspace {
	var artboard: Artboard
	var activeTool: Tool
}

/// A spatial and lexical context for objects.
protocol Artboard: Named {
	var root: Object { get set }
}


/// A hierarchical object that can be drawn to a `CALayer`.
protocol Drawable: Identifiable {
	var children: [Drawable] { get }

	func drawSelf() -> CALayer
}

extension Drawable {
	func updateDrawing(drawing: Drawing?) -> Drawing {
		let updatedLayer = self.drawSelf()
		let children: [String: Drawing] = self.children
			.map { ($0.id, $0.updateDrawing(drawing?.children[$0.id])) }
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
protocol Object: Named, Identifiable, Transformable, Drawable {}

/// Describes something which can be translated.
protocol Transformable {
	var positionX: Property { get set }
	var positionY: Property { get set }
}

///// A declaration of how a property should react to an input stream.
//protocol Driver {
//	/// The input signal to which this driver reacts.
//	var input: Stream { get set }
//	
//	/// The property to be affected.
//	var target: Property { get set }
//}

/// A value which affects an object, which can be the target of a driver.
protocol Property: Named {
	var name: String { get }

	/// The value of this property as a stream.
	var stream: Stream { get }
}

extension Property {
	var value: CGFloat {
		return self.stream.value
	}
}
