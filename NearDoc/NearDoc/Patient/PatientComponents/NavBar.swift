//import SwiftUI
//
//struct CustomTabBar: View {
//    @Binding var selectedTab: Int
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            TabBarButton(imageName: "house.fill", isSelected: selectedTab == 0) {
//                selectedTab = 0
//            }
//            
//            TabBarButton(imageName: "calendar", isSelected: selectedTab == 1) {
//                selectedTab = 1
//            }
//            
//            TabBarButton(imageName: "message.fill", isSelected: selectedTab == 2) {
//                selectedTab = 2
//            }
//            
//            TabBarButton(imageName: "person.fill", isSelected: selectedTab == 3) {
//                selectedTab = 3
//            }
//        }
//        .padding(.top, 10)
//        .padding(.bottom, 20)
//        .background(Color.white)
//        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: -2)
//    }
//}
//
//struct TabBarButton: View {
//    let imageName: String
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            VStack(spacing: 4) {
//                Image(systemName: imageName)
//                    .font(.system(size: 24))
//                    .foregroundColor(isSelected ? Color.blue : Color.gray)
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//
//struct CustomTabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTabBar(selectedTab: .constant(0))
//            .previewLayout(.sizeThatFits)
//    }
//}
