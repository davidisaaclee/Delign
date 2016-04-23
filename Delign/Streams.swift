import CoreGraphics

/// A continuous stream of data.
protocol Stream {
	var value: CGFloat { get set }
}


class LookupStreamTable {
	private var streamIDToValue: [LookupStream.ID: CGFloat] = [:]
	
	func registerStream(stream: LookupStream, initialValue: CGFloat) {
		self.streamIDToValue[stream.id] = initialValue
	}
	
	subscript(streamID: LookupStream.ID) -> CGFloat {
		get {
			return self.streamIDToValue[streamID]!
		}
		set {
			self.streamIDToValue[streamID] = newValue
		}
	}
}

struct LookupStream: Stream {
	typealias ID = String
	
	let id: LookupStream.ID
	unowned let table: LookupStreamTable
	
	init(id: LookupStream.ID, table: LookupStreamTable) {
		self.id = id
		self.table = table
	}
	
	var value: CGFloat {
		set {
			self.table[self.id] = newValue
		}
		get {
			return self.table[self.id]
		}
	}
}

class Streams {
	private static let table = LookupStreamTable()
	
	private static var counter: Int = 0
	
	static func make(initialValue initialValue: CGFloat) -> Stream {
		let id = "stream-\(self.counter)"
		self.counter += 1

		let stream = LookupStream(id: id, table: self.table)
		self.table.registerStream(stream, initialValue: initialValue)
		return stream
	}
}