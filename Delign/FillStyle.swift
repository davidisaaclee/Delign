import Foundation
import UIKit

struct FillStyle: Style {
	var color: CGColor? = UIColor.blackColor().CGColor

	func apply(toLayer layer: CALayer) -> CALayer {
		if let layer = layer as? CAShapeLayer {
			layer.fillColor = self.color
		}

		return layer
	}
}