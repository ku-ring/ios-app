import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Teamplate for feature modules",
    attributes: [
        nameAttribute
    ],
    items: [
        .string(
            path: "Features/\(nameAttribute)Features/Project.swift",
            contents:
                """
                let project = Project.make(
                    for: .feature,
                    name: "\(nameAttribute)Features",
                    bundleId: bundleId_release,
                    dependencies: [
                        .external(name: "ComposableArchitecture"),
                    ]
                )
                """
        ),
        .string(
            path: "Features/\(nameAttribute)Features/Sources/\(nameAttribute)Features.swift",
            contents: 
                """
                //  \(nameAttribute)Features.swift
                //  This file can be safely deleted or expanded.
                //
                //  Created by Tuist™️
                //
                """
        )
    ]
)
