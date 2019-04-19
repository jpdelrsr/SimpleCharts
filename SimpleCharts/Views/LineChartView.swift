//
//  ChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartView: LineChartRenderer {
  

  /// Legend visibility (Default = True)
  open var legendVisibility = true
  
  /// Returns true if legend is visible
  open var isLegendVisible: Bool { get {return legendVisibility} }
  
  
  /// Legend Position (Default = bottom)
  open var legendPosition: legendPlacing = .bottom
  
  /// Custom legend x (When you select .custom on legend position then you can use this to set your own x values)
  open var customXlegend: Double = 0.0
  
  /// Custom legend y (When you select .custom on legend position then you can use this to set your own y values)
  open var customYlegend: Double = 0.0
  
  
  /// Enables the axis label customisation, if it is false then the max value of the data set will be taken and multiplied by 20% (Default = false)
  open var enableAxisCustomisation = false
  

  /// Graph off set on the left (Default = 31)
  open var offSetLeft:Double = 31.0
  
  /// Graph off set on the right (Default = 31)
  open var offSetRight:Double = 31.0
  
  /// Graph off set on the bottom (Default = 62)
  open var offSetBottom:Double = 62.0
  
  /// Graph off set on the top (Default = 20)
  open var offSetTop:Double = 20.0
  
  
  /// An instance of the xAxis to provide customisation through this
  open var xAxis:xAxisConfiguration = xAxisConfiguration()
  
  /// An instance of the yAxis to provide customisation through this
  open var yAxis:yAxisConfiguration = yAxisConfiguration()
  
  /// Line type
  open var enableBezierCurve = true
  
  
  /// Activate animation
  open var enableAnimation = true
  
  
  
  open var touchPosition = CGPoint(x: 0, y: 0)
  
  public var data = LineChartDataSet(dataset: [LineChartData(dataset: [0], datasetName: "Test")])
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func layoutSubviews() {
    let scale = 70.0/31.0
    
    if UIDevice.current.orientation.isLandscape {
      drawAnimatedLine(landscapePadding: scale)
    } else {
      drawAnimatedLine(landscapePadding: 1.0)
    }
  }
  

  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
    
    changeDefaultOffset(position: legendPosition)
    
    let scale = 70.0/31.0
    
      if UIDevice.current.orientation.isLandscape {
        renderLineGraph(context: context, landscapePadding: scale, currentOrientation: .landscape) //70
      } else {
        renderLineGraph(context: context, landscapePadding: 1.0, currentOrientation: .portrait) //31
      }
    
  }
  
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let position = touch.location(in: self)
      touchPosition = position
      setNeedsDisplay()
    }
  }
  
  
  override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let position = touch.location(in: self)
      touchPosition = position
      setNeedsDisplay()
    }
  }
  
  
  // Changes offset configuration based on the position of the legend
  // This is for the default configuration
  func changeDefaultOffset(position: legendPlacing) {
    switch position {
    case .bottom:
      offSetLeft = 31.0
      offSetRight = 31.0
      offSetBottom = 62.0
      offSetTop = 20.0
    case .top:
      offSetLeft = 31.0
      offSetRight = 31.0
      offSetBottom = 31.0
      offSetTop = 50.0
    case .right:
      offSetLeft = 31.0
      offSetRight = 70.0
      offSetBottom = 31.0
      offSetTop = 20.0
    case .left:
      offSetLeft = 70.0
      offSetRight = 31.0
      offSetBottom = 31.0
      offSetTop = 20.0
    case .custom:
      offSetLeft = 31.0
      offSetRight = 31.0
      offSetBottom = 62.0
      offSetTop = 20.0
    }
    
  }
  
  

  
  // Takes all the components and renders it together
  func renderLineGraph(context: CGContext, landscapePadding: Double, currentOrientation: orientation) {
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    var maxValue = 0.0
    var minValue = 0.0
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    let highlight = HighlightRenderer(frame: self.frame)
    
    let height = Double(frame.size.height)
    let width = Double(frame.size.width)
    
    let generalCalculationHandler = GeneralGraphCalculation(frameHeight: height, frameWidth: width, arrayCount: Double(arrayCount), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
    
    
    legend.legendPadding(currentOrientation: currentOrientation)
    
    let actualMax = helper.processMultipleArrays(array: convertedData)
    
    if enableAxisCustomisation == true {
        maxValue = yAxis.setYAxisMaximumValue
        minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    
    axisBase(context: context, offSet: offSet)
    yAxisGridlines(context: context, calc: generalCalculationHandler, gridlineCount: yAxis.setGridlineCount)
    xAxisGridlines(context: context, calc: generalCalculationHandler, gridlineCount: xAxis.setGridlineCount)
    drawLineGraph(context: context, array: convertedData, max: maxValue, data: data, landscapePadding: landscapePadding)
    highlight.highlightValues(context: context, array: convertedData, touchPoint: touchPosition, maxValue: maxValue, minValue: minValue, offSet: offSet)
    
    if yAxis.yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, minValue: minValue,axisInverse: yAxis.enableYAxisInverse, offSet: offSet, gridlineCount: yAxis.setGridlineCount)
    }
    
    if xAxis.xAxisVisibility == true {
      axis.xAxis(context: context, arrayCount: arrayCount, offSet: offSet, gridlineCount: xAxis.setGridlineCount)
    }
  
    if legendVisibility == true {
      legend.renderLineChartLegend(context: context, arrays: data.array, position: legendPosition, customX: customXlegend, customY: customYlegend)
    }
    
  }
  
  
  /// Renders a line graph
  func drawLineGraph(context: CGContext, array: [[Double]], max: Double, data: LineChartDataSet, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    
    for (i, value) in array.enumerated() {
      if enableBezierCurve == true {
        if enableAnimation == false {
          drawBezierCurve(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue,source: data.array[i], forCombined: false, offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
        }
        addBezierGradientPath(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue, source: data.array[i], offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
        drawCircles(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue, source: data.array[i], offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
      } else {
        if enableAnimation == false {
          drawLine(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue, source: data.array[i], offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
        }
        addGradientPath(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue, source: data.array[i], offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
        drawCircles(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue, source: data.array[i], offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
      }
    }
  }
  
  
  func drawAnimatedLine(landscapePadding: Double) {
    self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    let animationHandler = AnimationRenderer()
    let helper = HelperFunctions()
    let convertedData = helper.convert(chartData: data.array)
    
    var maxValue = 0.0
    var minValue = 0.0
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    let highlight = HighlightRenderer(frame: self.frame)
    
    let height = Double(frame.size.height)
    let width = Double(frame.size.width)
    
    
    let actualMax = helper.processMultipleArrays(array: convertedData)
    
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    
    
    animationHandler.drawAnimatedLineGraph(array: convertedData, maxValue: maxValue, minValue: minValue, offSet: offSet, height: height, width: width, mainLayer: layer)
    
  
    
  }
  
}



