#Cocoapods
source 'https://cdn.cocoapods.org/'

#XCWebRTC
source 'https://github.com/TechTeamer/ios-xc-webrtc.git'

platform :ios, '15.0'
use_frameworks!
inhibit_all_warnings!

pod 'SwiftGen'
pod 'SwiftLint'

target 'BankAPI' do
  pod 'Apollo'
end

target 'DesignKit' do
end

target 'DailyBanking' do
  pod 'Apollo', '0.51.2'
  pod 'Firebase/AnalyticsWithoutAdIdSupport'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Performance'
  pod 'Firebase/Messaging'
  pod 'Resolver'
  pod 'KeychainAccess'
  pod 'CryptoSwift'
  pod 'SwiftEntryKit', :git => 'https://github.com/ZsoltMolnarMBH/SwiftEntryKit.git'
  pod 'PhoneNumberKit'
  pod 'AnyFormatKitSwiftUI'
  pod 'Confy'
  pod 'lottie-ios'
  pod 'FaceKomSDK', :git => 'git@github.com:Magyar-Bankholding-Zrt/sdk-facekom-ios.git'

  target 'DailyBankingTests' do
    inherit! :search_paths
    pod 'SwiftyMocky'
  end

  target 'DailyBankingUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
    if target.name == 'CryptoSwift'
      target.build_configurations.each do |config|
        config.build_settings['GCC_OPTIMIZATION_LEVEL'] = 's'
        config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-O'
      end
    end

    if ["Socket.IO-Client-Swift", "Starscream"].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end
end
