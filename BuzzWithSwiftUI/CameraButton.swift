//
//  CameraButton.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 12/14/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI

struct CameraButton: View {
    @Binding var buzzBodyCameraSwitch: Bool

    var body: some View {
        Button(action: {
            withAnimation{ self.buzzBodyCameraSwitch.toggle() }
            print("Setting buzzBodyCameraSwitch: \(self.buzzBodyCameraSwitch)")
        }) {
            Image(systemName: buzzBodyCameraSwitch ? "video" :  "video.fill")
                .imageScale(.large)
                .accessibility(label: Text("Camera"))
                .padding()
        }

    }
}




/*
struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        CameraButton()
    }
}
*/
