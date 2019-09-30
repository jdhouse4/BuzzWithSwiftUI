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

    var lightIndex: Int = 0 // Directional

    var lightBulbImageNode: SKSpriteNode = SKSpriteNode(imageNamed: "lightbulbHighlighted")

    var lightSwitchImageNode: SKSpriteNode = SKSpriteNode(imageNamed: "lightSwitchHighlighted")

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

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 20)

        changingLightNode.light = SCNLight()
        changingLightNode.light!.name = "ChangingLightNode"
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

        // Add-in SKLabelNode for the title
        let headerTextNode = SKLabelNode(fontNamed: "HelveticaNeue")
        headerTextNode.text = "Light Rendering Issues"
        headerTextNode.fontSize = 24
        headerTextNode.fontColor = SKColor.white
        headerTextNode.position = CGPoint(
            x: screenCenter.x,
            y: screenSize.height - 75.0)
        overlayScene.addChild(headerTextNode)

        //Add-in the SKSpriteNode for the button to change the light type
        lightBulbImageNode.name = "lightBulbImageNode"
        lightBulbImageNode.xScale = 2.0
        lightBulbImageNode.yScale = 2.0
        lightBulbImageNode.position = CGPoint(
            x: screenCenter.x * 1.5,
            y: 100)
        overlayScene.addChild(lightBulbImageNode)

        lightSwitchImageNode.name = "lightSwitchImageNode"
        lightSwitchImageNode.xScale = 2.0
        lightSwitchImageNode.yScale = 2.0
        lightSwitchImageNode.position = CGPoint(
            x: screenCenter.x * 0.5,
            y: 100)
        overlayScene.addChild(lightSwitchImageNode)

        // Add-in SKLabelNode for the light currently in use
        lightTextNode.text = changingLightNode.light!.type.rawValue
        lightTextNode.fontSize = 20
        lightTextNode.fontColor = .white
        lightTextNode.position = CGPoint(x: screenCenter.x,
                                         y:  lightBulbImageNode.position.y + lightBulbImageNode.frame.size.height / 2.0)
        overlayScene.addChild(lightTextNode)

        let tappedGesture = UITapGestureRecognizer(target: context.coordinator,
                                                   action: #selector(Coordinator.buttonTapped(gesture:)))


        scnView.addGestureRecognizer(tappedGesture)

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
    }


    
    func toggleBuzzFaceLamp(_ scnView: SCNView) {
        let lightNode = scnView.scene!.rootNode.childNode(withName: "BuzzFaceLight", recursively: true)

        lightNode!.isHidden = lightSwitch
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


        @objc func buttonTapped(gesture: UITapGestureRecognizer) {
            print("Button tapped")

            // Retrieve the SKScene.
            let scnOverlayScene: SKScene = scnView.overlayScene

            // Determine the location within the view the gesture occured.
            let p = gesture.location(in: gesture.view)

            // Convert the node tapped from  view coords to scene coords.
            let hitResult = scnOverlayScene.convertPoint(fromView: p)

            // Determine which node was tapped.
            let hitNode = scnOverlayScene.atPoint(hitResult)

            // But first, set-up a sequence of SKAction events.
            let lightBulbAction = SKAction.sequence(
                [SKAction.scaleX(to: 0, duration: 0.05),
                 SKAction.scale(to: 2, duration: 0.05)
            ])


            // Give the user some indication which sprite was touched.
            if hitNode.name == "lightBulbImageNode"
            {

                // Run the SKAction
                scnView.lightBulbImageNode.run(lightBulbAction)

                // Increment the lightIndex
                scnView.lightIndex += 1

                if scnView.lightIndex == 4
                {
                    scnView.lightIndex = 0
                }

                switch scnView.lightIndex {
                case 0:
                    scnView.changingLightNode.light?.type = .directional
                    scnView.lightTextNode.text = scnView.changingLightNode.light?.type.rawValue
                case 1:
                    scnView.changingLightNode.light?.type = .spot
                    scnView.lightTextNode.text = scnView.changingLightNode.light?.type.rawValue
                case 2:
                    scnView.changingLightNode.light?.type = .omni
                    scnView.lightTextNode.text = scnView.changingLightNode.light?.type.rawValue
                case 3:
                    scnView.changingLightNode.light?.type = .ambient
                    scnView.lightTextNode.text = scnView.changingLightNode.light?.type.rawValue
                default:
                    scnView.changingLightNode.light?.type = .directional
                    scnView.lightTextNode.text = scnView.changingLightNode.light?.type.rawValue
                }
            }

            if hitNode.name == "lightSwitchImageNode"
            {
                scnView.lightSwitchImageNode.run(lightBulbAction)

                let lightNode = scnView.scene.rootNode.childNode(withName: "BuzzFaceLight", recursively: true)

                // Toggle Buzz' face lamp
                scnView.lightSwitch.toggle()

                lightNode!.isHidden = scnView.lightSwitch
            }
        }



        @objc func updateBuzzFaceLamp(sender: Any) {
            if scnView.lightSwitch {
                print("Light Switch Hit Bigley!")
            }
        }
    }
}
