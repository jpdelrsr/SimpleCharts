//
//  LineGraphCalculation.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 01/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineGraphCalculation {
  
  private var array: [Double]
  private var arrayCount: Int
  private var maxValue: Double
  private var initialValue: Double
  private var frameWidth: Double
  private var frameHeight: Double
  
  
  /// Initialize this when using the line graph point calculation
  required public init(array: [Double], maxValue: Double, initialValue: Double, frameWidth: Double, frameHeight: Double) {
    self.array = array
    self.arrayCount = 0
    self.maxValue = maxValue
    self.initialValue = initialValue
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
  }
  
  required public init(arrayCount: Int, maxValue: Double, initialValue: Double, frameWidth: Double, frameHeight: Double) {
    self.array = []
    self.arrayCount = arrayCount
    self.maxValue = maxValue
    self.initialValue = initialValue
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
  }
  
  
  func ylineGraphStartPoint() -> Double {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    var yValue = 0.0
    if let firstValue = array.first {
      yValue = yAxisPadding - ((yAxisPadding / maxValue) * firstValue)
    }
    return yValue
  }
  
  
  func ylineGraphPoint(value: Double) -> Double {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let yValue = yAxisPadding - ((yAxisPadding / maxValue) * value)
    return yValue
  }
  
  func xlineGraphStartPoint() -> Double {
    let arrayCount = Double(array.count)
    let spaceLeft = frameWidth - (initialValue * 2)
    let increment = spaceLeft / (arrayCount - 1)
    
    let xValue = initialValue + (increment * Double(0))
    
    return xValue
  }
  
  func xlineGraphPoint(i: Int) -> Double {
    let arrayCount = Double(array.count)
    let spaceLeft = frameWidth - (initialValue * 2)
    let increment = spaceLeft / (arrayCount - 1)
    let xValue = initialValue + (increment * Double(i))
    
    return xValue
  }
  
  
  
  

  func xAxisLabelxValue(i: Int) -> Double {
    let spaceLeft = (frameWidth - 8) - (initialValue * 2)
    var increment = 0.0
    let count = Double(arrayCount)
    
    if count < 6 {
      increment = spaceLeft / (count - 1)
    } else {
      increment = spaceLeft / 6
    }
    
    let xValue = initialValue + (increment * Double(i))
    
    return xValue
    
  }
  
  func xAxisLabelyValue() -> Double {
    let yValue = (frameHeight - 62) + 10
    
    return yValue
  }
  
  func xAxisLabelText(i: Int) -> String {
    var scale = 0
    
    if arrayCount < 6 {
      scale = arrayCount / (arrayCount - 1)
    } else {
      scale = arrayCount / 6
    }
    
    let text = String(scale * i)
    
    return text
    
  }
  
  
  func yAxisLabelxValue() -> Double {
    let xValue = initialValue - 10
    
    return xValue
  }
  
  
  func yAxisLabelyValue(i: Int) -> Double {
    let frameScale = (frameHeight - currentFrame.distanceFromBottom - 10) / Double(currentFrame.yAxisGridlinesCount)
    let actualValue = frameScale * Double(i)

    let yValue = (frameHeight - 67) - actualValue
    
    return yValue
    
  }
  
  func yAxisLabelText(i: Int) -> String {
    let actualDataScale = Int(maxValue / 6)
    
    let text = String(i * actualDataScale)
    
    return text
  }
  
  
  
}
