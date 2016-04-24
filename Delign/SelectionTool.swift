import Foundation
import UIKit

class SelectionTool: Tool {
	static let name: String = "Select"

	let tapThreshold: NSTimeInterval = 0.1

	private var startPoint: CGPoint?
	private var movingPoint: CGPoint?
	private var touchDownTime: NSDate?

	private func selectedObjects(context: Workspace) -> [Object] {
		guard let startPoint = self.startPoint, movingPoint = self.movingPoint else { return [] }

		let marquee = rectFromCorners(corner1: startPoint, corner2: movingPoint)
		return context.artboard.allObjects
			.map { $0.1 }
			.filter { !$0.locked }
			.filter { CGRectIntersectsRect($0.boundingBox, marquee) }
	}

	required init() {}

	func began(atPoint point: CGPoint, context: Workspace) -> Workspace {
		self.touchDownTime = NSDate()

		self.startPoint = point
		self.movingPoint = point

		return context
	}

	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace {
		self.movingPoint = point
		return context
	}

	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace {
		self.startPoint = nil
		self.movingPoint = nil

		return context
	}

	func commit() -> [HistoryItem] {
		return []
	}

	func drawOverlay(context: Workspace) -> CALayer {
		guard let startPoint = self.startPoint, let movingPoint = self.movingPoint else {
			return CALayer()
		}

		let marquee = rectFromCorners(corner1: startPoint, corner2: movingPoint)

		let marqueeLayer = CAShapeLayer()
		marqueeLayer.path = UIBezierPath(rect: marquee).CGPath

		marqueeLayer.strokeColor = UIColor(red: 0.4, green: 0.56, blue: 1.00, alpha: 1.00).CGColor
		marqueeLayer.lineWidth = 1
		marqueeLayer.fillColor = UIColor(red: 0.86, green: 0.96, blue: 1.00, alpha: 1.00).CGColor
		marqueeLayer.opacity = 0.4


		let selectionPath = UIBezierPath()
		self.selectedObjects(context)
			.map { $0.boundingBox }
			.map { UIBezierPath(rect: $0) }
			.forEach { selectionPath.appendPath($0) }

		let selectionLayer = CAShapeLayer()
		selectionLayer.path = selectionPath.CGPath

		selectionLayer.strokeColor = UIColor(red: 0.4, green: 0.56, blue: 1.00, alpha: 1.00).CGColor
		selectionLayer.lineWidth = 1
		selectionLayer.fillColor = nil
		selectionLayer.opacity = 1

		let layer = CALayer()
		layer.addSublayer(marqueeLayer)
		layer.addSublayer(selectionLayer)

		return layer
	}
}


private func rectFromCorners(corner1 corner1: CGPoint, corner2: CGPoint) -> CGRect {
	let origin = CGPoint(x: min(corner1.x, corner2.x), y: min(corner1.y, corner2.y))
	let size = CGSize(width: max(corner1.x - origin.x, corner2.x - origin.x),
	                  height: max(corner1.y - origin.y, corner2.y - origin.y))
	return CGRect(origin: origin, size: size)
}