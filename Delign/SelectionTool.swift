import Foundation
import UIKit

class SelectionTool: Tool {
	static let name: String = "Select"

	required init() {}

	func began(atPoint point: CGPoint, context: Workspace) -> Workspace {
		return context
	}

	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace {
		return context
	}

	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace {
		return context
	}

	func commit() -> [HistoryItem] {
		return []
	}
}