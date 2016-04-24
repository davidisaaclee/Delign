import Foundation
import UIKit
import VectorKit

final class PathTool: Tool {
	static let name: String = "Path"

	private var changes: [PathPrimitive] = []

	private var workingPath: PathPrimitive?

	init() {}

	func began(atPoint point: CGPoint, context: Workspace) -> Workspace {
		let workingPath = PathPrimitive(name: "Path",
		                                children: [:],
		                                positionX: Properties.make(name: "posX", value: point.x),
		                                positionY: Properties.make(name: "posY", value: point.y),
		                                points: [CGPoint.zero])
		context.artboard.addObject(workingPath, parent: nil)

		self.workingPath = workingPath

		return context
	}

	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace {
		guard let workingPath = self.workingPath else { return context }

		let relativePoint = point - CGPoint(x: workingPath.positionX.value, y: workingPath.positionY.value)
		workingPath.points.append(relativePoint)

		return context
	}

	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace {
		guard let workingPath = self.workingPath else { return context }

		self.changes.append(workingPath)

		self.workingPath = nil

		return context
	}

	func commit() -> [HistoryItem] {
		let items: [HistoryItem] = self.changes.map { path in
			HistoryItems.make(undoBlock: { workspace in
				workspace.artboard.removeObject(path)
				return workspace
			}, redoBlock: { workspace in
				workspace.artboard.addObject(path, parent: nil)
				return workspace
			})
		}

		self.changes = []

		return items
	}
}