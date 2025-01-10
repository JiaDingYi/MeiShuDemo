Pod::Spec.new do |s|
    s.name             = 'MSMTACustomAdapter'
    s.version          = '6.00.24'
    s.summary          = 'MSMTACustomAdapter'
    s.description      = 'This is the MSMTACustomAdapter. Please proceed to https://www.mta.com for more information.'
    s.homepage         = 'https://www.mta.com/'
    s.license          = "Custom"
    s.author           = { 'wzy' => 'wangzeyong@mta.com' }
    s.source           = { :git => "https://github.com/JiaDingYi/MeiShuDemo.git", :tag => "#{s.version}" }
  
    s.ios.deployment_target = '11.0'
    s.frameworks = 'UIKit', 'MapKit', 'MediaPlayer', 'CoreLocation', 'AdSupport', 'CoreMedia', 'AVFoundation', 'CoreTelephony', 'StoreKit', 'SystemConfiguration', 'MobileCoreServices', 'CoreMotion', 'Accelerate','AudioToolbox','JavaScriptCore','Security','CoreImage','AudioToolbox','ImageIO','QuartzCore','CoreGraphics','CoreText'
    s.libraries = 'c++', 'resolv', 'z', 'sqlite3', 'bz2', 'xml2', 'iconv', 'c++abi'
    s.weak_frameworks = 'WebKit', 'AdSupport'
    s.static_framework = true
  
    s.source_files = 'MSMTACustomAdapter/**/*'

    s.dependency 'MentaVlionBaseSDK', '~> 6.00.24'
    s.dependency 'MentaUnifiedSDK',   '~> 6.00.24'
    s.dependency 'MentaVlionSDK',     '~> 6.00.24'
    s.dependency 'MentaVlionAdapter', '~> 6.00.24'
    s.dependency 'MSMobAdSDK/MS',     '~> 2.5.1.2'
  
  end