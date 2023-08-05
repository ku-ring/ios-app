import ProjectDescription

extension Project {
    public static func make(
        name: String,
        packages: [Package] = [],
        targets: [Target] = [],
        additionalFiles: [FileElement] = []
    ) -> Project {
        return Project(
            name: name,
            organizationName: "Team.Kuring",
            options: .options(
                disableBundleAccessors: true,
                disableSynthesizedResourceAccessors: true
            ),
            packages: packages,
            targets: targets,
            additionalFiles: additionalFiles
        )
    }
}
