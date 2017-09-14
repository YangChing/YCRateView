
Pod::Spec.new do |s|


  s.name         = "YCRateView"
  s.version      = "1.0.0"
  s.summary      = "A rate view slider."
  s.description  = "You can use any image to change the rate view"
  s.homepage     = "https://github.com/YangChing/YCRateView"
  s.license      = "MIT"
  s.author       = { "Feng YangChing" => "stormy.petrel@msa.hinet.net" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "URL", :tag => "1.0.0" }
  s.source_files  = "YCRateView", "YCRateView/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
