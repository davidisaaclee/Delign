import Foundation
import UIKit

class SelectionTool: Tool {
	static let name: String = "Select"

	required init() {}

	func began(atPoint point: CGPoint, context: Workspace) -> Workspace {
		var contextʹ = context

		return contextʹ
	}

	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace {
		var contextʹ = context

		return contextʹ
	}

	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace {
		var contextʹ = context

		return contextʹ
	}

	func commit() -> [HistoryItem] {
		return []
	}
}