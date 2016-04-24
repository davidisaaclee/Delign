import Foundation
import UIKit
import VectorKit

final class NavigationTool: Tool {
	static let name: String = "Navigate"

	private var initialTransform: CGAffineTransform?
	private var previousPoint: CGPoint?
	private var transforms: [(pre: CGAffineTransform, post: CGAffineTransform)] = []

	required init() {}

	func began(atPoint point: CGPoint, context: Workspace) -> Workspace {
		self.previousPoint = context.viewportPointFromDocumentPoint(point)
		self.initialTransform = context.viewportTransform
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
		guard let initialTransform = self.initialTransform else { return context }
		self.transforms.append(pre: initialTransform, post: context.viewportTransform)

		self.previousPoint = nil

		return context
	}

	func commit() -> [HistoryItem] {
		let items = self.transforms.map { (pre, post) in
			HistoryItems.make(undoBlock: { workspace in
				var workspaceʹ = workspace
				workspaceʹ.viewportTransform = pre
				return workspaceʹ
			}, redoBlock: { workspace in
				var workspaceʹ = workspace
				workspaceʹ.viewportTransform = post
				return workspaceʹ
			})
		}
		self.transforms = []
		return items
	}
}