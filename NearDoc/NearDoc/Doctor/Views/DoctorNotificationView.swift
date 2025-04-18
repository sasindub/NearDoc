import SwiftUI

struct DoctorNotificationsView: View {
    let doctorId: String
    
    @State private var notifications: [NotificationItem] = []
    @State private var isLoading = true
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .padding()
            } else if notifications.isEmpty {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "bell.slash.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No Notifications")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("You don't have any notifications at this time.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(notifications) { notification in
                            DoctorNotificationCard(notification: notification) {
                                markAsRead(notificationId: notification.id)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarItems(
            trailing: Button(action: {
                markAllAsRead()
            }) {
                Text("Mark all as read")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        )
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
    
    // Notification card
    private func DoctorNotificationCard(notification: NotificationItem, onTapped: @escaping () -> Void) -> some View {
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
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
        }
    }
    
    // Helper to display relative time
    private func relativeTime(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    // Load notifications from backend
    private func loadNotifications() {
        isLoading = true
        errorMessage = ""
        
        NetworkManager.shared.fetchData(endpoint: "/notifications?forDoctor=true") { (result: Result<[NotificationItem], Error>) in
            self.isLoading = false
            
            switch result {
            case .success(let notifications):
                self.notifications = notifications.sorted(by: { $0.date > $1.date })
            case .failure(let error):
                self.errorMessage = "Failed to load notifications: \(error.localizedDescription)"
            }
        }
    }
    
    // Mark notification as read
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

struct DoctorNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorNotificationsView(doctorId: "1")
    }
}
