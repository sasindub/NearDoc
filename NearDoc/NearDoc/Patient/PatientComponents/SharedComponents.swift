import SwiftUI

// Common color palette used across the app
struct AppColors {
    static let primary = Color.blue
    static let success = Color.green
    static let danger = Color.red
    static let warning = Color.orange
    static let background = Color.white
    static let secondaryBackground = Color(.systemGray6)
    static let textPrimary = Color.black
    static let textSecondary = Color.gray
    static let accent = Color.orange
}

// Tab bar component used in multiple screens
//struct AppTabBar: View {
//    @Binding var selectedTab: String
//    
//    var body: some View {
//        HStack {
//            TabBarItem(icon: "house.fill", text: "Home", isSelected: selectedTab == "Home")
//                .onTapGesture { selectedTab = "Home" }
//            
//            TabBarItem(icon: "calendar", text: "Appointments", isSelected: selectedTab == "Appointments")
//                .onTapGesture { selectedTab = "Appointments" }
//            
//            TabBarItem(icon: "pills.fill", text: "Medications", isSelected: selectedTab == "Medications")
//                .onTapGesture { selectedTab = "Medications" }
//            
//            TabBarItem(icon: "building.fill", text: "Dispensaries", isSelected: selectedTab == "Dispensaries")
//                .onTapGesture { selectedTab = "Dispensaries" }
//        }
//        .padding(.top, 10)
//        .background(AppColors.background)
//    }
//}

//struct TabBarItem: View {
//    let icon: String
//    let text: String
//    var isSelected: Bool = false
//    
//    var body: some View {
//        VStack(spacing: 5) {
//            Image(systemName: icon)
//                .font(.system(size: 22))
//            Text(text)
//                .font(.system(size: 10))
//        }
//        .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
//        .frame(maxWidth: .infinity)
//    }
//}

// Common search bar component
//struct SearchBar: View {
//    @Binding var searchText: String
//    var placeholder: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(AppColors.textSecondary)
//            TextField(placeholder, text: $searchText)
//                .font(.system(size: 14))
//        }
//        .padding(10)
//        .background(AppColors.secondaryBackground)
//        .cornerRadius(8)
//    }
//}

// Common button styles
struct PrimaryButton: View {
    var text: String
    var icon: String? = nil
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                }
                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(AppColors.primary)
            .cornerRadius(10)
        }
    }
}

struct DangerButton: View {
    var text: String
    var icon: String? = nil
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                }
                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(AppColors.danger)
            .cornerRadius(10)
        }
    }
}

// Doctor avatar component
struct DoctorAvatar: View {
    var size: CGFloat = 50
    
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: size, height: size)
            .foregroundColor(AppColors.accent)
    }
}

// Navigation header component
struct NavigationHeader: View {
    var title: String
    var showBackButton: Bool = true
    var backAction: () -> Void = {}
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: backAction) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.textPrimary)
                }
            }
            
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.leading, showBackButton ? 8 : 0)
            
            Spacer()
        }
        .padding(.top, 10)
    }
}
