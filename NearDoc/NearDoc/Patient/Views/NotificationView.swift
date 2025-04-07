import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Text("Notifications")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.trailing, 24)  // Offset to center the title
            }
            
            Text("New")
                .font(.system(size: 14, weight: .medium))
                .padding(.top, 10)
            
            // New notifications
            VStack(spacing: 15) {
                // Notification 1
                NotificationCard(
                    icon: "circle.fill",
                    title: "Your appointment is confirmed for today at 2:30 PM",
                    description: "Dr. Sarah Wilson - Dental Checkup",
                    time: "10:30 AM",
                    isNew: true
                )
                
                // Notification 2
                NotificationCard(
                    icon: "circle.fill",
                    title: "Reminder: Your turn is approaching",
                    description: "You're 3rd in line. Please be ready.",
                    time: "9:45 AM",
                    isNew: true
                )
            }
            
            Text("Previous Notifications")
                .font(.system(size: 14, weight: .medium))
                .padding(.top, 10)
            
            // Previous notifications
            VStack(spacing: 15) {
                // Notification 3
                NotificationCard(
                    icon: "",
                    title: "Prescription updated",
                    description: "Your prescription has been updated by Dr. Michael Brown",
                    time: "Yesterday at 3:15 PM",
                    isNew: false
                )
                
                // Notification 4
                NotificationCard(
                    icon: "",
                    title: "Payment successful",
                    description: "Payment of $150 for dental cleaning has been processed",
                    time: "Yesterday at 11:30 AM",
                    isNew: false
                )
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
}

struct NotificationCard: View {
    let icon: String
    let title: String
    let description: String
    let time: String
    let isNew: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Blue dot for new notifications
            if isNew {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                    .padding(.top, 6)
            } else {
                // Empty space for alignment
                Circle()
                    .fill(Color.clear)
                    .frame(width: 8, height: 8)
                    .padding(.top, 6)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text(time)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .padding(.top, 2)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(isNew ? Color(.systemGray6) : Color.white)
        .cornerRadius(10)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
