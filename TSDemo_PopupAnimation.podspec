Pod::Spec.new do |s|
  s.name         = "TSDemo_PopupAnimation"
  s.version      = "0.0.1"
  s.summary      = "CJPopupAnimation 演示示例"
  s.homepage     = "https://github.com/dvlproad/CJPopupAction"

  s.license      = "MIT"
  s.author       = { "dvlproad" => "" }

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/dvlproad/CJPopupAction.git", :tag => "TSDemo_PopupAnimation_0.0.1" }

  s.frameworks   = "UIKit"
  s.requires_arc = true

  s.source_files = "TSDemo_PopupAnimation/**/*.{h,m}"
  # s.resources    = "TSDemo_PopupAnimation/**/*.{xib,xcassets,png,jpg}"
  
  s.dependency "CQDemoKit/BaseVC"
  s.dependency 'CQDemoKit/BaseUtil'
  
  s.dependency "CJPopupAction"
end
