//
//  ControlsView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 12/16/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI

struct ControlsView: View {

    @Binding var lightSwitch: Bool
    @Binding var sunlightSwitch: Int
    @Binding var buzzBodyCameraSwitch: Bool



    var body: some View {
        VStack {
            HStack {
                Spacer()

                SunLightButton(sunlightSwitch: $sunlightSwitch)

                Spacer()

                BuzzFaceLampButton(lightSwitch: $lightSwitch)

                Spacer(minLength: 150)

            }

            HStack {
                Spacer()

                CameraButton(buzzBodyCameraSwitch: $buzzBodyCameraSwitch)

                Spacer()
            }
        }
    }
}




/*
struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView(lightSwitch: lightSwitch, sunlightSwitch: sunlightSwitch, buzzBodyCameraSwitch: buzzBodyCamera)
    }
}
*/
