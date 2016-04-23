import Foundation
import UIKit
import VectorKit

struct CirclePrimitive: Object {
	var id: String

	var name: String
	var children: [Drawable]

	var positionX: Property
	var positionY: Property

	var radius: Property

	var properties: [Property] {
		return [self.positionX, self.positionY, self.radius]
	}

	init(name: String, children: [Drawable], positionX: Property, positionY: Property, radius: Property) {
		self.id = SharedIDMaker.makeID(withPrefix: "Circle")

		self.name = name
		self.children = children
		self.positionX = positionX
		self.positionY = positionY
		self.radius = radius
	}

	func drawSelf() -> CALayer {
		let center = CGPoint(x: self.positionX.stream.value, y: self.positionY.stream.value)
		let size = CGSize(width: self.radius.value * 2, height: self.radius.value * 2)
		let origin: CGPoint = center - size * 0.5

		let path = UIBezierPath(ovalInRect: CGRect(origin: origin, size: size))

		let layer = CAShapeLayer()
		layer.path = path.CGPath

		layer.strokeColor = UIColor.blueColor().CGColor
		layer.fillColor = nil

		return layer
	}
}