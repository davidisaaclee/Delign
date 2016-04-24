//
//  HistoryItems.swift
//  Delign
//
//  Created by David Lee on 4/23/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

struct HistoryItems {
	struct HistoryItemImpl: HistoryItem {
		let undoBlock: Workspace -> Workspace
		let redoBlock: Workspace -> Workspace

		init(undoBlock: Workspace -> Workspace, redoBlock: Workspace -> Workspace) {
			self.undoBlock = undoBlock
			self.redoBlock = redoBlock
		}

		func undo(context: Workspace) -> Workspace {
			return self.undoBlock(context)
		}

		func redo(context: Workspace) -> Workspace {
			return self.redoBlock(context)
		}
	}

	static func make(undoBlock undoBlock: Workspace -> Workspace, redoBlock: Workspace -> Workspace) -> HistoryItem {
		return HistoryItemImpl(undoBlock: undoBlock, redoBlock: redoBlock)
	}
}