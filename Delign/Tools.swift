import Foundation
import UIKit

protocol Tool: class {
	static var name: String { get }

	init()

	func began(atPoint point: CGPoint, context: Workspace) -> Workspace
	func moved(toPoint point: CGPoint, context: Workspace) -> Workspace
	func ended(atPoint point: CGPoint, context: Workspace) -> Workspace

	func commit() -> [HistoryItem]
}