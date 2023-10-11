//
//  StaffRow.swift
//  KuringApp
//
//  Created by 🏝️ GeonWoo Lee on 10/3/23.
//
import Model
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
