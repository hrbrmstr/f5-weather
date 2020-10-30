import Foundation
import SwiftUI
import os

// min and max range for forecast temp line size
let RANGE_MIN: Double = 0
let RANGE_MAX: Double = 300

// height for each row element component
let HEIGHT: CGFloat = 20

// fixed view width and min height of the view
let VIEW_WIDTH: CGFloat = 548
let VIEW_MIN_HEIGHT: CGFloat = 256

// min & max possible rows from forecast and the height of each row (including padding)
let MIN_ROWS: Int = 10
let MAX_ROWS: Int = 20
let ROW_HEIGHT: Int = 30

// width of a char (not great to hardcode this)
let CHAR_WIDTH: CGFloat = 12

// we will log some things
let logger = Logger()

// assoc array to map conditions to SF Symbols
let conditionToSymbol: [String: String] = [
  "Rain" : "cloud.rain.fill",
  "Snow" : "cloud.snow.fill",
  "Clear" : "sun.max.fill"
]

// assoc array to map conditions to the highlight color they should have
let conditionToSymbolColor: [String: Color] = [
  "Rain" : Color.blue,
  "Snow" : Color.blue,
  "Clear" : Color.yellow
]
