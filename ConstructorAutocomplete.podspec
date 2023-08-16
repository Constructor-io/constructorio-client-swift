Pod::Spec.new do |spec|
  spec.name         = 'ConstructorAutocomplete'
  spec.version      = '3.0.2'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://www.constructor.io'
  spec.authors      = { 'Zubin Tiku' => 'zubin@constructor.io', 'Christopher Gee' => 'christopher@constructor.io', 'Jimmy Li' => 'jimmy@constructor.io' }
  spec.summary      = 'Constructor.io iOS autosuggest client.'
  spec.source       = { :git => 'https://github.com/Constructor-io/constructorio-client-swift.git', :tag => 'v3.0.2' }
  spec.platform     = :ios, '11.0'
  spec.source_files = 'AutocompleteClient/**/*.swift'
  spec.framework    = 'UIKit'
  spec.swift_versions = ['4.0', '4.1', '4.2', '5']
  spec.ios.resource_bundle 	  = { 'ConstructorAutocomplete' => ['AutocompleteClient/Resources/*.png', 'AutocompleteClient/**/*.xib'] }
end
