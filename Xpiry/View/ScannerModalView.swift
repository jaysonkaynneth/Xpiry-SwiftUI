//
//  ScannerModalView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 07/12/22.
//

import SwiftUI
import Combine
import AVFoundation
import CarBode

struct ScannerModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State private var flashlight = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    
                    Spacer()
                    
                    Button {
                        flashlight.toggle()
                        print(flashlight)
                    } label: {
                        if flashlight {
                            Image(systemName: "flashlight.on.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        } else {
                            Image(systemName: "flashlight.off.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                    }
                    
                }.padding(.horizontal)
                
                Text("Scan a Barcode")
                
                CBScanner(
                    supportBarcode: .constant([.qr, .code128]),
                    torchLightIsOn: $flashlight,
                    scanInterval: .constant(5.0)
                ){
                    print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                }
            onDraw: {
                print("Preview View Size = \($0.cameraPreviewView.bounds)")
                print("Barcode Corners = \($0.corners)")
                
                //line width
                let lineWidth = 2
                
                //line color
                let lineColor = UIColor.red
                
                //Fill color with opacity
                //You also can use UIColor.clear if you don't want to draw fill color
                let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                
                //Draw box
                $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
            }
                
                Spacer()
            }.padding()
        }
        .preferredColorScheme(.light)
    }
}

struct ScannerModalView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerModalView()
    }
}
