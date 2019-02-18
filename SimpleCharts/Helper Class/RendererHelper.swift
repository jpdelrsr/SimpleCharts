//
//  RendererHelper.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 18/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


class RendererHelper {
  
  
  /// Takes in multiple arrays and determines the highest value within all arrays and returns it
  open func processMultipleArrays(array: [[Double]]) -> Double {
    var max = 0.0
    var newArray: [Double] = []
    
    for i in array {
      if let maxValue = i.max() {
        newArray.append(maxValue)
      }
    }
    
    if let newMax = newArray.max() {
      max = newMax
    }
    
    return max + 41
  }
  
  /// Takes in multiple arrays and determines the array with the highest count and returns that count
  open func findArrayCount(array: [[Double]]) -> Int {
    var arrayCount = 0
    var newArray: [Int] = []
    
    for i in array {
      newArray.append(i.count)
    }
    
    if let newMax = newArray.max() {
      arrayCount = newMax
    }
    
    return arrayCount
    
  }
  
  
  // Make this function clear
  open func calculatexValue(pointIncrement: Double, distanceIncrement: Int, sideMargin: Double) -> Double {
    var xValue = 0.0
    var marker = 0.0
    if pointIncrement > sideMargin {
      marker = pointIncrement - sideMargin
      xValue = Double((pointIncrement * (Double(distanceIncrement) + 1.0)) - marker)
    } else {
      marker = sideMargin - pointIncrement
      xValue = Double((pointIncrement * (Double(distanceIncrement) + 1.0)) + marker)
    }
    
    return xValue
  }
  
  /// Class for creating text labels
  open func createLabel(text: String, textFrame: CGRect) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let attributes: [NSAttributedString.Key : Any] = [
      .paragraphStyle: paragraphStyle,
      .font: UIFont.systemFont(ofSize: 8.0),
      .foregroundColor: UIColor.black
    ]
    
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    
    attributedString.draw(in: textFrame)
    
  }
  
}