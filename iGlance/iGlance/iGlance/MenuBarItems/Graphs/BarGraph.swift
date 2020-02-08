//
//  BarGraph.swift
//  iGlance
//
//  Created by Dominik on 04.02.20.
//  Copyright © 2020 D0miH. All rights reserved.
//

import Cocoa
import CocoaLumberjack

struct Key: Hashable {
    let value: Double
    let isDarkTheme: Bool
}

class BarGraph: Graph {
    let maxValue: Double

    private var imageCache: [Key: (image: NSImage, color: NSColor)] = [Key: (image: NSImage, color: NSColor)]()

    /**
     * Initializer of the BarGraph class.
     *
     * - Parameter maxValue: The maximum value that is reached when the bar is at 100%
     */
    init(maxValue: Double) {
        // set the maximum value for the bar
        self.maxValue = maxValue

        // call the super initializer
        super.init()

        // set the width of the bar graph
        self.imageSize.width = 9.0
    }

    /**
     * Returns the bar graph image for the menu bar.
     */
    func getImage(currentValue: Double, graphColor: NSColor) -> NSImage {
        // check whether we need to redraw the graph
        let key = Key(value: currentValue, isDarkTheme: ThemeManager.isDarkTheme())
        if imageCache[key] != nil && imageCache[key]!.color == graphColor {
            return imageCache[key]!.image
        }

        // create a new image with the same size as the border image
        var image = NSImage(size: self.imageSize)

        // first draw the bar to draw over the sharp corners of the bar
        self.drawBarGraph(image: &image, currentValue: currentValue, barColor: graphColor)

        // draw the border of the graph
        self.drawBorder(image: &image)

        // add the image and its color to the cache
        imageCache[key] = (image, graphColor)

        DDLogInfo("Cached bar graph for value (\(currentValue)) and color (\(graphColor.toHex()))")

        return image
    }

    /**
     * Takes an image and draws the bar on the given image
     */
    private func drawBarGraph( image: inout NSImage, currentValue: Double, barColor: NSColor) {
        // lock the focus on the image in order to draw on it
        image.lockFocus()

        // get the maximum height of the bar.
        // Keep in mind that the border of the graph is 1 pixel wide. However the 2x picture is used which is why we subtract 2 / 2 = 1 pixel
        let maxBarHeight = Double(self.imageSize.height - 1)

        // get the width of the bar
        let barWidth = Double(self.imageSize.width - 1)
        // get the height of the bar
        let barHeight = Double((maxBarHeight / self.maxValue) * currentValue)

        // set the bar color as a fill color
        barColor.setFill()

        // create the bar as a rectangle
        // 1 / 2 = 0.5 pixel offset since the 2x image is used and the border is 1 pixel wide
        let bar = NSRect(x: 0.5, y: 0.5, width: barWidth, height: barHeight)
        bar.fill()

        // set the current fill color to clear
        NSColor.clear.setFill()

        // unlock the focus of the image
        image.unlockFocus()
    }
}
