extension LeLabo {
    struct TestStatus {
        var isBetaAEnabled: Bool
    }
}

extension LeLabo {
    public static var testValue = {
        var status = TestStatus(isBetaAEnabled: false)
        return LeLabo(
            status: { _ in
                return status.isBetaAEnabled
            },
            set: { newValue, _ in
                status.isBetaAEnabled = newValue
            }
        )
    }()
}
