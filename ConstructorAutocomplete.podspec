Pod::Spec.new do |spec|
  spec.name         = 'ConstructorAutocomplete'
  spec.version      = '1.17.0'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://www.constructor.io'
  spec.authors      = { 'Zubin Tiku' => 'zubin@constructor.io', 'Christopher Gee' => 'christopher@constructor.io', 'Jimmy Li' => 'jimmy@constructor.io' }
  spec.summary      = 'Constructor.io iOS autosuggest client.'
  spec.source       = { :git => 'https://github.com/Constructor-io/constructorio-client-swift.git', :tag => 'v1.17.0' }
  spec.platform     = :ios, '8.0'
  spec.source_files = 'AutocompleteClient/**/*.swift'
  spec.framework    = 'UIKit'
  spec.swift_versions = ['4.0', '4.1', '4.2']
  spec.ios.resource_bundle 	  = { 'ConstructorAutocomplete' => ['AutocompleteClient/Resources/*.png', 'AutocompleteClient/**/*.xib'] }
end