import Foundation

/// Holds any state necessary for an application session.
struct Workspace {
	var artboard: Artboard
	var activeTool: Tool
	var history: History
}