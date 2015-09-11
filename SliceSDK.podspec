Pod::Spec.new do |spec|
  spec.name                  = "SliceSDK"
  spec.version               = "1.0"
  spec.source                = { :git => "https://github.com/slicedev/slice-ios",
                                 :tag => spec.version.to_s }
  spec.summary               = "Slice SDK"
  spec.description           = "SDK for using Slice API"
  spec.license               = "COMMERCIAL"
  spec.homepage              = "https://developer.slice.com"
  spec.author                = { "Sean Meador" => "sean@slice.com" }
  spec.platform              = :ios
  spec.ios.deployment_target = '8.0'
  spec.source_files          = "SliceAuth/Framework/Source/**/*.{swift}"
  spec.frameworks            = "Foundation", "MobileCoreServices", "Security", "SystemConfiguration", "UIKit"
  spec.requires_arc          = true
  spec.dependency "Alamofire", "~> 1.2"
  spec.dependency "KeychainAccess", "~> 1.2"
end
