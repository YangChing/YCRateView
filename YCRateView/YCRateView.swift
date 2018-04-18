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

@IBDesignable
public class YCRateView: UIView {

  public var frontImageView: UIImageView!
  public var backImageView: UIImageView!
  public var slider: CustomSlider!
  public var showNumberLabel: UILabel!
  public weak var delegate: YCRateViewDelegate?
  public var rate: Int?

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

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createSubviews()
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    createSubviews()
  }

  func createSubviews() {
    //加入上層畫面
    frontImageView = UIImageView()
    frontImageView.contentMode = .left
    frontImageView.clipsToBounds = true
    frontImageView.translatesAutoresizingMaskIntoConstraints = false
    //加入下層畫面
    backImageView = UIImageView()
    backImageView.contentMode = .left
    backImageView.translatesAutoresizingMaskIntoConstraints = false
    //加入顯示的label
    showNumberLabel = UILabel()
    showNumberLabel.font = UIFont(name: "PingFangTC", size: 15)
    showNumberLabel.textColor = UIColor(red: 186 / 255, green: 143 / 255, blue: 92 / 255, alpha: 1.0)
    showNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    slider = CustomSlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.isEnabled = false

    addSubview(showNumberLabel)
    addSubview(slider)
    addSubview(frontImageView)
    addSubview(backImageView)
    layout()

  }

  func sliderMove(_ sender: UISlider) {
    guard sender.state != .normal else {
      return
    }
    if let constraint = (frontImageView.constraints.filter{$0.firstAttribute == .width}.first) {
      constraint.constant = (backImage?.size.width ?? 0) * CGFloat(slider.value) / 5
    }
    showNumberLabel.text = String(format: "%.1f",sender.value)
    delegate?.ycRateViewSliderDidChange(sender: self, value: sender.value)
    if slider.value >= 0.1 {
      showNumberLabel.isHidden = false
    } else {
      showNumberLabel.isHidden = true
    }
    layoutIfNeeded()
  }


  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    if let constraint = (frontImageView.constraints.filter{$0.firstAttribute == .width}.first) {
      constraint.constant = (backImage?.size.width ?? 0) * CGFloat(slider.value) / 5
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

  override public func awakeFromNib() {
    super.awakeFromNib()
    slider.maximumValue = 5.0
    slider.minimumValue = 0.0
    slider.value = Float(showNumberLabel.text ?? "0")!
    slider.maximumTrackTintColor = .clear
    slider.minimumTrackTintColor = .clear
    slider.thumbTintColor = .clear
    slider.addTarget(self, action: #selector(sliderMove), for: .valueChanged)

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
  override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    return true
  }
}

