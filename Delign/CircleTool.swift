import Foundation
import UIKit

final class CircleTool: Tool {
	static let name: String = "Circle"

	private var startPoint: CGPoint?
	private var activeCircleID: String?

	private var changes: [Object] = []

	required init() {}

	func began(atPoint point: CGPoint, context: Workspace) -> Workspace {
		let newCircle = CirclePrimitive(name: "Circle",
		                                children: [:],
		                                positionX: Properties.make(name: "posX", value: point.x),
		                                positionY: Properties.make(name: "posY", value: point.y),
		                                radius: Properties.make(name: "radius", value: 0))
		self.activeCircleID = newCircle.id
		self.startPoint = point

		let contextʹ = context
		contextʹ.artboard.addObject(newCircle, parent: nil)
		return contextʹ
	}

	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace {
		return self.updateWithPoint(point, context: context)
	}

	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace {
		guard let activeCircleID = self.activeCircleID else { return context }

		let updatedWorkspace = self.updateWithPoint(point, context: context)

		if let child = updatedWorkspace.artboard.root.children[activeCircleID] {
			self.changes.append(child)
		}

		return updatedWorkspace
	}

	func commit() -> [HistoryItem] {
		let items: [HistoryItem] = self.changes.map { addedObject in
			HistoryItems.make(undoBlock: { workspace in
				let workspaceʹ = workspace
				workspaceʹ.artboard.removeObject(addedObject)
				return workspaceʹ
			}, redoBlock: { workspace in
				let workspaceʹ = workspace
				workspaceʹ.artboard.addObject(addedObject, parent: nil)
				return workspaceʹ
			})
		}

		self.changes = []

		return items
	}

	private func updateWithPoint(point: CGPoint, context: Workspace) -> Workspace {
		guard let activeCircleID = self.activeCircleID else {
			return context
		}
		guard let startPoint = self.startPoint else {
			return context
		}
		guard let child = context.artboard.root.children[activeCircleID] else {
			return context
		}
		guard let circle = child as? CirclePrimitive else {
			return context
		}

		let center = CGPoint(x: (startPoint.x + point.x) / 2, y: (startPoint.y + point.y) / 2)

		circle.positionX.stream.value = center.x
		circle.positionY.stream.value = center.y
		circle.radius.stream.value = min(center.x - startPoint.x, center.y - startPoint.y)

		return context
	}
}