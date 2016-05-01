import Foundation
import UIKit

class Group: Object {
	var id: String

	var name: String
	var children: [String: Object]
	weak var parent: Object?

	var locked: Bool = false

	var positionX: Property
	var positionY: Property

	var boundingBox: CGRect {
		guard !self.children.isEmpty else { return CGRect.zero }

		return self.children.values
			.map { $0.boundingBox }
			.reduce(self.children.values.first!.boundingBox, combine: CGRectUnion)
			.offsetBy(dx: self.positionX.value, dy: self.positionY.value)
	}

	init(name: String, children: [String: Object], positionX: Property, positionY: Property) {
		self.id = IDMaker.sharedIDMaker.makeID(withPrefix: "Group")

		self.name = name
		self.children = children
		self.positionX = positionX
		self.positionY = positionY
	}

	func drawSelf() -> CALayer {
		let layer = CALayer()
		layer.transform = CATransform3DMakeTranslation(self.positionX.value, self.positionY.value, 0)
		return layer
	}
}