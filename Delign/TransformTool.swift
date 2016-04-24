import Foundation
import UIKit
import VectorKit

final class TransformTool: Tool {
	static let name: String = "Transform"

	private var startPoint: CGPoint?
	private var previousPoint: CGPoint?

	private var changes: [(translation: CGPoint, objects: [Object])] = []

	init() {}

	func began(atPoint point: CGPoint, context: Workspace) -> Workspace {
		self.startPoint = point
		self.previousPoint = point

		return context
	}

	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace {
		guard let previousPoint = self.previousPoint else { return context }

		let displacement = point - previousPoint
		context.selectionTool.selectedObjects.forEach { object in
			var object = object
			object.positionX.stream.value = object.positionX.stream.value + displacement.x
			object.positionY.stream.value = object.positionY.stream.value + displacement.y
		}

		self.previousPoint = point

		return context
	}

	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace {
		guard let startPoint = self.startPoint else { return context }

		self.changes.append((translation: point - startPoint, objects: context.selectionTool.selectedObjects))

		self.startPoint = nil
		self.previousPoint = nil
		return context
	}

	func commit() -> [HistoryItem] {
		let items: [HistoryItem] = self.changes.map { change in
			let (translation, objects) = change

			return HistoryItems.make(undoBlock: { workspace in
				objects.forEach { object in
					var object = object
					object.positionX.stream.value = object.positionX.value - translation.x
					object.positionY.stream.value = object.positionY.value - translation.y
				}
				return workspace
			}, redoBlock: { workspace in
				objects.forEach { object in
					var object = object
					object.positionX.stream.value = object.positionX.value + translation.x
					object.positionY.stream.value = object.positionY.value + translation.y
				}
				return workspace
			})
		}

		self.changes = []

		return items
	}
}