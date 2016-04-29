import UIKit

class ViewController: UIViewController {
	var workspace: Workspace
	var drawing: Drawing?
	var overlay: CALayer?

	@IBOutlet weak var canvasView: UIView!
	@IBOutlet weak var objectListView: UITableView! {
		didSet {
			self.objectListView.dataSource = self
		}
	}

	var canvas: CALayer {
		return self.canvasView.layer
	}

	@IBOutlet weak var toolsetView: UICollectionView! {
		didSet {
			self.toolsetView.dataSource = self
			self.toolsetView.delegate = self
			if let layout = self.toolsetView.collectionViewLayout as? UICollectionViewFlowLayout {
				layout.itemSize = CGSize(width: 80, height: 40)
			}
		}
	}


	required init?(coder aDecoder: NSCoder) {
		self.workspace = Workspace(artboard: Artboards.makeEmpty(name: "My Artboard"),
		                           activeTool: CircleTool())

		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.drawing = self.workspace.artboard.root.updateDrawing(self.drawing)
		self.canvas.addSublayer(self.drawing!.layer)
		self.canvas.backgroundColor = self.workspace.viewportColor
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

	private var poppedTool: Tool?

	@IBAction func enableTranslateTool() {
		self.poppedTool = self.workspace.activeTool
		self.workspace.activeTool = TransformTool()
	}

	@IBAction func enableSelectTool() {
		self.poppedTool = self.workspace.activeTool
		self.workspace.activeTool = self.workspace.selectionTool
	}

	@IBAction func enableNavigateTool() {
		self.poppedTool = self.workspace.activeTool
		self.workspace.activeTool = NavigationTool()
	}

	@IBAction func disableTranslateTool() {
		self.workspace.activeTool = self.poppedTool!
	}

	@IBAction func disableSelectTool() {
		self.workspace.activeTool = self.poppedTool!
	}

	@IBAction func disableNavigateTool() {
		self.workspace.activeTool = self.poppedTool!
	}


	// MARK: - Update

	func updateDraw() {
		let updatedDrawing = self.workspace.artboard.root.updateDrawing(self.drawing)
		self.addLayer(updatedDrawing.layer, toParent: self.canvas, replacing: self.drawing?.layer)
		self.drawing = updatedDrawing

		let updatedOverlay = self.workspace.updateOverlay(self.overlay)
		self.addLayer(updatedOverlay, toParent: self.canvas, replacing: self.overlay)
		self.overlay = updatedOverlay

		updatedDrawing.layer.transform = CATransform3DMakeAffineTransform(self.workspace.viewportTransform)
		updatedOverlay.transform = CATransform3DMakeAffineTransform(self.workspace.viewportTransform)
		self.canvas.backgroundColor = self.workspace.viewportColor

		self.objectListView.reloadData()
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
		self.workspace.activeTool = self.workspace.kit.tools[indexPath.item]
	}
}

extension ViewController: UICollectionViewDataSource {
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.workspace.kit.tools.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ToolCell", forIndexPath: indexPath)
		guard let toolCell = cell as? ToolCell else { return cell }

		toolCell.label.text = self.workspace.kit.tools[indexPath.item].dynamicType.name

		return toolCell
	}
}

extension ViewController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.workspace.artboard.allObjects.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let dequeuedCell = tableView.dequeueReusableCellWithIdentifier("ObjectListCell")
		let cell = (dequeuedCell as? ObjectListCell) ?? ObjectListCell()

		let key = self.workspace.artboard.allObjects.keys.sort()[indexPath.item]
		cell.label.text = self.workspace.artboard.allObjects[key]?.name

		return cell
	}
}


class ToolCell: UICollectionViewCell {
	@IBOutlet weak var label: UILabel!

	override func prepareForReuse() {
		self.label.text = nil
	}
}

class ObjectListCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
}