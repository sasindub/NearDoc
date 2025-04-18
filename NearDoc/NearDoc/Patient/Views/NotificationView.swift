import SwiftUI

struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var notifications: [NotificationItem] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String = ""
    
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
        .alert(isPresented: .constant(!errorMessage.isEmpty)) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")) {
                    errorMessage = ""
                }
            )
        }
    }
    
    // Backend integration for loading notifications
    private func loadNotifications() {
        isLoading = true
        errorMessage = ""
        
        NetworkManager.shared.fetchData(endpoint: "/notifications?forDoctor=false") { (result: Result<[NotificationItem], Error>) in
            self.isLoading = false
            
            switch result {
            case .success(let notificationItems):
                self.notifications = notificationItems
            case .failure(let error):
                self.errorMessage = "Failed to load notifications: \(error.localizedDescription)"
            }
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
    let notification: NotificationItem
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
