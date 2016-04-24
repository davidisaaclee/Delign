import Foundation
import UIKit

extension UIBezierPath {
	convenience init(points: [CGPoint]) {
		self.init()

		guard points.count > 0 else { return }

		self.moveToPoint(points.first!)

		points.forEach { point in
			self.addLineToPoint(point)
		}
	}
}