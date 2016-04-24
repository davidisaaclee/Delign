import Foundation
import UIKit

struct Properties {
	struct PropertyImpl: Property {
		var name: String
		var stream: Stream
	}

	static func make(name name: String, value: CGFloat) -> Property {
		return PropertyImpl(name: name, stream: Streams.make(initialValue: value))
	}
}