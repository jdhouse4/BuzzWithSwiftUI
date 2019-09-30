//
//  SceneKitView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/2/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI
import SceneKit
import SpriteKit




struct SceneKitView: UIViewRepresentable {


    func makeCoordinator() -> Coordinator {
        return Coordinator(self, lightSwitch: $lightSwitch, sunlightSwitch: $sunlightSwitch)
    }


    @Binding var lightSwitch: Bool
    @Binding var sunlightSwitch: Int


    // SceneKit Properties
    let scene = SCNScene(named: "Buzz.scn")!

    var sunlightNode: SCNNode = SCNNode()

    var lightTextNode: SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue")

    var overlayScene: SKScene = SKScene()



    func makeUIView(context: Context) -> SCNView {
        // retrieve the SCNView
        let scnView = SCNView()


        // configure the view
        scnView.backgroundColor = UIColor.black


        // Create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // Place the camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 20)

        // Configure camera within view
        scnView.pointOfView = cameraNode


        // Create sunlight node to shine a little light on the whole scene.
        sunlightNode.name = "ChangingLightNode"
        sunlightNode.light = SCNLight()
        sunlightNode.light!.type = .directional
        sunlightNode.light!.intensity = 500.0
        sunlightNode.light!.categoryBitMask = 2
        sunlightNode.light!.castsShadow = true
        sunlightNode.position = SCNVector3(x: 0.0, y: 8.0, z: 15)
        scene.rootNode.addChildNode(sunlightNode)


        // This code is needed for placing the overlay text.
        let screenSize: CGSize =  UIScreen.main.bounds.size

        // Find the center of the screen
        let screenCenter: CGPoint = CGPoint(x: screenSize.width/2, y: screenSize.height/2)

        // Give the overlayScene property a size.
        overlayScene.size = CGSize(width: screenSize.width, height: screenSize.height)


        // Add-in SKLabelNode for the light currently in use
        lightTextNode.name = "SunlightTypeTextNode"
        lightTextNode.text = sunlightNode.light!.type.rawValue
        lightTextNode.fontSize = 30
        lightTextNode.fontColor = .white
        lightTextNode.position = CGPoint(x: screenCenter.x,
                                         y:  50)
        overlayScene.addChild(lightTextNode)

        scnView.overlaySKScene = overlayScene

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

        toggleBuzzFaceLamp(scnView)

        toggleSunlight(scnView)
    }


    
    func toggleBuzzFaceLamp(_ scnView: SCNView) {
        let lightNode = scnView.scene!.rootNode.childNode(withName: "BuzzFaceLight", recursively: true)

        lightNode!.isHidden = lightSwitch
    }



    func toggleSunlight(_ scnView: SCNView) {
        switch sunlightSwitch {
        case 0:
            sunlightNode.light?.type = .directional
            lightTextNode.text = sunlightNode.light?.type.rawValue
        case 1:
            sunlightNode.light?.type = .spot
            lightTextNode.text = sunlightNode.light?.type.rawValue
        case 2:
            sunlightNode.light?.type = .omni
            lightTextNode.text = sunlightNode.light?.type.rawValue
        case 3:
            sunlightNode.light?.type = .ambient
            lightTextNode.text = sunlightNode.light?.type.rawValue
        default:
            sunlightNode.light?.type = .directional
            lightTextNode.text = sunlightNode.light?.type.rawValue
        }
    }



    
    class Coordinator: NSObject {

        @Binding var lightSwitch: Bool
        @Binding var sunlightSwitch: Int

        var scnView: SceneKitView

        init(_ scnView: SceneKitView, lightSwitch: Binding<Bool>, sunlightSwitch: Binding<Int>) {
            self.scnView = scnView
            self._lightSwitch = lightSwitch
            self._sunlightSwitch = sunlightSwitch
        }
    }
}
