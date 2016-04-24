import Foundation
import UIKit

/// Holds any state necessary for an application session.
struct Workspace {
	var kit: Kit

	var artboard: Artboard
	var activeTool: Tool
	var history: History

	var viewportTransform: CGAffineTransform
	var viewportColor: CGColor

	var selectionTool: SelectionTool

	init(artboard: Artboard,
	     activeTool: Tool,
	     history: History = History(),
	     viewportTransform: CGAffineTransform = CGAffineTransformIdentity,
	     viewportColor: CGColor = UIColor.whiteColor().CGColor) {
		self.artboard = artboard
		self.activeTool = activeTool
		self.history = history
		self.viewportTransform = viewportTransform
		self.viewportColor = viewportColor

		self.selectionTool = SelectionTool()

		self.kit = Kit(tools: [
			self.selectionTool,
			NavigationTool(),
			PathTool(),
			CircleTool(),
			TransformTool()
		])
	}

	func viewportPointFromDocumentPoint(point: CGPoint) -> CGPoint {
		return CGPointApplyAffineTransform(point, self.viewportTransform)
	}

	func documentPointFromViewportPoint(point: CGPoint) -> CGPoint {
		let inverse = CGAffineTransformInvert(self.viewportTransform)
		return CGPointApplyAffineTransform(point, inverse)
	}


	// TODO: Not certain this should be here.
	func updateOverlay(overlay: CALayer?) -> CALayer {
		let activeToolOverlay = self.activeTool.drawOverlay(self)
		if self.activeTool is SelectionTool {
			return activeToolOverlay
		} else {
			let selectionOverlay = self.selectionTool.drawOverlay(self)

			let layer = CALayer()
			layer.addSublayer(selectionOverlay)
			layer.addSublayer(activeToolOverlay)
			return layer
		}
	}
}