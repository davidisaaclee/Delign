import Foundation
import UIKit

/// Holds any state necessary for an application session.
struct Workspace {
	var artboard: Artboard
	var activeTool: Tool
	var history: History

	var viewportTransform: CGAffineTransform
	var viewportColor: CGColor

	func viewportPointFromDocumentPoint(point: CGPoint) -> CGPoint {
		return CGPointApplyAffineTransform(point, self.viewportTransform)
	}

	func documentPointFromViewportPoint(point: CGPoint) -> CGPoint {
		let inverse = CGAffineTransformInvert(self.viewportTransform)
		return CGPointApplyAffineTransform(point, inverse)
	}


	// TODO: Not certain this should be here.
	func updateOverlay(overlay: CALayer?) -> CALayer {
		return self.activeTool.drawOverlay(self)
	}
}