import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")
let exampleAttribute: Template.Attribute = .optional("example", default: .boolean(false))

let template = Template(
    description: "Template for UI modules",
    attributes: [
        nameAttribute,
        exampleAttribute
    ],
    items: [
        .string(
            path: "UIKit/\(nameAttribute)UI/Project.swift",
            contents:
                """
                import ProjectDescription
                import ProjectDescriptionHelpers
                
                let project = Project.make(
                    for: .ui,
                    name: "\(nameAttribute)UI",
                    bundleId: bundleId_release,
                    dependencies: [
                        .project(target: "ColorSet", path: "../ColorSet")
                    ],
                    needsExample: \(exampleAttribute)
                )
                """
        ),
        .string(
            path: "UIKit/\(nameAttribute)UI/Sources/\(nameAttribute)UI.swift",
            contents:
                """
                //  \(nameAttribute)UI.swift
                //  This file can be safely deleted or expanded.
                //
                //  Created by Tuist™️
                //
                """
        ),
        .directory(
            path: "UIKit/\(nameAttribute)UI/",
            sourcePath: "Resources"
        ),
        .string(
            path: "UIKit/\(nameAttribute)UI/Example/Example.swift",
            contents:
                """
                import SwiftUI

                @main
                struct \(nameAttribute)App: App {
                    var body: some Scene {
                        WindowGroup {
                            Text("Hello, World! - \(nameAttribute)UI")
                        }
                    }
                }
                """
        )
    ]
)
