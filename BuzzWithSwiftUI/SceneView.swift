//
//  SceneView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/2/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI
import SceneKit




struct SceneView: UIViewRepresentable {
    let scene = SCNScene(named: "Buzz.scn")!


    func makeUIView(context: Context) -> SCNView {
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 20)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(red: 0.1, green: 0.08, blue: 0.08, alpha: 0.0)
        //scene.rootNode.addChildNode(ambientLightNode)

        // retrieve the ship node
        let buzz = scene.rootNode.childNode(withName: "Buzz", recursively: true)!

        // animate the 3d object
        buzz.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 3)))

        // retrieve the SCNView
        let scnView = SCNView()

        // configure the view
        scnView.backgroundColor = UIColor.black

        // Configure camera within view
        scnView.pointOfView = cameraNode

        return scnView
    }



    func updateUIView(_ scnView: SCNView, context: Context) {
        // set the scene to the view
        scnView.scene = scene

        scnView.backgroundColor = UIColor.black

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        // show statistics such as fps and timing information
        scnView.showsStatistics = true

    }
}


#if DEBUG
struct ScenekitView_Previews : PreviewProvider {
    static var previews: some View {
        SceneView()
    }
}
#endif
