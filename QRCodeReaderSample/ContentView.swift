//
//  ContentView.swift
//  QRCodeReaderSample
//
//  Created by 中山一輝 on 2022/03/05.
//

import SwiftUI
import Foundation
import AVFoundation

struct ContentView: View {
    @ObservedObject var model = CodeScanModel()
    
    var body: some View {

        ZStack {
            Text(0 < model.results.count ? model.results[0].code : "")
                .font(.subheadline)
                .zIndex(1.0)
                .frame(width: UIScreen.main.bounds.size.width, height: 50)
                .position(x: UIScreen.main.bounds.size.width/2.0, y: 50)
            
            ZStack {
                CodeScanPreviewView(model.foundCode)
                    .zIndex(0.0)
                
                ForEach(model.results, id:\.self) { ret in
                    Rectangle()
                        .stroke(Color.red, lineWidth: 2)
                        .frame(width: ret.width, height: ret.height)
                        .position(x: ret.x, y: ret.y)
                }
            }.frame(width: 300, height: 500)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
