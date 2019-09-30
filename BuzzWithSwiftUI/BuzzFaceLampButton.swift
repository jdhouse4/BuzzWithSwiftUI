//
//  BuzzFaceLampButton.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/28/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI

struct BuzzFaceLampButton: View {
    @Binding var lightSwitch: Bool

    var body: some View {
        Button(action: {
            withAnimation{ self.lightSwitch.toggle() }
                print("Setting lightSwitch: \(self.lightSwitch)")
            }) {
                Image(systemName: lightSwitch ? "lightbulb" :  "lightbulb.fill")
                    .imageScale(.large)
                    .accessibility(label: Text("Buzz Lamp"))
                    .padding()
            }

    }
}
/*
struct BuzzFaceLampButton_Previews: PreviewProvider {
    static var previews: some View {
        BuzzFaceLampButton(lightSwitch: lightSwitch)
    }
}
*/
