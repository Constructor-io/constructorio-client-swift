project "AutocompleteClient.xcodeproj"

source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

platform :ios, '11.0'

inhibit_all_warnings!

target 'UserApplication' do
    pod 'Kingfisher'
end

target 'AutocompleteClientTests' do
    pod 'OHHTTPStubs/Swift'
end


# Pods default to their own (very old) minimum iOS version, which recent Xcode can no longer
# build for (missing libarclite). Align them with the project's deployment target.
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
    end
end
