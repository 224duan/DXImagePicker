//
//  UIViewController+ImagePicker.swift
//  ImagePicker
//
//  Created by Duan on 2020/8/19.
//  Copyright © 2020 DX. All rights reserved.
//

import Foundation

extension UIViewController {

    /// 弹出相机或照片选择器
    /// - Parameters:
    ///   - cropImage 是否裁切图片
    ///   - aspectRatio: 裁剪区域宽高比
    ///   - aspectRatioLockEnabled: 是否锁定裁剪的宽高比
    ///   - limitedPixel: 限制图片的总像素，当选取的图片像素大于该值时会缩小所选图。
    ///     例1: 目标图片尺寸为 `(CGSize){100.0f, 100.0f}`, 可将该值设置为 `100.0f * 100.0f`
    ///     例2: 如果期望图片的总像素不大于10_000, 就将该值设置为 10_000
    ///
    ///   - completion 完成之后回调
    public func showImagePicker(sourceType: UIImagePickerController.SourceType,
                                cropImage: Bool = true,
                                aspectRatio: ImagePickerDelegate.AspectRatioPreset = .presetOriginal,
                                aspectRatioLockEnabled: Bool = false,
                                limitedPixel: CGFloat? = nil,
                                completion: ImagePickerCompletion?) {

        let pickerDelegate = ImagePickerDelegate(completion: completion)
        pickerDelegate.shouldCropImage = cropImage
        pickerDelegate.aspectRatio = aspectRatio
        pickerDelegate.aspectRatioLockEnabled = aspectRatioLockEnabled
        pickerDelegate.limitedPixel = limitedPixel
        switch sourceType {
        case .camera:
            AuthorizationCenter.request(on: self, with: .camera) { [weak self] in
                guard let self = self else { return }
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = false
                picker.delegate = pickerDelegate
                picker.modalPresentationStyle = .fullScreen
                pickerDelegate.bind(to: picker)
                self.present(picker, animated: true, completion: nil)
            }
        case .photoLibrary, .savedPhotosAlbum:
            AuthorizationCenter.request(on: self, with: .photoLibrary) { [weak self] in
                guard let self = self else { return }
                let picker = TZImagePickerController(maxImagesCount: 1, delegate: pickerDelegate)!
                picker.allowTakeVideo = false
                picker.showSelectBtn = false
                picker.allowPickingVideo = false
                picker.notScaleImage = false
                picker.allowPreview = false
                picker.autoDismiss = false
                picker.allowCrop = false
                picker.imagePickerControllerDidCancelHandle = { [unowned picker] in picker.dismiss(animated: true, completion: nil) }
                picker.modalPresentationStyle = .fullScreen
                pickerDelegate.bind(to: picker)
                self.present(picker, animated: true, completion: nil)
            }
        @unknown default: break
        }
    }
}
