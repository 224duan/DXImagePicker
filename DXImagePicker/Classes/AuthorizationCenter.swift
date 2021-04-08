//
//  AuthorizationCenter.swift
//  ImagePicker
//
//  Created by Duan on 2020/8/19.
//  Copyright © 2020 DX. All rights reserved.
//

enum AuthorizationKind {
    case camera, photoLibrary
}

final class AuthorizationCenter : UIView {

    class func request(on viewController: UIViewController, with key: AuthorizationKind, doubleConfirmation: Bool = true, completion: ActionClosure?) {
        /// - Todo: 权限提示信息需要修改
        let message: String
        let authorization: Authorization
        switch key {
        case .camera:
            guard UIDevice.isSimulator || UIImagePickerController.isSourceTypeAvailable(.camera) else {
                let alertVC = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                                message: NSLocalizedString("Device has no camera.", comment: ""),
                                                preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
                viewController.present(alertVC, animated: true, completion: nil)
                return
            }
            authorization = CameraAuthorization.shared
            message = NSLocalizedString("需要获得相机的使用权限", comment: "")
        case .photoLibrary:
            authorization = PhotoLibraryAuthorization.shared
            message = NSLocalizedString("需要获得相册的使用权限", comment: "")
        }
        guard authorization.status != .authorized else { completion?(); return }

        authorization.authorizedHandler = completion
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        let requestAuthorization = {
            if authorization.status == .notDetermined {
                authorization.request()
            } else {
                guard !doubleConfirmation else { AuthorizationCenter.openSettings(); return }
                let alert = UIAlertController(title: appName, message: message, preferredStyle: .alert)
                let laterAction = UIAlertAction(title: NSLocalizedString("稍后", comment: ""), style: .default)
                let settingAction = UIAlertAction(title: NSLocalizedString("去设置", comment: ""), style: .default) { _ in AuthorizationCenter.openSettings() }
                alert.addAction(laterAction)
                alert.addAction(settingAction)
                alert.preferredAction = settingAction
                viewController.present(alert, animated: true, completion: nil)
            }
        }
        if doubleConfirmation {
            let alertVC = UIAlertController(title: appName, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: NSLocalizedString("稍后", comment: ""), style: .default))
            alertVC.addAction(UIAlertAction(title: NSLocalizedString("同意", comment: ""), style: .default) { _ in requestAuthorization() })
            viewController.present(alertVC, animated: true, completion: nil)
        } else {
            requestAuthorization()
        }
    }

    private class func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
    }
}

extension UIDevice {

    fileprivate static var isSimulator: Bool {
        #if (TARGET_OS_SIMULATOR)
        return true
        #else
        return false
        #endif
    }
}
