//
//  ContentView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/2/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var lightSwitch: Bool            = false
    @State var sunlightSwitch: Int          = 0
    @State var buzzBodyCameraSwitch: Bool   = false


    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()

            Text("Buzz In SwiftUI")
                .fixedSize()
                .font(.largeTitle)
                

            Spacer()

            SceneKitView(lightSwitch: $lightSwitch, sunlightSwitch: $sunlightSwitch, buzzBodyCameraSwitch: $buzzBodyCameraSwitch)
                .scaleEffect(1.0, anchor: .top)

            Spacer()

            VStack {
                HStack {
                    Spacer()

                    BuzzFaceLampButton(lightSwitch: $lightSwitch)

                    Spacer(minLength: 150)

                    SunLightButton(sunlightSwitch: $sunlightSwitch)

                    Spacer()
                }

                HStack {
                    Spacer()

                    CameraButton(buzzBodyCameraSwitch: $buzzBodyCameraSwitch)

                    Spacer()
                }
            }
        }
    .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
