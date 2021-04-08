# DXImagePicker

[![CI Status](https://img.shields.io/travis/Eric/DXImagePicker.svg?style=flat)](https://travis-ci.org/Eric/DXImagePicker)
[![Version](https://img.shields.io/cocoapods/v/DXImagePicker.svg?style=flat)](https://cocoapods.org/pods/DXImagePicker)
[![License](https://img.shields.io/cocoapods/l/DXImagePicker.svg?style=flat)](https://cocoapods.org/pods/DXImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/DXImagePicker.svg?style=flat)](https://cocoapods.org/pods/DXImagePicker)

## Example

```swift
showImagePicker(sourceType: .photoLibrary) { [unowned self] (image) in
    self.imageView.image = image
}
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DXImagePicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DXImagePicker'
```

## Author

Eric, 15110426342@163.com

## License

DXImagePicker is available under the MIT license. See the LICENSE file for more info.
