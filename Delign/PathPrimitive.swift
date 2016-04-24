import Foundation
import UIKit
import VectorKit

class PathPrimitive: Object, Stylable {
	var id: String

	var name: String
	var children: [String: Object]
	weak var parent: Object?

	var locked: Bool = false

	var positionX: Property
	var positionY: Property

	var points: [CGPoint]

	private var path: UIBezierPath {
		let translatedPoints: [CGPoint] = self.points.map { point in
			point + CGPoint(x: self.positionX.value, y: self.positionY.value)
		}
		return UIBezierPath(points: translatedPoints)
	}

	var properties: [Property] {
		return [self.positionX, self.positionY]
	}

	var styles: [Style] = [
		OutlineStyle(width: 5, color: UIColor.blackColor().CGColor),
	]

	var boundingBox: CGRect {
		return self.path.bounds
	}

	init(name: String, children: [String: Object], positionX: Property, positionY: Property, points: [CGPoint] = []) {
		self.id = IDMaker.sharedIDMaker.makeID(withPrefix: "Circle")

		self.name = name
		self.children = children

		self.positionX = positionX
		self.positionY = positionY

		self.points = points
	}

	func drawSelf() -> CALayer {
		let layer = CAShapeLayer()
		layer.path = self.path.CGPath

		layer.strokeColor = nil
		layer.fillColor = nil

		return self.applyStyles(toLayer: layer)
	}
}