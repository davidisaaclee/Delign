import Foundation
import UIKit

struct Group: Object {
	var id: String

	var name: String
	var children: [Drawable]

	var positionX: Property
	var positionY: Property

	init(name: String, children: [Drawable], positionX: Property, positionY: Property) {
		self.id = SharedIDMaker.makeID(withPrefix: "Group")

		self.name = name
		self.children = children
		self.positionX = positionX
		self.positionY = positionY
	}

	func drawSelf() -> CALayer {
		return CALayer()
	}
}