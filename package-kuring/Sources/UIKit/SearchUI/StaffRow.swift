//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI

struct StaffRow: View {
    let staff: Staff

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(staff.name)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())

            Text("\(staff.deptName) · \(staff.collegeName)")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
    }
}

#Preview {
    StaffRow(staff: Staff.random())
}
