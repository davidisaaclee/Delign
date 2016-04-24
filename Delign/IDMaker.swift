import Foundation
import UIKit

class IDMaker {
	static let sharedIDMaker = IDMaker()
	private var prefixCounts: [String: Int] = [:]

	func makeID(withPrefix prefix: String) -> String {
		if !self.prefixCounts.keys.contains(prefix) {
			self.prefixCounts[prefix] = 0
		}

		self.prefixCounts[prefix] = self.prefixCounts[prefix]! + 1
		return "\(prefix) \(self.prefixCounts[prefix]!)"
	}
}