//
//  SidebarView.swift
//  iGlance
//
//  Created by Dominik on 16.12.19.
//  Copyright © 2019 D0miH. All rights reserved.
//

import Cocoa

class SidebarView: NSView {

    // prevent dragging of the window
    override var mouseDownCanMoveWindow: Bool {
        return false
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // set the background color of the sidebar
        ThemeManager.currentTheme().sidebarColor.setFill()
        dirtyRect.fill()
    }
}
