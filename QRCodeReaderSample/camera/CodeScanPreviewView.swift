//
//  CodeScanPreviewView.swift
//  QRCodeReaderSample
//
//  Created by 中山一輝 on 2022/03/08.
//

import SwiftUI
import AVFoundation

class CodeScanPreviewInnerView : UIView {
    
    var camera: CodeScanCamera?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    init (camera: CodeScanCamera?) {
        super.init(frame: .zero)
        self.camera = camera
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
    }    
}

struct CodeScanPreviewView : UIViewRepresentable {

    typealias UIViewType = CodeScanPreviewInnerView
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var camera: CodeScanCamera?
    
    init (_ metadataDelegate: @escaping (AVCaptureVideoPreviewLayer, [AVMetadataObject])->Void) {
        // カメラの初期化
        camera = CodeScanCamera(metadataDelegate: metadataDelegate)
    }
    
    func makeUIView(context: Context) -> CodeScanPreviewInnerView {
        let view = CodeScanPreviewInnerView(camera: camera)
        // プレビューの開始
        camera?.start(previewDelegate: { (previewLayer: AVCaptureVideoPreviewLayer) -> Void in
            // 背景色の指定
            view.backgroundColor = UIColor.gray
            // プレビュー画面のGravity設定を指定
            previewLayer.videoGravity = .resizeAspectFill
            // レイヤーオブジェクトとビューを関連付けする
            view.layer.addSublayer(previewLayer)
            
            view.previewLayer = previewLayer
        })
        return view
    }
    
    static func dismantleUIView(_ uiView: CodeScanPreviewInnerView, coordinator: ()) {
        uiView.camera?.stop()
    }
    
    func updateUIView(_ uiView: CodeScanPreviewInnerView, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
