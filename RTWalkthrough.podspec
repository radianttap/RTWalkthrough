Pod::Spec.new do |s|
  s.name         = "RTWalkthrough"
  s.version      = "0.0.1"
  s.summary      = "RTWalkthrough is a class to build custom walkthroughs for your iOS App"
  s.homepage     = "https://github.com/radianttap/RTWalkthrough"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Radiant Tap" => "" }
  s.platform     = :ios
  s.ios.deployment_target	= '8.0'
  s.source       = { :git => "https://github.com/radianttap/RTWalkthrough.git" }
  s.source_files  = "RTWalkthrough/*.{h,m}"
  s.public_header_files = 'RTWalkthrough/*.h'  
  s.frameworks   = ['Foundation', 'UIKit']
  s.requires_arc = true
end
