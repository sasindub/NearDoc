import SwiftUI

// Move NotificationItem outside of NotificationsView
struct NotificationItem: Identifiable {
    let id: String
    let title: String
    let message: String
    let date: Date
    var isRead: Bool
}

struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var notifications: [NotificationItem] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack {
            // Navigation Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Notifications")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    // Mark all as read
                    markAllAsRead()
                }) {
                    Text("Mark all as read")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if notifications.isEmpty {
                Spacer()
                Text("No notifications")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(notifications) { notification in
                            NotificationCard(notification: notification) {
                                markAsRead(notificationId: notification.id)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .onAppear {
            loadNotifications()
        }
    }
    
    // Mock backend integration for notifications
    private func loadNotifications() {
        isLoading = true
        
        // Simulate network call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Generate mock notifications
            self.notifications = [
                NotificationItem(
                    id: "1",
                    title: "Your appointment is confirmed",
                    message: "Your appointment with Dr. John Smith on April 22, 2025 is confirmed.",
                    date: Date().addingTimeInterval(-86400),
                    isRead: true
                ),
                NotificationItem(
                    id: "2",
                    title: "Reminder: Your turn is approaching",
                    message: "Please be at the MedicalOne Center in the next 30 minutes.",
                    date: Date().addingTimeInterval(-172800),
                    isRead: false
                ),
                NotificationItem(
                    id: "3",
                    title: "Prescription updated",
                    message: "Dr. Richard Wilson has updated your prescription. Check medications.",
                    date: Date().addingTimeInterval(-259200),
                    isRead: false
                ),
                NotificationItem(
                    id: "4",
                    title: "Payment successful",
                    message: "Your payment of $120 for appointment with Dr. Susan Taylor has been received.",
                    date: Date().addingTimeInterval(-345600),
                    isRead: true
                )
            ]
            
            self.isLoading = false
        }
    }
    
    // Mark a notification as read
    private func markAsRead(notificationId: String) {
        if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
            notifications[index].isRead = true
        }
    }
    
    // Mark all notifications as read
    private func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }
}

// Notification card component
struct NotificationCard: View {
    let notification: NotificationItem  // Now this works because NotificationItem is in scope
    let onTapped: () -> Void
    
    var body: some View {
        Button(action: onTapped) {
            HStack(alignment: .top, spacing: 15) {
                Image(systemName: "bell.fill")
                    .font(.title2)
                    .foregroundColor(notification.isRead ? .gray : .blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(notification.title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text(notification.message)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    
                    Text(relativeTime(from: notification.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if !notification.isRead {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                }
            }
            .padding()
            .background(notification.isRead ? Color.white : Color(red: 0.88, green: 0.93, blue: 1.0))
            .cornerRadius(10)
        }
    }
    
    // Helper to display relative time
    private func relativeTime(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
