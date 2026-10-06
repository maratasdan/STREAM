//
//  ScannerViewController.swift
//  STREAM APP
//
//  Created by Danxd on 7/22/26.
//

import UIKit
import AVFoundation

final class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var completion: ((String) -> Void)?

    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
    }

    // MARK: - Setup Camera

    private func setupCamera() {

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        // Camera Input
        if session.canAddInput(input) {
            session.addInput(input)
        }

        // QR Metadata Output
        let output = AVCaptureMetadataOutput()

        if session.canAddOutput(output) {
            session.addOutput(output)

            output.setMetadataObjectsDelegate(
                self,
                queue: .main
            )

            output.metadataObjectTypes = [.qr]
        }

        // Camera Preview
        previewLayer = AVCaptureVideoPreviewLayer(
            session: session
        )

        previewLayer.videoGravity = .resizeAspectFill

        view.layer.addSublayer(previewLayer)

        updateCameraOrientation()

        // Start Camera
        session.startRunning()
    }

    // MARK: - Camera Orientation

    private func updateCameraOrientation() {

        guard let connection = previewLayer.connection else {
            return
        }

        // iPad = Landscape
        // iPhone = Portrait

        if UIDevice.current.userInterfaceIdiom == .pad {

            // iPad Landscape
            if connection.isVideoRotationAngleSupported(0) {
                connection.videoRotationAngle = 0
            }

        } else {

            // iPhone Portrait
            if connection.isVideoRotationAngleSupported(90) {
                connection.videoRotationAngle = 90
            }
        }
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewLayer.frame = view.bounds

        updateCameraOrientation()
    }

    // MARK: - QR Detection

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {

        guard let object = metadataObjects.first
                as? AVMetadataMachineReadableCodeObject,
              let code = object.stringValue else {
            return
        }

        // Stop scanning
        session.stopRunning()

        // Return QR code
        completion?(code)
    }

    // MARK: - Cleanup

    deinit {
        session.stopRunning()
    }
}
