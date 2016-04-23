import UIKit

class ViewController: UIViewController {
	var workspace: Workspace
	var drawing: Drawing?

	required init?(coder aDecoder: NSCoder) {
		let rootGroup = Group(name: "root",
		                      children: [:],
		                      positionX: Properties.make(name: "posX", value: 0),
		                      positionY: Properties.make(name: "posY", value: 0))

		self.workspace = Workspace(artboard: Artboards.make(name: "My Artboard", root: rootGroup),
		                           activeTool: CircleTool(),
		                           history: History())

		super.init(coder: aDecoder)
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.workspace = self.workspace.activeTool.began(atPoint: touches.first!.locationInView(self.view),
		                                                 context: self.workspace)
		self.updateDraw()
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.workspace = self.workspace.activeTool.moved(toPoint: touches.first!.locationInView(self.view),
		                                                 context: self.workspace)
		self.updateDraw()
	}

	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.workspace = self.workspace.activeTool.ended(atPoint: touches.first!.locationInView(self.view),
		                                                 context: self.workspace)
		self.updateDraw()

		self.workspace.activeTool.commit().forEach { self.workspace.history.pushItem($0) }
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.drawing = self.workspace.artboard.root.updateDrawing(self.drawing)
		self.view.layer.addSublayer(self.drawing!.layer)
	}

	@IBAction func undo() {
		self.workspace = self.workspace.history.undo(self.workspace)
		self.updateDraw()
	}

	@IBAction func redo() {
		self.workspace = self.workspace.history.redo(self.workspace)
		self.updateDraw()
	}

	func updateDraw() {
		let updatedDrawing = self.workspace.artboard.root.updateDrawing(self.drawing)
		if let previousLayer = self.drawing?.layer {
			self.view.layer.replaceSublayer(previousLayer, with: updatedDrawing.layer)
		} else {
			self.view.layer.addSublayer(updatedDrawing.layer)
		}
		self.drawing = updatedDrawing
	}
}