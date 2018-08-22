//
//  RateStar.swift
//  YCRateView
//
//  Created by 馮仰靚 on 12/09/2017.
//  Copyright © 2017 larvata.YC. All rights reserved.
//

import UIKit

public protocol YCRateViewDelegate: class {
  func ycRateViewSliderDidChange(sender: YCRateView, value: Float)
}

class SliderValue {
  var maxValue: Float = 5
  var minValue: Float = 0
  var intervalValue: Float = 0.5
}

@IBDesignable
public class YCRateView: UIView {

  public var frontImageView = UIImageView()
  public var backImageView = UIImageView()
  public var slider: CustomSlider!
  public var showNumberLabel: UILabel!
  public weak var delegate: YCRateViewDelegate?
  public var rate: Int?

  private var sliderValue = SliderValue()

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

  @IBInspectable var max: Float {
    set {
      self.sliderValue.maxValue = newValue
    }
    get {
      return self.sliderValue.maxValue
    }
  }

  public var isSliderEnabled: Bool = false {
    didSet {
      self.slider.isEnabled = isSliderEnabled
    }
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
    print("maxValue: \(max)")
    var values = [Float]()
    var min = sliderValue.minValue
    values.append(min)
    while min < sliderValue.maxValue {
      min += sliderValue.intervalValue
      values.append(min)
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
    showNumberLabel = UILabel()
    showNumberLabel.font = UIFont(name: "PingFangTC", size: 15)
    showNumberLabel.textColor = UIColor(red: 186 / 255, green: 143 / 255, blue: 92 / 255, alpha: 1.0)
    showNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    slider = CustomSlider.init(frame: frontImageView.frame,
                               values: self.valueMaker(),
                               callback: { [unowned self] value in
                                self.showNumberLabel.text = String(format: "%.1f", value)
                                self.delegate?.ycRateViewSliderDidChange(sender: self, value: value)
                                self.setBackImage(value: value)

    })
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.isEnabled = false


    addSubview(showNumberLabel)
    addSubview(slider)
    addSubview(frontImageView)
    addSubview(backImageView)
    layout()

  }

  func setBackImage(value: Float) {
    let differ = sliderValue.maxValue - sliderValue.minValue
    if let constraint = (frontImageView.constraints.filter{$0.firstAttribute == .width}.first) {
      constraint.constant = (backImage?.size.width ?? 0) * CGFloat( ( value - sliderValue.minValue ) / differ) + ( ( CGFloat( value - (differ / 2) ) / 2.2 ) )
    }
    if let constraint = (backImageView.constraints.filter{$0.firstAttribute == .width}.first) {
      if let width = backImageView.image?.size.width {
        constraint.constant = width
      }
    }
    if slider.value >= 0.1 {
      showNumberLabel.isHidden = false
    } else {
      showNumberLabel.isHidden = true
    }
    layoutIfNeeded()
  }

  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    self.setBackImage(value: slider.value)
  }

  override public func awakeFromNib() {
    super.awakeFromNib()

    slider.maximumTrackTintColor = .clear
    slider.minimumTrackTintColor = .clear
    slider.thumbTintColor = .clear

    showNumberLabel.sizeToFit()
    showNumberLabel.numberOfLines = 0

  }

  func layout(){
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

open class CustomSlider: UISlider {
  private let values: [Float]
  private var lastIndex: Int? = nil
  let callback: (Float) -> Void

  init(frame: CGRect, values: [Float] ,callback: @escaping (_ newValue: Float) -> Void) {
    self.values = values
    self.callback = callback
    super.init(frame: frame)
    self.addTarget(self, action: #selector(handleValueChange(sender:)), for: .valueChanged)
    let steps = values.count - 1
    self.minimumValue = 0
    self.maximumValue = Float(steps)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func handleValueChange(sender: UISlider) {
    let newIndex = Int(sender.value + 0.5) // round up to next index
    self.setValue(Float(newIndex), animated: false) // snap to increments
    let didChange = lastIndex == nil || newIndex != lastIndex!
    if didChange {
      let actualValue = self.values[newIndex]
      self.callback(actualValue)
    }
  }
  override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    return true
  }
}


