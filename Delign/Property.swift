import Foundation
import UIKit

/// A value which affects an object, which can be the target of a driver.
protocol Property: Named {
	var name: String { get }

	/// The value of this property as a stream.
	// TODO: Not certain this should be settable.
	var stream: Stream { get set }
}

extension Property {
	var value: CGFloat {
		return self.stream.value
	}
}