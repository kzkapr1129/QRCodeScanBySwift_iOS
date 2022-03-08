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
    var x : CGFloat
    var y : CGFloat
    var width: CGFloat
    var height: CGFloat
}

class CodeScanModel: ObservableObject {
    
    @Published var results : [CodeScanResult] = []
    
    func foundCode(layer: AVCaptureVideoPreviewLayer, metadatas : [AVMetadataObject]) {
        
        results.removeAll()
        
        for metadata in metadatas as! [AVMetadataMachineReadableCodeObject] {
            if metadata.type == .qr {
                // 検出位置を取得
                let barCode = layer.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
                
                
                let ret = CodeScanResult(code: "\(barCode.stringValue)",
                                         x: barCode.bounds.origin.x + barCode.bounds.size.width / 2.0,
                                         y: barCode.bounds.origin.y + barCode.bounds.size.height / 2.0,
                                         width: barCode.bounds.size.width, height: barCode.bounds.size.height)
                
                print("origin=\(barCode.bounds.origin), size=\(barCode.bounds.size)")
                
                results.append(ret)
            }
        }
    }
    
}
