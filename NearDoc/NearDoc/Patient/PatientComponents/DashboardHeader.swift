import SwiftUI

struct HeaderView: View {
    let profileImageName: String // Name of the profile image asset
    let userName: String        // User's name
    let notificationCount: Int  // Number of notifications
    let notificationAction: () -> Void // Action for the notification button
    
    var body: some View {
        HStack {
            // Profile Image
            Image(profileImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            // Welcome Text and User Name
            VStack(alignment: .leading, spacing: 2) {
                Text("Welcome Back")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(userName)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            // Notification Bell with Red Badge
            Button(action: notificationAction) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .foregroundColor(.black)
                    
                    if notificationCount > 0 {
                        Text("\(notificationCount)")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 8, y: -8)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, -5)
    }
}

// Preview for testing the component
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(
            profileImageName: "profile",           // Replace with your actual asset name
            userName: "Andrew Smith",
            notificationCount: 3,
            notificationAction: { print("Notification tapped") }
        )
    }
}
