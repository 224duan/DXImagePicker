//
//  ImagePickerDelegate.swift
//  ImagePicker
//
//  Created by Duan on 2020/8/19.
//  Copyright © 2020 DX. All rights reserved.
//

import CropViewController
import CoreGraphics

public typealias ImagePickerCompletion = (UIImage) -> Void

public final class ImagePickerDelegate : NSObject {

    public enum AspectRatioPreset {
        case presetOriginal
        /// CGSize值，代表自定义纵横比。
        /// 例如: 比例为4：3表示为 (CGSize){4.0f, 3.0f}
        case custom(size: CGSize)
    }

    public var completion: ImagePickerCompletion?
    /// 是否裁剪图片
    public var shouldCropImage = true
    /// 锁定裁剪宽高比
    public var aspectRatioLockEnabled = false
    /// 裁剪宽高比
    public var aspectRatio: AspectRatioPreset = .presetOriginal
    /// 最大像素
    public var limitedPixel: CGFloat? = nil

    public init(completion: ImagePickerCompletion? = nil) {
        self.completion = completion
        super.init()
    }

    /// 执行绑定方法是为了防止 `self` 被提前释放。需要注意循环引用的问题
    func bind(to vc: UIImagePickerController) {
        vc._imagePickerDelegate = self
    }

    func bind(to vc: TZImagePickerController) {
        vc._imagePickerDelegate = self
    }

    // MARK: - Tool
    private func createCropViewController(with image: UIImage) -> CropViewController {
        let cropController = CropViewController(croppingStyle: .default, image: image)
        cropController.aspectRatioLockEnabled = aspectRatioLockEnabled

        cropController.aspectRatioPreset = .presetSquare;
        cropController.resetAspectRatioEnabled = false
        cropController.aspectRatioPickerButtonHidden = true
        cropController.doneButtonTitle = NSLocalizedString("完成", comment: "")
        cropController.cancelButtonTitle = NSLocalizedString("取消", comment: "")

        switch aspectRatio {
        case .presetOriginal: cropController.aspectRatioPreset = .presetOriginal
        case .custom(let size): cropController.customAspectRatio = size
        }
        cropController.delegate = self
        return cropController
    }

    private func excuteCompletion(_ image: UIImage) {
        guard let completion = completion else { return }
        let imagePixel = image.size.width * image.scale * image.size.height * image.scale
        guard let limitedPixel = limitedPixel, limitedPixel < imagePixel else { completion(image);  return }
        let scale = CGFloat(sqrtf(Float(imagePixel/limitedPixel)))
        let targetSize = CGSize(width: floor(image.size.width / scale), height: floor(image.size.height / scale))
        UIGraphicsBeginImageContextWithOptions(targetSize, true, image.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        completion(newImage)
    }
}

extension ImagePickerDelegate : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let infoKey: UIImagePickerController.InfoKey = picker.allowsEditing ? .editedImage : .originalImage
        guard let image = info[infoKey] as? UIImage else { picker.dismiss(animated: true, completion: nil); return }
        guard shouldCropImage else {
            picker.dismiss(animated: true) { [weak self] in self?.excuteCompletion(image) }
            return
        }
        let presentingVC = picker.presentingViewController
        picker.dismiss(animated: true, completion: nil)
        let cropController = createCropViewController(with: image)
        presentingVC?.present(cropController, animated: true, completion: nil)
    }
}

extension ImagePickerDelegate : TZImagePickerControllerDelegate {

    public func imagePickerController(_ picker: TZImagePickerController, didFinishPickingPhotos photos: [UIImage], sourceAssets assets: [Any], isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]) {
        guard let image = photos.first else { picker.dismiss(animated: true, completion: nil); return }
        guard shouldCropImage else {
            picker.dismiss(animated: true) { [weak self] in self?.excuteCompletion(image) }
            return
        }
        let cropController = createCropViewController(with: image)
        picker.pushViewController(cropController, animated: true)
        picker.selectedModels?.compactMap { $0 as? TZAssetModel }.forEach { picker.removeSelectedModel($0) }
    }
}

extension ImagePickerDelegate : CropViewControllerDelegate {

    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        (cropViewController.navigationController ?? cropViewController).dismiss(animated: true) { [weak self] in self?.excuteCompletion(image) }
    }
}

extension UIImagePickerController {
    private static var _ImagePickerDelegateKey: String = "DX_ImagePickerDelegateKey"

    fileprivate var _imagePickerDelegate: ImagePickerDelegate? {
        set { objc_setAssociatedObject(self, &UIImagePickerController._ImagePickerDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &UIImagePickerController._ImagePickerDelegateKey) as? ImagePickerDelegate }
    }
}

extension TZImagePickerController {
    private static var _ImagePickerDelegateKey: String = "DX_ImagePickerDelegateKey"

    fileprivate var _imagePickerDelegate: ImagePickerDelegate? {
        set { objc_setAssociatedObject(self, &TZImagePickerController._ImagePickerDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &TZImagePickerController._ImagePickerDelegateKey) as? ImagePickerDelegate }
    }
}

extension UIImage {



}
