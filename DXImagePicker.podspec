#
# Be sure to run `pod lib lint DXImagePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DXImagePicker'
  s.version          = '0.0.1'
  s.summary          = 'Easy way to pick image'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  `Easy way to pick image`
                       DESC

  s.homepage         = 'https://github.com/224duan/DXImagePicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric' => '15110426342@163.com' }
  s.source           = { :git => 'https://github.com/224duan/DXImagePicker.git', :tag => s.version.to_s }

  s.swift_version = '5.0'

  s.ios.deployment_target = '11.0'

  s.source_files = 'DXImagePicker/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DXImagePicker' => ['DXImagePicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Photos'
  s.dependency 'TZImagePickerController', '~> 3.5.7'
  s.dependency 'CropViewController', '~> 2.6.0'
end
