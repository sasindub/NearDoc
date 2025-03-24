import SwiftUI

// MARK: - BottomNavBar Component
struct BottomNavBar: View {
    let activeTab: String
    
    var body: some View {
        HStack(spacing: 0) {
            // Home Button
            NavigationLink(destination: ContentView()) {
                VStack {
                    Image(systemName: "house.fill")
                        .font(.system(size: 20))
                    Text("Home")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(activeTab == "Home" ? .blue : .gray)
            }
            
            // Appointments Button
            NavigationLink(destination: ContentView()) {
                VStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                    Text("Appointments")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(activeTab == "Appointments" ? .blue : .gray)
            }
            
            // Medications Button
            NavigationLink(destination: ContentView()) {
                VStack {
                    Image(systemName: "pills.fill")
                        .font(.system(size: 20))
                    Text("Medications")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(activeTab == "Medications" ? .blue : .gray)
            }
            
            // Dispensaries Button
            NavigationLink(destination: ContentView()) {
                VStack {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 20))
                    Text("Dispensaries")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(activeTab == "Dispensaries" ? .blue : .gray)
            }
        }
        .padding(.vertical, 15)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray5)),
            alignment: .top
        )
    }
}

// MARK: - Preview for BottomNavBar
struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar(activeTab: "Home") // Preview with "Home" as active
            .previewLayout(.sizeThatFits)
            .frame(height: 80)
    }
}
