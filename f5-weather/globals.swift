//
//  globals.swift
//  blah
//
//  Created by hrbrmstr on 10/28/20.
//

import Foundation
import SwiftUI
import os

let DOMAIN_MIN: Double = 0
let DOMAIN_MAX: Double = 300
let HEIGHT: CGFloat = 20

let logger = Logger()

let etab: [String: String] = [
  "Rain" : "cloud.rain.fill",
  "Snow" : "cloud.snow.fill",
  "Clear" : "sun.max.fill"
]

let ecol: [String: Color] = [
  "Rain" : Color.blue,
  "Snow" : Color.blue,
  "Clear" : Color.yellow
]
