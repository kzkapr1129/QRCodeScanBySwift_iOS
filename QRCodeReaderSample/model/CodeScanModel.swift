//
//  ScanCodeModel.swift
//  QRCodeReaderSample
//
//  Created by 中山一輝 on 2022/03/08.
//

import Foundation
import AVFoundation
import SwiftUI

struct CodeScanResult : Hashable {
    var code: String = ""
    var x : CGFloat // 矩形左上のX軸座標
    var y : CGFloat // 矩形左上のY軸座標
    var width: CGFloat // 矩形の幅
    var height: CGFloat // 矩形の高さ
}

class CodeScanModel: ObservableObject {
    
    @Published var results : [CodeScanResult] = []
    
    func foundCode(layer: AVCaptureVideoPreviewLayer, metadatas : [AVMetadataObject]) {
        
        // 前回の検出結果をクリア
        results.removeAll()
        
        // 全検出結果をCodeScanResultオブジェクトに変換してresultsに格納する
        for metadata in metadatas as! [AVMetadataMachineReadableCodeObject] {
            
            if metadata.type == .qr {
                // メタデータのタイプがQRコードの場合
                
                // 検出結果の取得
                let barCode = layer.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
                
                // 検出結果をCodeScanResultオブジェクトに変換
                let ret = CodeScanResult(code: "\(barCode.stringValue ?? "nil")",
                                         x: barCode.bounds.origin.x + barCode.bounds.size.width / 2.0,
                                         y: barCode.bounds.origin.y + barCode.bounds.size.height / 2.0,
                                         width: barCode.bounds.size.width, height: barCode.bounds.size.height)
                results.append(ret)
                
                print("\(ret.code)")
            }
        }
    }
    
}
