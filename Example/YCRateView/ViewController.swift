//
//  ViewController.swift
//  YCRateView
//
//  Created by stormy.petrel@msa.hinet.net on 08/27/2018.
//  Copyright (c) 2018 stormy.petrel@msa.hinet.net. All rights reserved.
//

import UIKit
import YCRateView

class ViewController: UIViewController {
  
  @IBOutlet weak var ycRateView: YCRateView!

    override func viewDidLoad() {
      super.viewDidLoad()
      ycRateView.yc_InitValue = 2
      ycRateView.yc_IsTextHidden = false
      ycRateView.yc_IsSliderEnabled = true
      ycRateView.yc_TextSize = 20
      ycRateView.yc_TextColor = UIColor.blue
      // Do any additional setup after loading the view, typically from a nib.
      ycRateView.sliderAddTarget(target: self, selector: #selector(doSomething), event: .valueChanged)
      // add call back
      ycRateView.yc_FrontImageView.image = #imageLiteral(resourceName: "gray_star_full")
      ycRateView.yc_BackImageView.image = #imageLiteral(resourceName: "gray_star_space")
      ycRateView.yc_RateViewChanged = { slider, frontImageView, backImageView, text in
        if slider.value <= 2.5 {
          backImageView.image = #imageLiteral(resourceName: "gray_star_space")
          frontImageView.image = #imageLiteral(resourceName: "gray_star_full")
        } else {
          backImageView.image = #imageLiteral(resourceName: "gold_star_space")
          frontImageView.image = #imageLiteral(resourceName: "gold_star_full")
        }
      }
  }

  @objc func doSomething(sender: UISlider) {
    print("slider value: \(sender.value)")
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

