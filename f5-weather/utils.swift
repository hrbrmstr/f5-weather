//
//  utils.swift
//  blah
//
//  Created by hrbrmstr on 10/28/20.
//

import Foundation
import SwiftUI

extension Double {
func rescale(from domain: ClosedRange<Self>, to range: ClosedRange<Self>) -> Self {
    let x = (range.upperBound - range.lowerBound) * (self - domain.lowerBound)
    let y = (domain.upperBound - domain.lowerBound)
    return x / y + range.lowerBound
  }
}

extension FloatingPoint {
  func rescale(from domain: ClosedRange<Self>, to range: ClosedRange<Self>) -> Self {
    let x = (range.upperBound - range.lowerBound) * (self - domain.lowerBound)
    let y = (domain.upperBound - domain.lowerBound)
    return x / y + range.lowerBound
  }
}

extension BinaryInteger {
  func rescale(from domain: ClosedRange<Self>, to range: ClosedRange<Self>) -> Self {
    let x = (range.upperBound - range.lowerBound) * (self - domain.lowerBound)
    let y = (domain.upperBound - domain.lowerBound)
    return x / y + range.lowerBound
  }
}

public extension Color {

    #if os(macOS)
    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
    static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
    #else
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    #endif
}
