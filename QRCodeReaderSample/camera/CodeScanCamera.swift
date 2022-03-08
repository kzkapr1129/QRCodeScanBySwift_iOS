//
//  CodeScanCamera.swift
//  QRCodeReaderSample
//
//  Created by 中山一輝 on 2022/03/08.
//

import Foundation
import AVFoundation

class CodeScanCamera : NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    private let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()
    // セッションオブジェクトからレイヤーオブジェクトを生成
    var previewLayer: AVCaptureVideoPreviewLayer
    
    var supportedCodeTypes: [AVMetadataObject.ObjectType]
    
    var metadataDelegate: ((AVCaptureVideoPreviewLayer, [AVMetadataObject])->Void)
    
    init(metadataDelegate: @escaping (AVCaptureVideoPreviewLayer, [AVMetadataObject])->Void) {
        // 動画像のデフォルトの品質を指定(後から変更可能)
        session.sessionPreset = .photo
        // デフォルトのスキャン対象を指定(後から変更可能)
        supportedCodeTypes = [.qr]
        // スキャン結果を処理するデリゲートを指定
        self.metadataDelegate = metadataDelegate
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
    }
    
    /** カメラのプレビューとコード認識を開始する */
    func start(previewDelegate: @escaping (AVCaptureVideoPreviewLayer)->Void) {
        // カメラへのアクセス権限の状態を取得
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .authorized {
            // カメラへのアクセス権限がある場合
            
            // カメラを開始する
            doStart(previewDelegate)
        } else {
            // カメラへのアクセス権限がない場合
            
            // ユーザに対して使用許可を求めるダイアログを表示する
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    // ユーザがカメラの使用許可を承諾した場合
                    
                    // メインスレッド上からカメラを開始する
                    DispatchQueue.main.sync {
                        self.doStart(previewDelegate)
                    }
                }
            }
        }
    }
    
    func doStart(_ previewDelegate: (AVCaptureVideoPreviewLayer)->Void){
        // カメラの初期化
        if !initCamera(previewDelegate) { return }
        
        // カメラの初期化に成功した場合
        
        // プレビュー＆コード認識の開始
        session.startRunning()
    }
    
    private func initCamera(_ previewDelegate: (AVCaptureVideoPreviewLayer)->Void) -> Bool {
        // カメラオブジェクトの取得
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else { return false }
        // カメラオブジェクトに対しての入力オブジェクトの取得
        guard let input = try? AVCaptureDeviceInput(device: backCamera) else { return false }
        
        // 入力オブジェクトをセッションに追加
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        // メタデータ出力オブジェクトに追加する
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            // 認識対象のコードタイプを指定する
            metadataOutput.metadataObjectTypes = supportedCodeTypes
            // メタデータ出力オブジェクトとデリゲートを連結する
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        }

        // レイヤーオブジェクトをデリゲートに通知
        previewDelegate(previewLayer)
        
        return true
    }
    
    /** カメラプレビューとコード認識を停止する */
    func stop() {
        session.stopRunning()
    }
    
    /** implements AVCaptureMetadataOutputObjectsDelegate function */
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        metadataDelegate(previewLayer, metadataObjects)
    }
}
