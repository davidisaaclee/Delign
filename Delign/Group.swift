import Foundation
import UIKit

class Group: Object {
	var id: String

	var name: String
	var children: [String: Object]
	weak var parent: Object?

	var positionX: Property
	var positionY: Property

	init(name: String, children: [String: Object], positionX: Property, positionY: Property) {
		self.id = IDMaker.sharedIDMaker.makeID(withPrefix: "Group")

		self.name = name
		self.children = children
		self.positionX = positionX
		self.positionY = positionY
	}

	func drawSelf() -> CALayer {
		return CALayer()
	}
}