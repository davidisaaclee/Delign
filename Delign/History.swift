import Foundation

protocol HistoryItem {
	func undo(context: Workspace) -> Workspace
	func redo(context: Workspace) -> Workspace
}

class History {
	private var items: [HistoryItem] = []

	/// Points to the most recently "done" item.
	private var cursor: Int?

	var canUndo: Bool {
		guard let cursor = self.cursor else { return false }
		return self.items.indices.contains(cursor)
	}

	var canRedo: Bool {
		let nextCursor = self.cursor?.successor() ?? 0
		return self.items.indices.contains(nextCursor)
	}

	func pushItem(item: HistoryItem) {
		if let cursor = self.cursor {
			if cursor.successor() < self.items.endIndex {
				self.items.removeRange(cursor.successor() ..< self.items.endIndex)
			}
		}

		self.items.append(item)
		self.cursor = self.cursor?.successor() ?? 0
	}

	func undo(context: Workspace) -> Workspace {
		guard self.canUndo else { return context }
		guard let cursor = self.cursor else { return context }

		let contextʹ = self.items[cursor].undo(context)
		self.cursor = self.items.indices.contains(cursor.predecessor()) ? cursor.predecessor() : nil

		return contextʹ
	}

	func redo(context: Workspace) -> Workspace {
		guard self.canRedo else { return context }

		let cursorʹ = self.cursor?.successor() ?? 0
		let contextʹ = self.items[cursorʹ].redo(context)
		self.cursor = cursorʹ
		return contextʹ
	}
}