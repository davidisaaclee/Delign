import Foundation
import UIKit

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
