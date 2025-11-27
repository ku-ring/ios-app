import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Template for Shared modules",
    attributes: [
        nameAttribute
    ],
    items: [
        .string(
            path: "Shared/\(nameAttribute)/Project.swift",
            contents:
                """
                import ProjectDescription
                import ProjectDescriptionHelpers
                
                let project = Project.make(
                    for: .core,
                    name: "\(nameAttribute)",
                    bundleId: bundleId_release,
                    dependencies: []
                )
                """
        ),
        .string(
            path: "Shared/\(nameAttribute)/Sources/\(nameAttribute).swift",
            contents:
                """
                //  \(nameAttribute).swift
                //  This file can be safely deleted or expanded.
                //
                //  Created by Tuist™️
                //
                """
        )
    ]
)
