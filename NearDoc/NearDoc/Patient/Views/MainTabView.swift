import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationView {
                    HomeView(isLoggedIn: $isLoggedIn)
                }
                .tag(0)
                
                NavigationView {
                    BookAppointmentView()
                }
                .tag(1)
                
                NavigationView {
                    NotificationsView()
                }
                .tag(2)
                
                NavigationView {
                    MedicationHistoryView()
                }
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(index: 0, selectedTab: $selectedTab, iconName: "house.fill", label: "Home")
            TabBarButton(index: 1, selectedTab: $selectedTab, iconName: "calendar", label: "Booking")
            TabBarButton(index: 2, selectedTab: $selectedTab, iconName: "bell.fill", label: "Notifications")
            TabBarButton(index: 3, selectedTab: $selectedTab, iconName: "pills.fill", label: "Medications")
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: -2)
        .frame(height: 60)
    }
}

struct TabBarButton: View {
    let index: Int
    @Binding var selectedTab: Int
    let iconName: String
    let label: String
    
    var body: some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 22))
                    .foregroundColor(selectedTab == index ? Color.blue : Color.gray)
                
                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(selectedTab == index ? Color.blue : Color.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(isLoggedIn: .constant(true))
    }
}
