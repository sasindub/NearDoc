//import SwiftUI
//
//struct HeaderView: View {
//    let profileImageName: String
//    let userName: String
//    let notificationCount: Int
//    let notificationAction: () -> Void
//    @Binding var searchQuery: String
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) { // Use VStack with spacing for separation
//            HStack {
//                Image(profileImageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 50, height: 50)
//                    .clipShape(Circle())
//
//                VStack(alignment: .leading, spacing: 2) {
//                    Text("Welcome Back")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    Text(userName)
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                }
//
//                Spacer()
//
//                Button(action: notificationAction) {
//                    ZStack(alignment: .topTrailing) {
//                        Image(systemName: "bell.fill")
//                            .font(.title2)
//                            .foregroundColor(.black)
//
//                        if notificationCount > 0 {
//                            Text("\(notificationCount)")
//                                .font(.caption2)
//                                .foregroundColor(.white)
//                                .padding(4)
//                                .background(Color.red)
//                                .clipShape(Circle())
//                                .offset(x: 8, y: -8)
//                        }
//                    }
//                }
//            }
//            
//            SearchBar(searchText: $searchQuery)
//                .padding(.top,10)
//        }
//        .padding(.horizontal)
//        .padding(.top, 0)
//        .padding(.bottom, 17)
//        .background(Color.white.edgesIgnoringSafeArea(.top))
//    }
//}
//
//struct PatientDashboardView_Preview1: PreviewProvider {
//    static var previews: some View {
//        PatientDashboardView()
//    }
//}
