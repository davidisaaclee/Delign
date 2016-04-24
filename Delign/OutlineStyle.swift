import Foundation
import UIKit

struct OutlineStyle: Style {
	var width: CGFloat = 1
	var color: CGColor? = UIColor.blackColor().CGColor

	func apply(toLayer layer: CALayer) -> CALayer {
		if let layer = layer as? CAShapeLayer {
			layer.strokeColor = self.color
			layer.lineWidth = self.width
		}

		return layer
	}
}