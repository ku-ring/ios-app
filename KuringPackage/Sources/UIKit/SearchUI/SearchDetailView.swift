import Models
import SwiftUI
import SearchFeatures
import ComposableArchitecture

public struct StaffDetailView: View {
    let store: StoreOf<StaffDetailFeature>
    
    public var body: some View {
        List {
            Text(store.staff.name)
                .font(.system(size: 20, weight: .bold))
                .listRowSeparator(.hidden)
            
            Text("\(store.staff.deptName) · \(store.staff.collegeName)")
                .foregroundStyle(.secondary)
                .listRowSeparator(.hidden)
            
            Label(store.staff.email, systemImage: "envelope")
                .listRowSeparator(.hidden)
            
            Label(store.staff.lab, systemImage: "mappin.and.ellipse")
                .listRowSeparator(.hidden)
            
            Label(store.staff.phone, systemImage: "phone")
                .listRowSeparator(.hidden)
            
            Label(store.staff.major, systemImage: "book")
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    public init(store: StoreOf<StaffDetailFeature>) {
        self.store = store
    }
}

#Preview {
    StaffDetailView(
        store: Store(
            initialState: StaffDetailFeature.State(staff: .random()),
            reducer: { StaffDetailFeature() }
        )
    )
}
