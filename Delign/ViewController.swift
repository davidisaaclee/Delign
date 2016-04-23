import UIKit

class ViewController: UIViewController {
	var artboard: Artboard!
	var drawing: Drawing?

	override func viewDidLoad() {
		super.viewDidLoad()

		let positionX = Properties.make(name: "posX", value: 0)
		let positionY = Properties.make(name: "posY", value: 0)
		var rootGroup = Group(name: "root", children: [], positionX: positionX, positionY: positionY)

		rootGroup.children = (0 ..< 4).map { groupIndex -> Drawable in
			let children = (0 ..< 10).map { (index: Int) -> Drawable in
				let positionX = Properties.make(name: "posX", value: CGFloat(index + groupIndex * 10) * 10)
				let positionY = Properties.make(name: "posY", value: CGFloat(index + groupIndex * 10) * 10)
				let radius = Properties.make(name: "radius", value: 100)

				return CirclePrimitive(name: "circle", children: [], positionX: positionX, positionY: positionY, radius: radius)
			}

			let positionX = Properties.make(name: "posX", value: CGFloat(groupIndex * 10))
			let positionY = Properties.make(name: "posY", value: CGFloat(groupIndex * 10))

			let group = Group(name: "group-\(groupIndex)",
												children: children,
			                  positionX: positionX,
			                  positionY: positionY)

			rootGroup.children.append(group)
			return group
		}

		self.artboard = Artboards.make(name: "My Artboard", root: rootGroup)
		self.drawing = self.artboard.root.updateDrawing(self.drawing)

		self.view.layer.addSublayer(self.drawing!.layer)
	}


	func updateDraw() {
		let updatedDrawing = self.artboard.root.updateDrawing(self.drawing)
		if let previousLayer = self.drawing?.layer {
			self.view.layer.replaceSublayer(previousLayer, with: updatedDrawing.layer)
		} else {
			self.view.layer.addSublayer(updatedDrawing.layer)
		}
		self.drawing = updatedDrawing
	}
}

