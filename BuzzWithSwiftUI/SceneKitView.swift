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
        Coordinator(self)
    }


    // SceneKit Properties
    let scene = SCNScene(named: "Buzz.scn")!

    //lazy var lightNode: SCNNode = scene.rootNode.childNode(withName: "BuzzFaceLight", recursively: true)!

    @Binding var lightTypeIndex: Int

    var lightBulbImageNode: SKSpriteNode = SKSpriteNode(imageNamed: "lightbulb")

    var lightTextNode: SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue")



    func makeUIView(context: Context) -> SCNView {
        // Create and add a camera to the scene
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

        // Create and add to the scene that will be changed to demonstrate the rendering issues.
        let lightNode = scene.rootNode.childNode(withName: "BuzzFaceLight", recursively: true)!
        lightNode.light!.name = "BuzzLight"
        lightNode.light!.type = .directional
        lightNode.light!.intensity = 2000.0
        lightNode.light!.categoryBitMask = 2
        lightNode.light!.castsShadow = true
        lightNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(lightNode)


        // Retrieve Buzz SCNNode
        //let buzz = scene.rootNode.childNode(withName: "Buzz", recursively: true)!

        // animate the 3d object
        //buzz.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 3)))


        // retrieve the SCNView
        let scnView = SCNView()

        // configure the view
        scnView.backgroundColor = UIColor.black

        // Configure camera within view
        scnView.pointOfView = cameraNode

        // SpriteKit Variables
        let overlayScene: SKScene = SKScene()


        // Find the center of the screen
        let screenCenter: CGPoint = overlayScene.view!.center

        // Add-in SKLabelNode for the title
        let headerTextNode = SKLabelNode(fontNamed: "HelveticaNeue")
        headerTextNode.text = "Light Rendering Issues"
        headerTextNode.fontSize = 24
        headerTextNode.fontColor = SKColor.black
        headerTextNode.position = CGPoint(x: screenCenter.x, y: screenSize.height - 75.0)
        overlayScene.addChild(headerTextNode)

        //Add-in the SKSpriteNode for the button to change the light type
        lightBulbImageNode.name = "light"
        lightBulbImageNode.xScale = 2.0
        lightBulbImageNode.yScale = 2.0
        lightBulbImageNode.position = CGPoint(x: screenCenter.x, y: 100)
        overlayScene.addChild(lightBulbImageNode)

        // Add-in SKLabelNode for the light currently in use
        lightTextNode.text = lightNode.light!.type.rawValue
        lightTextNode.fontSize = 20
        lightTextNode.fontColor = .black
        lightTextNode.position = CGPoint(x: screenCenter.x,
                                         y:  lightBulbImageNode.position.y + lightBulbImageNode.frame.size.height / 2.0)
        overlayScene.addChild(lightTextNode)

        let tappedGesture = UITapGestureRecognizer(target: context.coordinator,
                                                   action: #selector(Coordinator.buttonTapped(gesture:)))

        scnView.addGestureRecognizer(tappedGesture)

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




    class Coordinator: NSObject {
        var sceneView: SceneKitView

        init(_ sceneView: SceneKitView) {
            self.sceneView = sceneView

        }

        @objc func buttonTapped(gesture: UITapGestureRecognizer) {
            print("Button tapped")
        }
    }
}
/*
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // Retrieve the current scene's SKScene
        let scnOverlayScene = overlayScene

        // At what CGPoint did the tap occur?
        let p = gestureRecognize.location(in: self.view)

        // Convert the node tapped from view coords to scene coords.
        let hitResult = scnOverlayScene.convertPoint(fromView: p)

        // Now determine which node was tapped.
        let hitNode = scnOverlayScene.atPoint(hitResult)

        // Give the user some indication that the button was tapped.
        if hitNode.name == "light"
        {
            // Highlight the lightBulbImageNode
            // Set-up a sequenc of SKAction events.
            let lightAction = SKAction.sequence(
                [SKAction.scaleX(to: 0, duration: 0.05),
                 SKAction.scale(to: 2, duration: 0.05),
            ])

            // Run the SKAction sequence.
            lightBulbImageNode.run(lightAction)

            // Increment the light type
            lightIndex += 1

            if lightIndex == 4
            {
                lightIndex = 0
            }

            switch lightIndex {
            case 0:
                lightNode.light?.type = .directional
                lightTextNode.text = lightNode.light?.type.rawValue
            case 1:
                lightNode.light?.type = .spot
                lightTextNode.text = lightNode.light?.type.rawValue
            case 2:
                lightNode.light?.type = .omni
                lightTextNode.text = lightNode.light?.type.rawValue
            case 3:
                lightNode.light?.type = .ambient
                lightTextNode.text = lightNode.light?.type.rawValue
            default:
                lightNode.light?.type = .directional
                lightTextNode.text = lightNode.light?.type.rawValue
            }
        }
    }
}
 */


/*
#if DEBUG
struct ScenekitView_Previews : PreviewProvider {
    static var previews: some View {
        SceneKitView(lightNode: <#T##Binding<SCNNode>#>)
    }
}
#endif
*/
