//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

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
                status.isBetaAEnabled
            },
            set: { newValue, _ in
                status.isBetaAEnabled = newValue
            }
        )
    }()
}
