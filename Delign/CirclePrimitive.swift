import Foundation
import UIKit
import VectorKit

class CirclePrimitive: Object, Stylable {
	var id: String

	var name: String
	var children: [String: Object]
	weak var parent: Object?

	var locked: Bool = false

	var positionX: Property
	var positionY: Property

	var radius: Property

	var properties: [Property] {
		return [self.positionX, self.positionY, self.radius]
	}

	var styles: [Style] = [
		OutlineStyle(width: 2, color: UIColor.grayColor().CGColor),
	]

	var boundingBox: CGRect {
		let center = CGPoint(x: self.positionX.stream.value, y: self.positionY.stream.value)
		let size = CGSize(width: self.radius.value * 2, height: self.radius.value * 2)
		let origin: CGPoint = center - size * 0.5

		return CGRect(origin: origin, size: size)
	}

	init(name: String, children: [String: Object], positionX: Property, positionY: Property, radius: Property) {
		self.id = IDMaker.sharedIDMaker.makeID(withPrefix: "Circle")

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

		layer.strokeColor = nil
		layer.fillColor = nil

		return self.applyStyles(toLayer: layer)
	}
}