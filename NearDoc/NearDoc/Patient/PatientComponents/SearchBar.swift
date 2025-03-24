import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search doctor, dispensary, or appointment", text: $searchText)
                .font(.subheadline)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
}

struct PatientDashboardView_Preview: PreviewProvider {
    static var previews: some View {
        PatientDashboardView()
    }
}
