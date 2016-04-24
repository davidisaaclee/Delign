import UIKit

class ViewController: UIViewController {
	var workspace: Workspace
	var drawing: Drawing?
	var overlay: CALayer?

	@IBOutlet weak var toolsetView: UICollectionView! {
		didSet {
			self.toolsetView.dataSource = self
			self.toolsetView.delegate = self
			(self.toolsetView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 80, height: 40)
		}
	}


	required init?(coder aDecoder: NSCoder) {
		self.workspace = Workspace(artboard: Artboards.makeEmpty(name: "My Artboard"),
		                           activeTool: CircleTool(),
		                           history: History(),
		                           viewportTransform: CGAffineTransformIdentity,
		                           viewportColor: UIColor.whiteColor().CGColor)

		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.drawing = self.workspace.artboard.root.updateDrawing(self.drawing)
		self.view.layer.addSublayer(self.drawing!.layer)
		self.view.layer.backgroundColor = self.workspace.viewportColor
	}

	
	// MARK: - Interaction

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let locationInView = touches.first!.locationInView(self.view)
		let locationInDocument = self.workspace.documentPointFromViewportPoint(locationInView)
		
		self.workspace = self.workspace.activeTool.began(atPoint: locationInDocument,
		                                                 context: self.workspace)
		self.updateDraw()
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let locationInView = touches.first!.locationInView(self.view)
		let locationInDocument = self.workspace.documentPointFromViewportPoint(locationInView)

		self.workspace = self.workspace.activeTool.moved(toPoint: locationInDocument,
		                                                 context: self.workspace)
		self.updateDraw()
	}

	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let locationInView = touches.first!.locationInView(self.view)
		let locationInDocument = self.workspace.documentPointFromViewportPoint(locationInView)

		self.workspace = self.workspace.activeTool.ended(atPoint: locationInDocument,
		                                                 context: self.workspace)
		self.updateDraw()

		self.workspace.activeTool.commit().forEach { self.workspace.history.pushItem($0) }
	}


	// MARK: - IBActions

	@IBAction func undo() {
		self.workspace = self.workspace.history.undo(self.workspace)
		self.updateDraw()
	}

	@IBAction func redo() {
		self.workspace = self.workspace.history.redo(self.workspace)
		self.updateDraw()
	}


	// MARK: - Update

	func updateDraw() {
		let updatedDrawing = self.workspace.artboard.root.updateDrawing(self.drawing)
		updatedDrawing.layer.transform = CATransform3DMakeAffineTransform(self.workspace.viewportTransform)
		self.addLayer(updatedDrawing.layer, toParent: self.view.layer, replacing: self.drawing?.layer)
		self.drawing = updatedDrawing

		let updatedOverlay = self.workspace.updateOverlay(self.overlay)
		self.addLayer(updatedOverlay, toParent: self.view.layer, replacing: self.overlay)
		self.overlay = updatedOverlay

		self.view.layer.backgroundColor = self.workspace.viewportColor
	}


	// MARK: - Helpers

	func addLayer(layer: CALayer, toParent parent: CALayer, replacing previousLayer: CALayer?) {
		if let previousLayer = previousLayer {
			parent.replaceSublayer(previousLayer, with: layer)
		} else {
			parent.addSublayer(layer)
		}
	}
}

extension ViewController: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		self.workspace.activeTool = Kit.tools[indexPath.item].init()
	}
}

extension ViewController: UICollectionViewDataSource {
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Kit.tools.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ToolCell", forIndexPath: indexPath)
		guard let toolCell = cell as? ToolCell else { return cell }

		toolCell.label.text = Kit.tools[indexPath.item].name

		return toolCell
	}
}


class ToolCell: UICollectionViewCell {
	@IBOutlet weak var label: UILabel!

	override func prepareForReuse() {
		self.label.text = nil
	}
}