import Foundation
import UIKit

class BackgroundObject: Group, Stylable {
	var styles: [Style] = []

	override var boundingBox: CGRect { return CGRect.infinite }

	override init(name: String, children: [String : Object], positionX: Property, positionY: Property) {
		super.init(name: name, children: children, positionX: positionX, positionY: positionY)

		self.locked = true
	}

	override func drawSelf() -> CALayer {
		// TODO: Use styles
		return CALayer()
	}
}