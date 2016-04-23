import Foundation
import UIKit

class CircleTool: Tool {
	func began(atPoint point: CGPoint, context: Workspace) -> Workspace {
		print("Began")
		return context
	}

	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace {
		print("Moved")
		return context
	}

	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace {
		print("Ended")
		return context
	}
}