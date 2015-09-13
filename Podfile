source 'https://github.com/CocoaPods/Specs.git'

workspace 'SliceSDK'
xcodeproj 'SliceSDK/SliceSDK.xcodeproj'
platform :ios, '8.0'

use_frameworks!

target :SliceSDK do
    
    link_with 'SliceSDK', 'SliceSDKTests'
    pod 'Alamofire', '~> 1.2.3'
    pod 'KeychainAccess', '~> 1.2.1'
end

target :SliceExampleApp do

    link_with 'SliceExampleApp'
    pod 'SliceSDK', :git => '.'
end

# pod 'SliceSDK'
# pod 'SliceSDK', :git => 'https://github.com/slicedev/slice-ios'
