  #查看本地已同步的pod库：pod repo
  #清除缓存：pod cache clean CJPopupAction
  
#  pod trunk register 邮箱地址 '用户名' --description='描述信息'
#  pod trunk register dvlproad@163.com 'dvlproad' --description='homeMac'
#  pod trunk me

  # 上传到github公有库:(当前使用)
  #验证方法1：pod lib lint CJPopupAction.podspec --sources='https://github.com/CocoaPods/Specs.git' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CJPopupAction.podspec --sources=cocoapods --allow-warnings --use-libraries --verbose
  #提交方法(github公有库)： pod trunk push CJPopupAction.podspec --allow-warnings --verbose

#
#  Be sure to run `pod spec lint CJPopupAction.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "CJPopupAction"
  s.version      = "1.8.0"
  s.summary      = "UIView的类别，用来实现UIView弹出popupView的一个UIView的类别(1.8.0开始将 CJPopupAction/Toast/UIView+CJToastAnimation 移入 CJToastPresenter）"

  s.description  = <<-DESC
                     UIView的类别，用来实现UIView弹出popupView的一个UIView的类别。支持多种弹出方式：从上方弹出、从下方弹出、从中间弹出等。，可按需独立引入：
                     • CJPopupAction/CareAboutHide_AutoAddToSuperView - 关心隐藏且视图自动添加进superView的动画：内部有封装以简化hide的动画（UIView+CJBottomInWindow \ UIView+CJCenterInWindow \ UIView+CJExpandByPoint \ UIView+CJExpandForView)
                     
                     • CJPopupAction/ShowExtendView - 由视图本身(非弹出视图，如按钮本身)调用直接展开一个弹出视图的方法
                     
                     每个子库可独立引入，详见各子库描述。
                     DESC
  

  s.homepage     = "https://github.com/dvlproad/CJPopupAction"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  # s.author             = { "dvlproad" => "studyroad@qq.com" }
  # Or just: s.author    = "dvlproad"
  s.author    		 = "dvlproad"
  # s.authors            = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
   s.platform     = :ios, "9.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/dvlproad/CJPopupAction.git", :tag => "CJPopupAction_1.8.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #
  
  # 关心隐藏且视图自动添加进superView的动画：内部有封装以简化hide的动画（UIView+CJBottomInWindow \ UIView+CJCenterInWindow \ UIView+CJExpandByPoint \ UIView+CJExpandForView）
  s.subspec 'CareAboutHide_AutoAddToSuperView' do |popup|
    popup.source_files = "CJPopupAction/CareAboutHide_AutoAddToSuperView/**/*.{h,m}"
    
    popup.dependency 'CJAnimationKit/PopupAnimation/BaseBind'
  end

  # 由视图本身(非弹出视图，如按钮本身)调用直接展开一个弹出视图的方法
  s.subspec 'ShowExtendView' do |extend|
    extend.source_files = "CJPopupAction/ShowExtendView/**/*.{h,m}"
    
    extend.dependency "CJAnimationKit/PopupAnimation/BaseConvenience"
    extend.dependency "CJPopupAction/CareAboutHide_AutoAddToSuperView"
  end


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
