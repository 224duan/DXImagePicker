//
//  Authorization.swift
//  ImagePicker
//
//  Created by Duan on 2020/8/19.
//  Copyright © 2020 DX. All rights reserved.
//

import Photos

typealias ActionClosure = () -> Void

// MARK: - Authorization Status
enum AuthorizationStatus {
    case notDetermined, restricted, denied, authorized
}

// MARK: - Authorization Delegate
protocol AuthorizationDelegate : AnyObject {
    func handleAuthorizationChanged(_ authorization: Authorization)
}

class Authorization : NSObject {
    var status: AuthorizationStatus { return .notDetermined }
    weak var delegate: AuthorizationDelegate?
    var authorizedHandler: ActionClosure? { didSet { if status == .authorized { authorizedHandler?() } } }
    func request() {}
    fileprivate func handleAuthorization() {
        if status == .authorized { authorizedHandler?() }
        delegate?.handleAuthorizationChanged(self)
    }
}

// MARK: - Camera Authorization
class CameraAuthorization : Authorization {
    static let shared = CameraAuthorization()
    override private init() { super.init() }

    override var status: AuthorizationStatus {
        let avStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch avStatus {
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        case .denied: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    override func request() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] _ in
            DispatchQueue.main.async { self?.handleAuthorization() }
        })
    }
}

// MARK: - Photo Library Authorization
class PhotoLibraryAuthorization : Authorization {
    static let shared = PhotoLibraryAuthorization()
    override private init() { super.init() }

    override var status: AuthorizationStatus {
        let phStatus: PHAuthorizationStatus
        if #available(iOS 14, *) {
            phStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            phStatus = PHPhotoLibrary.authorizationStatus()
        }

        switch phStatus {
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        case .denied: return .denied
        case .authorized, .limited: return .authorized
        @unknown default: return .denied
        }
    }

    override func request() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] _ in
                DispatchQueue.main.async { self?.handleAuthorization() }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { [weak self] _ in
                DispatchQueue.main.async { self?.handleAuthorization() }
            }
        }
    }
}
