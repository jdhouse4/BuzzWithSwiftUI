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
    @State var bodyCameraSwitch: Bool       = false


    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneKitView(lightSwitch: $lightSwitch,
                         sunlightSwitch: $sunlightSwitch,
                         bodyCameraSwitch: $bodyCameraSwitch)

            VStack {
                Text("Buzz In SwiftUI")
                    .fixedSize()
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)

                Spacer(minLength: 300)

                ControlsView(lightSwitch: $lightSwitch, sunlightSwitch: $sunlightSwitch, bodyCameraSwitch: $bodyCameraSwitch)

                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
