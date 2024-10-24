import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var windowManager = WindowManager()

    @State private var iPhoneuserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1"
    @State private var selectedDevice = "iPhone 15 Pro Max"
    
    
    var body: some View {
        
        let iphoneModels: [String: DeviceProperties] = [
            "iPhone 15 Pro Max": DeviceProperties(
                image: "iphone_15_pro_max",
                width: 1290,
                height: 2796,
                radius: 60,
                padWidth: 0,
                padHeight: 0,
                ominBar: 45,
                userAgent: iPhoneuserAgent,
                topBarHeight: 70,
                browserHeaderHeight: 150,
                bezel: [40, 35, 40, 25],
                topBarPad: [40, 5],
                ratio: 3.0
            ),
            "iPhone 15 Pro": DeviceProperties(
                image: "iphone_15_pro",
                width: 1179,
                height: 2556,
                radius: 60,
                padWidth: 0,
                padHeight: 0,
                ominBar: 45,
                userAgent: iPhoneuserAgent,
                topBarHeight: 65,
                browserHeaderHeight: 145,
                bezel: [35, 28, 35, 28],
                topBarPad: [30, 12],
                ratio: 3.0
            ),
            "iPhone 15": DeviceProperties(
                image: "iphone_15",
                width: 1179,
                height: 2556,
                radius: 60,
                padWidth: 0,
                padHeight: 0,
                ominBar: 45,
                userAgent: iPhoneuserAgent,
                topBarHeight: 65,
                browserHeaderHeight: 155,
                bezel: [35, 28, 35, 28],
                topBarPad: [30, 12],
                ratio: 3.0
            ),
            "iPhone 15 Plus": DeviceProperties(
                image: "iphone_15_plus",
                width: 1290,
                height: 2796,
                radius: 60,
                padWidth: 0,
                padHeight: 0,
                ominBar: 45,
                userAgent: iPhoneuserAgent,
                topBarHeight: 70,
                browserHeaderHeight: 150,
                bezel: [40, 35, 40, 25],
                topBarPad: [40, 5],
                ratio: 3.0
            ),
            "iPhone 13": DeviceProperties(
                image: "iphone_13",
                width: 1170,
                height: 2532,
                radius: 50,
                padWidth: 0,
                padHeight: 0,
                ominBar: 45,
                userAgent: iPhoneuserAgent,
                topBarHeight: 45,
                browserHeaderHeight: 145,
                bezel: [35, 25, 35, 28],
                topBarPad: [24, 0],
                ratio: 3.0
            ),
            "iPhone 13 Mini": DeviceProperties(
                image: "iphone_13_mini",
                width: 1080,
                height: 2340,
                radius: 35,
                padWidth: 0,
                padHeight: 0,
                ominBar: 45,
                userAgent: iPhoneuserAgent,
                topBarHeight: 40,
                browserHeaderHeight: 140,
                bezel: [24, 24, 24, 28],
                topBarPad: [25, 0],
                ratio: 3.0
            ),
            "iPhone 13 Pro Max": DeviceProperties(
                image: "iphone_13_pro_max",
                width: 1284,
                height: 2778,
                radius: 50,
                padWidth: 320,
                padHeight: 0,
                ominBar: 0,
                userAgent: iPhoneuserAgent,
                topBarHeight: 50,
                browserHeaderHeight: 140,
                bezel: [40, 40, 40, 40],
                topBarPad: [40, 10],
                ratio: 3.0
            ),
            "iPhone SE": DeviceProperties(
                image: "iphone_se",
                width: 750,
                height: 1334,
                radius: 0,
                padWidth: 0,
                padHeight: 320,
                ominBar: 45,
                userAgent: iPhoneuserAgent,
                topBarHeight: 30,
                browserHeaderHeight: 160,
                bezel: [55, 130, 55, 100],
                topBarPad: [20, 0],
                ratio: 2.0
            ),
            "iPhone 8": DeviceProperties(
                image: "iphone_8",
                width: 750,
                height: 1334,
                radius: 0,
                padWidth: 0,
                padHeight: 320,
                ominBar: 45,
                userAgent: iPhoneuserAgent,
                topBarHeight: 30,
                browserHeaderHeight: 130,
                bezel: [45, 130, 45, 100],
                topBarPad: [20, 0],
                ratio: 2.0
            ),
            "iPhone 11": DeviceProperties(
                image: "iphone_11",
                width: 828,
                height: 1792,
                radius: 50,
                padWidth: 10,
                padHeight: 320,
                ominBar: 280,
                userAgent: iPhoneuserAgent,
                topBarHeight: 50,
                browserHeaderHeight: 145,
                bezel: [50, 50, 50, 50],
                topBarPad: [9, 0],
                ratio: 2.0
            ),
            "iPhone 11 Pro Max": DeviceProperties(
                image: "iphone_11_pro_max",
                width: 1242,
                height: 2688,
                radius: 50,
                padWidth: 10,
                padHeight: 320,
                ominBar: 280,
                userAgent: iPhoneuserAgent,
                topBarHeight: 50,
                browserHeaderHeight: 145,
                bezel: [45, 45, 45, 45],
                topBarPad: [25, 0],
                ratio: 2.9
            ),
            "iPhone 11 Pro": DeviceProperties(
                image: "iphone_11_pro",
                width: 1125,
                height: 2436,
                radius: 45,
                padWidth: 10,
                padHeight: 320,
                ominBar: 280,
                userAgent: iPhoneuserAgent,
                topBarHeight: 50,
                browserHeaderHeight: 145,
                bezel: [50, 50, 50, 50],
                topBarPad: [9, 0],
                ratio: 2.7
            ),
            "iPad 10": DeviceProperties(
                image: "ipad",
                width: 1620,
                height: 2160,
                radius: 0,
                padWidth: 60,
                padHeight: 0,
                ominBar: 0,
                userAgent: iPhoneuserAgent,
                topBarHeight: 30,
                browserHeaderHeight: 100,
                bezel: [45, 115, 45, 105],
                topBarPad: [15, 0],
                ratio: 3.0
            ),
            "iPad mini": DeviceProperties(
                image: "ipad_mini",
                width: 1488,
                height: 2266,
                radius: 0,
                padWidth: 0,
                padHeight: 0,
                ominBar: 0,
                userAgent: iPhoneuserAgent,
                topBarHeight: 30,
                browserHeaderHeight: 145,
                bezel: [60, 60, 60, 60],
                topBarPad: [15, 0],
                ratio: 3.0
            ),
            "iPad Pro de 11\"": DeviceProperties(
                image: "ipad_pro_m4_11",
                width: 1668,
                height: 2420,
                radius: 20,
                padWidth: 0,
                padHeight: 0,
                ominBar: 0,
                userAgent: iPhoneuserAgent,
                topBarHeight: 40,
                browserHeaderHeight: 70,
                bezel: [40, 40, 40, 0],
                topBarPad: [25, 0],
                ratio: 3.4
            ),
            "iPad Pro de 13\"": DeviceProperties(
                image: "ipad_pro_m4_13",
                width: 2064,
                height: 2752,
                radius: 40,
                padWidth: 0,
                padHeight: 0,
                ominBar: 0,
                userAgent: iPhoneuserAgent,
                topBarHeight: 50,
                browserHeaderHeight: 70,
                bezel: [50, 50, 50, 50],
                topBarPad: [25, 0],
                ratio: 3.4
            )
        ]

        
        let orderedModels = [
            "iPhone 15 Pro Max",
            "iPhone 15 Pro",
            "iPhone 15",
            "iPhone 15 Plus",
            "iPhone 13",
            "iPhone 13 Mini",
            "iPhone 13 Pro Max",
            "iPhone SE",
            "iPhone 8",
            "iPhone 11",
            "iPhone 11 Pro Max",
            "iPhone 11 Pro",
            "iPad 10",
            "iPad mini",
            "iPad Pro de 11\"",
            "iPad Pro de 13\""
        ]
        
        let model = iphoneModels[selectedDevice]!
        
        GeometryReader { geometry in
            HStack(alignment: .top) {
                //Sidebar
                ZStack{
                    VisualEffectBlur(material: .hudWindow)
                    VStack(alignment: .leading){
                        HStack(alignment: .top){
                            VStack {
                                ForEach(orderedModels, id: \.self) { key in
                                    Button(action: {
                                        selectedDevice = key
                                        windowManager.selectedDevice = iphoneModels[key]
                                    }) {
                                        HStack {
                                            Text(key)
                                                .font(.system(size: 14))
                                                .foregroundColor(selectedDevice == key ? Color.accentColor : .primary)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 4)
                                    }
                                    .padding(0)
                                    .background(selectedDevice == key ? Color.blue.opacity(0.2) : Color.clear)
                                    .cornerRadius(6)
                                }
                            }
                            /*
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isLandscape.toggle()
                                    calculateDimensions(model: model)
                                }
                            }) {
                                Image(systemName: isLandscape ? "iphone.landscape" : "iphone")
                                    .font(.system(size: 18))
                            }.buttonStyle(BorderlessButtonStyle())
                             */
                        }
                        .padding()
                        Spacer()
                    }
                    Spacer()
                }.frame(width: 250)
                
            }//.frame(width: bezelWidth + 300, alignment: .topLeading)
            
        }
        .frame(alignment: .topLeading)
        .frame(width: 250)
    }
    
    
}


extension NSTextField { // << workaround !!!
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

#Preview {
    ContentView()
}

