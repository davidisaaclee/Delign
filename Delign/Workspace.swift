import Foundation
import UIKit

/// Holds any state necessary for an application session.
struct Workspace {
	var artboard: Artboard
	var activeTool: Tool
	var history: History

	var viewportTransform: CGAffineTransform

	func viewportPointFromDocumentPoint(point: CGPoint) -> CGPoint {
		let inverse = CGAffineTransformInvert(self.viewportTransform)
		return CGPointApplyAffineTransform(point, inverse)
	}

	func documentPointFromViewportPoint(point: CGPoint) -> CGPoint {
		return CGPointApplyAffineTransform(point, self.viewportTransform)
	}
}