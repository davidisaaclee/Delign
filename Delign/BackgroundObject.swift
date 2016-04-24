import Foundation
import UIKit

class BackgroundObject: Group, Stylable {
	var styles: [Style] = []

	override func drawSelf() -> CALayer {
		// TODO: Use styles
		return CALayer()
	}
}