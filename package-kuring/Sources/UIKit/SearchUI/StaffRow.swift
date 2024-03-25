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
                .font(.system(size: 16))
                .foregroundStyle(Color.Kuring.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())

            Text("\(staff.deptName) · \(staff.collegeName)")
                .font(.system(size: 14))
                .foregroundStyle(Color.Kuring.caption1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
    }
}

#Preview {
    StaffRow(staff: Staff.random())
}
