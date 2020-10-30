//
//  utils.swift
//  blah
//
//  Created by hrbrmstr on 10/28/20.
//

import Foundation

extension Double {
  func rescale(from input: ClosedRange<Self>, to output: ClosedRange<Self>) -> Self {
    let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
    let y = (input.upperBound - input.lowerBound)
    return x / y + output.lowerBound
  }
}

extension FloatingPoint {
  func rescale(from input: ClosedRange<Self>, to output: ClosedRange<Self>) -> Self {
    let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
    let y = (input.upperBound - input.lowerBound)
    return x / y + output.lowerBound
  }
}

extension BinaryInteger {
  func rescale(from input: ClosedRange<Self>, to output: ClosedRange<Self>) -> Self {
    let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
    let y = (input.upperBound - input.lowerBound)
    return x / y + output.lowerBound
  }
}
