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

    var changingLightNode: SCNNode = SCNNode()

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

        changingLightNode.name = "ChangingLightNode"
        changingLightNode.light = SCNLight()
        changingLightNode.light!.type = .directional
        changingLightNode.light!.intensity = 500.0
        changingLightNode.light!.categoryBitMask = 2
        changingLightNode.light!.castsShadow = true
        changingLightNode.position = SCNVector3(x: 0.0, y: 8.0, z: 15)
        scene.rootNode.addChildNode(changingLightNode)


        // Configure camera within view
        scnView.pointOfView = cameraNode

        let screenSize: CGSize =  UIScreen.main.bounds.size

        // Find the center of the screen
        let screenCenter: CGPoint = CGPoint(x: screenSize.width/2, y: screenSize.height/2)

        //createOverlayScene(overlayScene: overlayScene, screenSize: screenSize)
        overlayScene.size = CGSize(width: screenSize.width, height: screenSize.height)

        // Add-in SKLabelNode for the light currently in use
        lightTextNode.name = "SunlightTypeTextNode"
        lightTextNode.text = changingLightNode.light!.type.rawValue
        lightTextNode.fontSize = 20
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
        let sunlightNode = scnView.scene!.rootNode.childNode(withName: "ChangingLightNode", recursively: true)
        //let sunlightTypeTextNode = scnView.scene!.rootNode.childNode(withName: "SunlightTypeTextNode", recursively: true)!

        
        //print(sunlightTypeTextNode)

        switch sunlightSwitch {
        case 0:
            sunlightNode!.light?.type = .directional
            //sunlightTypeTextNode.text = sunlightNode!.light?.type.rawValue
        case 1:
            sunlightNode!.light?.type = .spot
            //sunlightTypeTextNode.text = sunlightNode!.light?.type.rawValue
        case 2:
            sunlightNode!.light?.type = .omni
            //sunlightTypeTextNode.text = sunlightNode!.light?.type.rawValue
        case 3:
            sunlightNode!.light?.type = .ambient
            //sunlightTypeTextNode.text = sunlightNode!.light?.type.rawValue
        default:
            sunlightNode!.light?.type = .directional
            //sunlightTypeTextNode.text = sunlightNode!.light?.type.rawValue
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


        @objc func updateBuzzFaceLamp(sender: Any) {
            if scnView.lightSwitch {
                print("Light Switch Hit Bigley!")
            }
        }
    }
}
