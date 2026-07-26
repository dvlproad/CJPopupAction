Pod::Spec.new do |s|
  s.name         = "TSDemo_Popup-Swift"
  s.version      = "0.0.1"
  s.summary      = "TSDemo_Popup Swift 版 - 补充使用 Swift 语言实现的 Popup 演示界面"
  s.homepage     = "https://github.com/dvlproad/CJPopupAction"

  s.license      = "MIT"
  s.author       = { "dvlproad" => "" }

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/dvlproad/CJPopupAction.git", :tag => "TSDemo_Popup-Swift_0.0.1" }
  s.swift_version = "5.0"

  s.frameworks   = "UIKit"
  s.requires_arc = true

  s.source_files = "TSDemo_Popup-Swift/**/*.{swift}"

  s.dependency "TSDemo_Popup"
  s.dependency "CQDemoKit/BaseVC"
  s.dependency "CQDemoResource/Images"
end
