import SwiftUI

struct ContentView: View {
    @State private var urlString = "https://www.google.com"
    @State private var userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/605.1.15"
    @State private var backgroundColor: Color = .clear
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text(getCurrentTime())
                        .font(.headline)
                        .padding(.leading, 40)
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Image(systemName: "cellularbars")
                        Image(systemName: "wifi")
                        Image(systemName: "battery.100.bolt")
                            .foregroundColor(.green)
                    }
                    .padding(.trailing, 40)
                }
                .frame(width: (1179/3 - 10), height: 45)
                .background(backgroundColor) // Usa a cor extraída
                
                WebView(url: URL(string: urlString)!, userAgent: userAgent) { color in
                    if color == .clear {
                        // Define a cor padrão com base no modo de cor do sistema
                        self.backgroundColor = colorScheme == .dark ? .black : .white
                    } else {
                        self.backgroundColor = color
                    }
                }
                .frame(width: (1179/3 - 10), height: (2556/3 - 100))
            }
            .clipShape(RoundedRectangle(cornerRadius: 60))
            .offset(y: 0)
            
            Image("iphone_15")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 1179/3, height: 2556/3)
                .allowsHitTesting(false)
        }
        .padding()
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

#Preview {
    ContentView()
}
