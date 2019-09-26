//
//  ContentView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/2/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var lightSwitch: Bool = false


    var onOffButton: some View {
        Button(action: {
            self.lightSwitch.toggle()
            print("Setting lightSwitch: \(self.lightSwitch)")
        }) {
            Image(systemName: "power")
                .imageScale(.large)
                .accessibility(label: Text("Buzz Lamp"))
                .padding()
        }
    }

    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()

            SceneKitView(lightSwitch: $lightSwitch)
                .scaleEffect(0.5, anchor: .top)

            Spacer()

            onOffButton
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
