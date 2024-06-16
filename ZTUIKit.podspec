Pod::Spec.new do |s|
  s.name             = 'ZTUIKit'
  s.version          = '0.1.1'
  s.summary          = 'ZTUIKit is specifically designed for UIKit, providing a SwiftUI-like experience for building UI interfaces in UIKit.'

  s.description      = <<-DESC
                        ZTUIKit is a lightweight and flexible UI framework written in Swift, designed to simplify the development of user interfaces for iOS applications. It provides a set of reusable UI components and utilities that can be easily integrated into your projects.
                        DESC

  s.homepage         = 'https://github.com/willonboy/ZTUIKit'
  s.license          = { :type => 'MPL-2.0', :file => 'LICENSE' }
  s.author           = { 'trojan zhang' => 'willonboy@qq.com' }
  s.source           = { :git => 'https://github.com/willonboy/ZTUIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.source_files = 'Sources/**/*.{swift,h,m}'
  s.exclude_files = 'Sources/Exclude'

  s.platforms = { :ios => '13.0' }

  s.swift_version = '5.1'
  
  s.dependency 'ZTChain', '1.0.0'
  s.dependency 'ZTStyle', '1.0.0'
  s.dependency 'SnapKit', '5.6.0'
end
