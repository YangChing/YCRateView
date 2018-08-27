//
//  RateStar.swift
//  YCRateView
//
//  Created by 馮仰靚 on 12/09/2017.
//  Copyright © 2017 larvata.YC. All rights reserved.
//

import UIKit

protocol YCRateViewCustomizable {
  func rateViewChanged(slider: CustomSlider, frontImgView: UIImageView, backImgView: UIImageView, text: UILabel)
  func rateViewDidLoad(slider: CustomSlider, frontImgView: UIImageView, backImgView: UIImageView, text: UILabel)
}

extension YCRateViewCustomizable {
  func rateViewChanged(slider: CustomSlider, frontImgView: UIImageView, backImgView: UIImageView, text: UILabel) {}
  func rateViewDidLoad(slider: CustomSlider, frontImgView: UIImageView, backImgView: UIImageView, text: UILabel) {}
}

@IBDesignable
public class YCRateView: UIView, YCRateViewCustomizable {

  public class ConfigSlider {
    var maxValue: Float = 5
    var minValue: Float = 0
    var intervalValue: Float = 0.5
  }

  public var beta: CGFloat?


  private var configSlider = ConfigSlider()
  private var frontImageView = UIImageView()
  private var backImageView = UIImageView()
  private var slider: CustomSlider!
  private var showNumberLabel = UILabel()
  private var rate: Int?

  @IBInspectable var frontImage: UIImage? {
    didSet {
      frontImageView.image = frontImage
    }
  }
  @IBInspectable var backImage: UIImage? {
    didSet {
      backImageView.image = backImage
    }
  }

  @IBInspectable var text: String? {
    didSet {
      showNumberLabel.text = text
    }
  }

  @IBInspectable var maxValue: Float {
    set {
      self.configSlider.maxValue = newValue
    }
    get {
      return self.configSlider.maxValue
    }
  }

  @IBInspectable var minValue: Float {
    set {
      self.configSlider.minValue = newValue
    }
    get {
      return self.configSlider.minValue
    }
  }

  @IBInspectable var intervalValue: Float {
    set {
      self.configSlider.intervalValue = newValue
    }
    get {
      return self.configSlider.intervalValue
    }
  }

  public var isSliderEnabled: Bool = false {
    didSet {
      self.slider.isEnabled = isSliderEnabled
    }
  }

  public var isTextHidden: Bool = false {
    didSet {
      self.showNumberLabel.isHidden = isTextHidden
    }
  }

  public var initValue: Float = 0 {
    didSet {
      self.slider.value = initValue
      self.showNumberLabel.text = "\(initValue)"
    }
  }

  public var textSize: CGFloat = 15 {
    didSet {
      self.showNumberLabel.font = self.showNumberLabel.font.withSize(textSize)
    }
  }

  public func getSliderValue() -> Float {
    return self.slider.value
  }

  public func sliderAddTarget(target: Any?, selector: Selector, event: UIControlEvents) {
    self.slider.addTarget(target, action: selector, for: event)
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createSubviews()
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    createSubviews()
  }

  private func valueMaker() -> [Float] {
    var values = [Float]()
    var min = minValue
    while min <= maxValue {
      values.append(min)
      min += intervalValue
    }
    return values
  }

  private func createSubviews() {
    //加入上層畫面
    frontImageView.contentMode = .left
    frontImageView.clipsToBounds = true
    frontImageView.translatesAutoresizingMaskIntoConstraints = false
    //加入下層畫面
    backImageView.contentMode = .left
    backImageView.translatesAutoresizingMaskIntoConstraints = false
    //加入顯示的label
    showNumberLabel.font = UIFont(name: "PingFangTC", size: 15)
    showNumberLabel.textColor = UIColor(red: 186 / 255, green: 143 / 255, blue: 92 / 255, alpha: 1.0)
    showNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    slider = CustomSlider.init(frame: frontImageView.frame,
                               callback: { [unowned self] value in
                                self.showNumberLabel.text = String(format: "%.1f", value)
                                self.setBackImage(value: value)

    })
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.isEnabled = false


    addSubview(showNumberLabel)
    addSubview(slider)
    addSubview(frontImageView)
    addSubview(backImageView)
    initLayout()

  }

  func setBackImage(value: Float) {
    let differ = maxValue - minValue
    if let constraint = (frontImageView.constraints.filter { $0.firstAttribute == .width }.first ) {
      let newConstraint = (backImage?.size.width ?? 0) * CGFloat( ( value - minValue ) / differ) +
        ( self.beta ?? 0 )
//      CGFloat( ( value - midValue ) / differ ) * 3
      constraint.constant = newConstraint > backImageView.frame.width ? backImageView.frame.width : newConstraint
    }
    self.rateViewChanged(slider: slider, frontImgView: frontImageView, backImgView: backImageView, text: showNumberLabel)
    self.setNeedsDisplay()
  }

  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    if let constraint = (backImageView.constraints.filter{ $0.firstAttribute == .width}.first ) {
      if let width = backImageView.image?.size.width {
        constraint.constant = width
      }
    }
    self.setBackImage(value: slider.value)
    self.rateViewDidLoad(slider: slider, frontImgView: frontImageView, backImgView: backImageView, text: showNumberLabel)
  }

  override public func awakeFromNib() {
    super.awakeFromNib()

    slider.maximumTrackTintColor = .clear
    slider.minimumTrackTintColor = .clear
    slider.thumbTintColor = .clear
    showNumberLabel.sizeToFit()
    showNumberLabel.textAlignment = .left
    showNumberLabel.numberOfLines = 0

    slider.config(values: valueMaker())

  }

  func initLayout(){
    let views = ["frontImageView": frontImageView,
                 "backImageView": backImageView,
                 "slider": slider,
                 "showNumberLabel": showNumberLabel] as [String : Any]
    // 2
    var allConstraints = [NSLayoutConstraint]()
    // 3
    let frontImageViewVerticalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[backImageView]|",
      options: [.alignAllCenterY],
      metrics: nil,
      views: views)
    allConstraints += frontImageViewVerticalConstraints
    // 4
    let backImageViewVerticalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[frontImageView]|",
      options: [.alignAllCenterY],
      metrics: nil,
      views: views)
    allConstraints += backImageViewVerticalConstraints
    // 5
    let sliderVerticalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[slider]|",
      options: [.alignAllCenterY],
      metrics: nil,
      views: views)
    allConstraints += sliderVerticalConstraints
    let showNumberLabelVerticalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[showNumberLabel]|",
      options: [.alignAllCenterY],
      metrics: nil,
      views: views)
    allConstraints += showNumberLabelVerticalConstraints
    let frontImageViewHorizontalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[backImageView]|",
      options: [.alignAllCenterX],
      metrics: nil,
      views: views)
    allConstraints += frontImageViewHorizontalConstraints
    // 4
    let backImageViewHorizontalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[frontImageView(<=backImageView)]",
      options: [.alignAllCenterX],
      metrics: nil,
      views: views)
    allConstraints += backImageViewHorizontalConstraints
    // 5
    let sliderHorizontalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[slider]|",
      options: [.alignAllCenterX],
      metrics: nil,
      views: views)
    allConstraints += sliderHorizontalConstraints

    let showNumberLabelHorizontalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[backImageView]-10-[showNumberLabel]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += showNumberLabelHorizontalConstraints

    // 7
    NSLayoutConstraint.activate(allConstraints)
  }

}

public class CustomSlider: UISlider {
  private var values: [Float] = [0, 0.5 , 1]
  private var lastIndex: Int? = nil
  private var intervalNumber: Float = 0.5
  let callback: (Float) -> Void

  init(frame: CGRect ,callback: @escaping (_ newValue: Float) -> Void) {
    self.callback = callback
    super.init(frame: frame)
    self.addTarget(self, action: #selector(handleValueChange(sender:)), for: .valueChanged)
    config(values: values)
  }

  public func config(values: [Float]) {
    self.values = values
    self.minimumValue = self.values.first!
    self.maximumValue = self.values.last!
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func handleValueChange(sender: UISlider) {
    let point = closeValue(trueValue: sender.value)
    let newIndex = point.closeIndex  // round up to next index
    self.setValue(point.closeValue, animated: false) // snap to increments
    let didChange = lastIndex == nil || newIndex != lastIndex!
    if didChange {
      let actualValue = self.values[newIndex]
      self.callback(actualValue)
    }
  }

  private func closeValue(trueValue: Float) -> Point {
    var closeIndex: Int = 0
    var closeValue = values[closeIndex]
    for (index, value) in values.enumerated() {
      if (closeValue - trueValue).magnitude > (trueValue - value).magnitude {
        closeIndex = index
        closeValue = values[index]
      }
    }
    let point = Point()
    point.closeIndex = closeIndex
    point.closeValue = closeValue
    return point
  }

  private class Point {
    var closeIndex: Int = 0
    var closeValue: Float = 0
  }


  override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    return true
  }
}




