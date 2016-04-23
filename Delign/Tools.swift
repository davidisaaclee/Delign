import Foundation
import UIKit

protocol Tool {
	func began(atPoint point: CGPoint, context: Workspace) -> Workspace
	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace
	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace

//	func commit() -> [HistoryItem]
}

protocol HistoryItem {
	func undo(context: Workspace) -> Workspace
	func redo(context: Workspace) -> Workspace
}

struct History {
	private var items: [HistoryItem] = []

	/// Points to the most recently "done" item.
	private var cursor: Int?

	var canUndo: Bool {
		guard let cursor = self.cursor else { return false }
		return self.items.indices.contains(cursor)
	}

	var canRedo: Bool {
		guard let cursor = self.cursor else { return false }
		return self.items.indices.contains(cursor.successor())
	}

	mutating func pushItem(item: HistoryItem) {
		if let cursor = self.cursor {
			self.items.removeRange(cursor.successor() ... self.items.endIndex)
		}

		self.items.append(item)
		self.cursor = self.cursor?.successor() ?? 0
	}

	mutating func undo(context: Workspace) -> Workspace {
		guard self.canUndo else { return context }
		guard let cursor = self.cursor else { return context }

		let contextʹ = self.items[cursor].undo(context)
		self.cursor = self.items.indices.contains(cursor.predecessor()) ? nil : cursor.predecessor()
		return contextʹ
	}

	mutating func redo(context: Workspace) -> Workspace {
		guard self.canRedo else { return context }
		guard let cursor = self.cursor else { return context }

		let cursorʹ = cursor.successor()
		let contextʹ = self.items[cursorʹ].redo(context)
		self.cursor = cursorʹ
		return contextʹ
	}
}