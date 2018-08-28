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
      ycRateView.initValue = 2
      ycRateView.isTextHidden = false
      ycRateView.isSliderEnabled = true
      ycRateView.textSize = 20
      // Do any additional setup after loading the view, typically from a nib.
      ycRateView.sliderAddTarget(target: self, selector: #selector(doSomething), event: .valueChanged)
      // add call back
      ycRateView.frontImageView.image = #imageLiteral(resourceName: "star_full_4")
      ycRateView.backImageView.image = #imageLiteral(resourceName: "star_space_4")
      ycRateView.rateViewChanged = { slider, frontImageView, backImageView, text in
        if slider.value <= 2.5 {
          backImageView.image = #imageLiteral(resourceName: "star_space_4")
          frontImageView.image = #imageLiteral(resourceName: "star_full_4")
        } else {
          backImageView.image = #imageLiteral(resourceName: "star_space")
          frontImageView.image = #imageLiteral(resourceName: "star_full")
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

