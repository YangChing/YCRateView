//
//  RateStar.swift
//  YCRateView
//
//  Created by 馮仰靚 on 12/09/2017.
//  Copyright © 2017 larvata.YC. All rights reserved.
//

import UIKit

@IBDesignable
public class YCRateView: UIView {


  public var frontImageView: UIImageView!
  public var backImageView: UIImageView!
  public var slider: UISlider!
  public var showNumberLabel: UILabel!


  @IBInspectable public var frontImage: UIImage? {
    didSet {
      frontImageView.image = frontImage

    }
  }
  @IBInspectable public var backImage: UIImage? {
    didSet {
      backImageView.image = backImage

    }
  }

  @IBInspectable public var Text: String? {
    didSet {
      showNumberLabel.text = Text

    }
  }


  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createSubviews()

  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    createSubviews()

  }

  func createSubviews() {
    //translatesAutoresizingMaskIntoConstraint
    //加入上層畫面
    frontImageView = UIImageView()
    frontImageView.contentMode = UIViewContentMode.left
    frontImageView.clipsToBounds = true
    frontImageView.translatesAutoresizingMaskIntoConstraints = false

    //加入下層畫面
    backImageView = UIImageView()
    backImageView.contentMode = UIViewContentMode.left
    backImageView.translatesAutoresizingMaskIntoConstraints = false
    //加入顯示的label
    showNumberLabel = UILabel()
    showNumberLabel.font = UIFont(name: "PingFangTC", size: 15)
    if #available(iOS 10.0, *) {
      showNumberLabel.textColor = UIColor(displayP3Red: 165/255, green: 140/255, blue: 101/255, alpha: 1)
    } else {
      // Fallback on earlier versions
    }
    showNumberLabel.translatesAutoresizingMaskIntoConstraints = false

    slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false

    addSubview(showNumberLabel)
    addSubview(frontImageView)
    addSubview(backImageView)
    addSubview(slider)
    let views = ["frontImageView": frontImageView,
                 "backImageView": backImageView,
                 "slider": slider,
                 "showNumberLabel": showNumberLabel,
                 "self": self] as [String : Any]

    // 2
    var allConstraints = [NSLayoutConstraint]()

    // 3
    let frontImageViewVerticalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-[backImageView]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += frontImageViewVerticalConstraints

    // 4
    let backImageViewVerticalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-[frontImageView]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += backImageViewVerticalConstraints

    // 5
    let sliderVerticalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-[slider]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += sliderVerticalConstraints

    let showNumberLabelVerticalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-(5)-[showNumberLabel]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += showNumberLabelVerticalConstraints

    let frontImageViewHorizontalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-[backImageView]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += frontImageViewHorizontalConstraints

    // 4
    let backImageViewHorizontalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-[frontImageView(0)]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += backImageViewHorizontalConstraints

    // 5
    let sliderHorizontalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-[slider(==backImageView)]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += sliderHorizontalConstraints

    let showNumberLabelHorizontalConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-[backImageView]-10-[showNumberLabel]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += showNumberLabelHorizontalConstraints

    // 7
    NSLayoutConstraint.activate(allConstraints)


  }

  func sliderMove(_ sender: UISlider) {

    frontImageView.frame.size.width = backImageView.frame.width * CGFloat(sender.value) / 5
    showNumberLabel.text = String(format: "%.1f",sender.value)
  }

  func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
    if slider.isHighlighted {
      return
    }
    let point = gestureRecognizer.location(in: self)
    let percentage = Float(point.x / slider.bounds.width)
    let delta = percentage * (slider.maximumValue - slider.minimumValue)
    let value = slider.minimumValue + delta
    slider.setValue(value, animated: true)
    frontImageView.frame.size.width = backImageView.frame.width * CGFloat(slider.value) / 5
    showNumberLabel.text = String(format: "%.1f",slider.value)

  }


  override public func layoutSubviews() {
    super.layoutSubviews()
    frontImageView.translatesAutoresizingMaskIntoConstraints = true
    backImageView.translatesAutoresizingMaskIntoConstraints = true

  }

  override public func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()

  }

  override public func awakeFromNib() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))

    slider.maximumValue = 5.0
    slider.minimumValue = 0.0
    slider.value = Float(showNumberLabel.text ?? "0")!
    slider.maximumTrackTintColor = .clear
    slider.minimumTrackTintColor = .clear
    slider.thumbTintColor = .clear
    slider.addGestureRecognizer(tapGestureRecognizer)
    slider.addTarget(self, action: #selector(sliderMove), for: .valueChanged)
    showNumberLabel.sizeToFit()
    showNumberLabel.numberOfLines = 0
  }
  
}
