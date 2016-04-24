import Foundation
import UIKit
import VectorKit

class NavigationTool: Tool {
	static let name: String = "Navigate"

	private var previousPoint: CGPoint?

	required init() {}

	func began(atPoint point: CGPoint, context: Workspace) -> Workspace {
		let point = context.viewportPointFromDocumentPoint(point)
		self.previousPoint = point
		return context
	}

	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace {
		let point = context.viewportPointFromDocumentPoint(point)
		guard let previousPoint = self.previousPoint else { return context }

		var contextʹ = context

		let translation = point - previousPoint
		contextʹ.viewportTransform = CGAffineTransformTranslate(context.viewportTransform, translation.x, translation.y)

		self.previousPoint = point
		return contextʹ
	}

	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace {
		self.previousPoint = nil
		return context
	}

	func commit() -> [HistoryItem] {
		return []
	}
}