import Foundation
import UIKit

struct Group: Object {
	var id: String

	var name: String
	var children: [String: Object]

	var positionX: Property
	var positionY: Property

	init(name: String, children: [String: Object], positionX: Property, positionY: Property) {
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