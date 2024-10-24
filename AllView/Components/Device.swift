//
//  Device.swift
//  AllView
//
//  Created by Rodrigo Portillo on 06/08/24.
//

import Foundation
import SwiftUI
import WebKit

struct Device: View {
    var model: DeviceProperties
    
    @State private var urlString = "https://www.google.com"
    @State private var textFieldUrl = "https://google.com"
    @State private var domainUri = "google.com";
    @State private var backgroundColor: Color = .white
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var webView: WKWebView?
    @State private var isLandscape = false
    @State private var rotationAngle: Double = 0
    @State private var buttonOpacity = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var width: CGFloat = 500
    @State private var height: CGFloat = 500
    @State private var lWidth: CGFloat = 500
    @State private var lHeight: CGFloat = 500
    @State private var topBarHeight: CGFloat = 100
    @State private var topBarPad: [CGFloat] = [25, 0]
    @State private var browserHeaderHeight: CGFloat = 100
    @State private var ominBar: CGFloat = 40
    @State private var besel: CGFloat = 10
    @State private var bezels: [CGFloat] = [0, 0, 0, 0]
    @State private var calculatedWidth: CGFloat = 500
    @State private var calculatedHeight: CGFloat = 500
    @State private var padWidth: CGFloat = 500
    @State private var padHeight: CGFloat = 500
    @State private var frameWidth: CGFloat = 500
    @State private var frameHeight: CGFloat = 500
    @State private var bezelWidth: CGFloat = 500
    @State private var bezelHeight: CGFloat = 500
    @State private var ratio: CGFloat = 3.0
    @State private var isUrlTyping = false
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    func resetVariables() {
        scale = 1.0
        width = 500
        height = 500
        lWidth = 500
        lHeight = 500
        topBarHeight = 100
        topBarPad = [25, 0]
        browserHeaderHeight = 100
        ominBar = 40
        besel = 10
        bezels = [0, 0, 0, 0]
        calculatedWidth = 500
        calculatedHeight = 500
        padWidth = 500
        padHeight = 500
        frameWidth = 500
        frameHeight = 500
        bezelWidth = 500
        bezelHeight = 500
        ratio = 3.0
        buttonOpacity = 1
    }
    
    var body: some View {
        //Mobile Screen
        VStack(alignment: .leading) {
            VisualEffectBlur(material: .hudWindow)
            ZStack (alignment: .topLeading){
                VStack(spacing: 0) {
                    if(!isLandscape || model.image.contains("ipad")){
                        //Top Header iPhone
                        HStack(alignment: .center) {
                            Spacer()
                                .frame(maxWidth: topBarPad[0])
                            
                            if(model.image.contains("ipad")){
                                Text(getCurrentDateTime())
                                    .font(.system(size: 16))
                                    .padding(.leading, 0)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 0)
                            }else{
                                Text(getCurrentTime())
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .padding(.leading, padWidth)
                                    .padding(.bottom, 0)
                            }
                            Spacer()
                            
                            HStack(spacing: 5) {
                                if (!model.image.contains("mini")){
                                    Image(systemName: "cellularbars")
                                        .font(.system(size: 16))
                                        .fontWeight(.bold)
                                }
                                Image(systemName: "wifi")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                Image(systemName: "battery.100.bolt")
                                    .foregroundColor(.green)
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                
                            }
                            .padding(.trailing, model.image.contains("ipad") ? topBarPad[0] : padWidth / 1.5)
                            .padding(.bottom, 0)
                            if(!model.image.contains("ipad")){
                                Spacer()
                                    .frame(maxWidth: topBarPad[0])
                            }
                        }
                        .padding(.top, topBarPad[1])
                        .frame(width: frameWidth, height:isLandscape ? 0 : topBarHeight )
                        .opacity(isLandscape ? 0 : 1)
                        .background(backgroundColor == .white ? (colorScheme == .dark ? .black : .white) : backgroundColor)
                    }
                    if(isLandscape || model.image.contains("ipad")){
                        //Browser Head (top)
                        HStack(alignment: .center){
                            if(!model.image.contains("ipad")){
                                Spacer()
                            }
                            HStack(alignment: .top, spacing: 15){
                                Button(action: {}){
                                    Image(systemName: "sidebar.leading")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 24))
                                }.disabled(true)
                                    .buttonStyle(BorderlessButtonStyle())
                                Button(action: {
                                    goBack()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 24))
                                        .foregroundColor(canGoBack ? .blue : .gray)
                                }
                                .disabled(!canGoBack)
                                .buttonStyle(BorderlessButtonStyle())
                                Button(action: {
                                    goForward()
                                }) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 24))
                                        .foregroundColor(canGoForward ? .blue : .gray)
                                }
                                .disabled(!canGoForward)
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            
                            
                            HStack(alignment: .center){
                                Image(systemName: "textformat.size")
                                    .font(.system(size: 20))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                if(isUrlTyping){
                                    TextField("", text: $textFieldUrl, onEditingChanged: { isEditing in
                                        if isUrlTyping {
                                            DispatchQueue.main.async {
                                                self.isTextFieldFocused = true
                                            }
                                        }
                                    })
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .font(.system(size: 20))
                                    .padding(5)
                                    .padding(.vertical, 0)
                                    .focused($isTextFieldFocused)
                                    .onAppear {
                                        DispatchQueue.main.async {
                                            self.isTextFieldFocused = true
                                        }
                                    }
                                    .onSubmit {
                                        goToURL(textFieldUrl)
                                    }
                                }else{
                                    Spacer()
                                    Text(domainUri)
                                        .padding(5)
                                        .padding(.vertical, 5)
                                        .multilineTextAlignment(.center)
                                        .onTapGesture {
                                            isUrlTyping = true
                                        }
                                    Spacer()
                                }
                                HStack(spacing: 10){
                                    Image(systemName: "puzzlepiece.extension")
                                        .font(.system(size: 20))
                                        .padding(.vertical, 5)
                                    Button(action: {
                                        webView?.reload()
                                    }){
                                        Image(systemName: "arrow.clockwise")
                                            .font(.system(size: 18))
                                            .foregroundColor(.black)
                                    }.buttonStyle(BorderlessButtonStyle())
                                        .padding(.trailing, 10)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(NSColor.windowBackgroundColor))
                            )
                            .frame(width: !model.image.contains("ipad") ? lWidth / 1.75 : .infinity)
                            HStack(spacing: 10){
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 20))
                                    .padding(.vertical, 5)
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                    .padding(.vertical, 5)
                                Image(systemName: "square.on.square")
                                    .font(.system(size: 20))
                                    .padding(.vertical, 5)
                            }
                            .opacity(0.5)
                            if(!model.image.contains("ipad")){
                                Spacer()
                            }
                        }
                        .padding()
                        .background(colorScheme == .dark ? .black : model.image.contains("ipad") ? .white : Color(NSColor.textBackgroundColor).opacity(0.65))
                        .frame(width: isLandscape ? lWidth : frameWidth, height: model.image.contains("ipad") ? .infinity : browserHeaderHeight / 2)
                    }
                    //Browser Content
                    WebView(url: URL(string: urlString)!, userAgent: model.userAgent, onColorExtracted: { color in
                        DispatchQueue.main.async {
                            withAnimation {
                                self.backgroundColor = color == .white ? (colorScheme == .dark ? .black : .white) : color
                            }
                        }
                    }, canGoBack: $canGoBack, canGoForward: $canGoForward, webView: $webView, buttonOpacity: $buttonOpacity, urlString: $urlString, domainUri: $domainUri)
                    .frame(width: isLandscape ? lWidth : frameWidth, height: isLandscape ? lHeight - (browserHeaderHeight / 2) : buttonOpacity == 0 ? frameHeight + (browserHeaderHeight / 2) : frameHeight + ( isUrlTyping ? ominBar: 0))
                    .padding(0)
                    
                    
                    // .scaleEffect(1 / (scale - 0.5), anchor: .topLeading )
                    let scrollingDown = buttonOpacity == 0
                    if(!isLandscape && !model.image.contains("ipad")){
                        //Browser Header
                        ZStack {
                            if(!isUrlTyping){
                                HStack(alignment: .center){
                                }
                                VStack(alignment: .center) {
                                    if(bezels[3] < 100){
                                        Spacer()
                                            .frame(minHeight: 30 + topBarPad[1])
                                    }
                                    HStack(alignment: .bottom) {
                                        Spacer()
                                        Image(systemName: "doc.text.magnifyingglass")
                                            .font(.system(size: 20))
                                            .opacity(buttonOpacity)
                                        Spacer()
                                        Text(domainUri)
                                            .font(.system(size: scrollingDown ? 13 : 20))
                                            .padding(5)
                                            .onTapGesture {
                                                isUrlTyping = true
                                            }
                                        Spacer()
                                        Button(action: {
                                            webView?.reload()
                                        }){
                                            Image(systemName: "arrow.clockwise")
                                                .font(.system(size: 20))
                                                .opacity(buttonOpacity)
                                        }.buttonStyle(BorderlessButtonStyle())
                                        Spacer()
                                    }
                                    .padding(scrollingDown ? 0 : 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(NSColor.textBackgroundColor).opacity(scrollingDown ? 0 : 1))
                                    )
                                    .frame(maxWidth: .infinity)
                                    .shadow(color: .black.opacity(scrollingDown ? 0 : 0.2), radius: 10, x: 0, y: 0)
                                    
                                    HStack(alignment: .bottom) {
                                        Button(action: {
                                            goBack()
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .font(.system(size: 24))
                                                .foregroundColor(canGoBack ? .blue : .gray)
                                        }
                                        .disabled(!canGoBack)
                                        .buttonStyle(BorderlessButtonStyle())
                                        Spacer()
                                        Button(action: {
                                            goForward()
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 24))
                                                .foregroundColor(canGoForward ? .blue : .gray)
                                        }
                                        .disabled(!canGoForward)
                                        .buttonStyle(BorderlessButtonStyle())
                                        Spacer()
                                        Button(action: {
                                            print("Random button 1 pressed")
                                        }) {
                                            Image(systemName: "square.and.arrow.up")
                                                .font(.system(size: 24))
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        Spacer()
                                        Button(action: {
                                            print("Random button 2 pressed")
                                        }) {
                                            Image(systemName: "book")
                                                .font(.system(size: 24))
                                            // Adicionando opacidade ao botão
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        Spacer()
                                        Button(action: {
                                            print("Random button 3 pressed")
                                        }) {
                                            Image(systemName: "square.on.square")
                                                .font(.system(size: 24))
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .opacity(buttonOpacity)
                                    .frame(height: scrollingDown ? 0 : 40)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    if (bezels[3] < 100 ){
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 160, height: 5)
                                            .foregroundColor(backgroundColor == .white ? (colorScheme == .dark ? .white : .black) : backgroundColor)
                                        Spacer()
                                            .frame(height: 20)
                                    }else{
                                        if (browserHeaderHeight > 140 ){
                                            Spacer()
                                                .frame(height: 10)
                                        }else{
                                            Spacer()
                                                .frame(height: 5)
                                        }
                                    }
                                    
                                }
                                .padding(.horizontal, 30)
                                .frame(width: frameWidth, height: scrollingDown ? (browserHeaderHeight / 2) : browserHeaderHeight)
                                .animation(.easeInOut, value: buttonOpacity)
                            } else {
                                HStack{
                                    Spacer()
                                    HStack(alignment: .center) {
                                        Spacer()
                                        TextField("", text: $textFieldUrl, onEditingChanged: { isEditing in
                                            if isUrlTyping {
                                                DispatchQueue.main.async {
                                                    self.isTextFieldFocused = true
                                                }
                                            }
                                        })
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .font(.system(size: 20))
                                        .padding(5)
                                        .padding(.vertical, 10)
                                        .focused($isTextFieldFocused)
                                        .onAppear {
                                            DispatchQueue.main.async {
                                                self.isTextFieldFocused = true
                                            }
                                        }
                                        .onSubmit {
                                            goToURL(textFieldUrl)
                                        }
                                        Spacer()
                                        Button(action: {
                                            webView?.reload()
                                        }){
                                            Image(systemName: "mic.fill")
                                                .font(.system(size: 20))
                                                .opacity(buttonOpacity)
                                        }.buttonStyle(BorderlessButtonStyle())
                                        Button(action: {
                                            webView?.reload()
                                        }){
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 20))
                                                .opacity(buttonOpacity)
                                        }.buttonStyle(BorderlessButtonStyle())
                                        Spacer()
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(NSColor.textBackgroundColor).opacity(scrollingDown ? 0 : 1))
                                    )
                                    .padding(.horizontal, 10)
                                    Spacer()
                                }
                                .frame(width: frameWidth, height: ominBar + 20)
                                .padding(.vertical, 5)
                            }
                        }
                        .opacity(isLandscape ? 0 : 1)
                        .frame(height: isLandscape ? 0 : .nan)
                    }
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: model.radius))
                //.offset(x: isLandscape ? (bezels[0] - 20) * -1 : 0, y: isLandscape ? ((height / 2) * -1) - 20 : 50)
                .offset(x: isLandscape ? 10 : 0, y: isLandscape ? 40: 30)
                .animation(.easeInOut, value: model.radius) // Adicionando animação
                //.offset(x: isLandscape ? (besel + 20) * -1 : 0)
                ZStack(alignment: .topLeading){
                    VStack{
                        Image(model.image)
                            .resizable()
                            .zIndex(3)
                            .aspectRatio(contentMode: .fill)
                            .allowsHitTesting(false)
                            .animation(.easeInOut, value: isLandscape)
                    }
                }
                .offset(x: isLandscape ? -1 * (bezels[0] + bezelWidth) + bezels[0]: -1 * (bezels[0]), y: isLandscape ? -1 * bezels[1] + 10 : (30 - bezels[1]))
                .frame(width: bezelWidth, height: bezelHeight, alignment: .topLeading)
                .rotationEffect(.degrees(isLandscape ? -90 : 0), anchor: .zero)
                //.scaleEffect(1 / (scale), anchor: .topLeading )
                
                Spacer()
            }
            .padding(0)
            .offset(x: bezels[0], y: bezels[1])
            
            
            Spacer()
        }
        .onAppear {
            calculateDimensions(model: model)
        }
        .scaleEffect(1 / (scale - 0.5), anchor: .topLeading )
        Spacer()
    }
    
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm      EEEE d 'de' MMMM"
        return formatter.string(from: Date())
    }
    private func goToURL(_ txtUrl: String) {
        var urlWithScheme = txtUrl
        if !(txtUrl.hasPrefix("http://") || txtUrl.hasPrefix("https://")) {
            urlWithScheme = "https://\(txtUrl)"
        }
        self.textFieldUrl = urlWithScheme
        self.isUrlTyping = false
        self.isTextFieldFocused = false
        self.urlString = urlWithScheme
    }
    
    private func goBack() {
        webView?.goBack()
        if let url = webView?.url {
            goToURL(url.absoluteString)
        }
    }
    
    private func goForward() {
        webView?.goForward()
        if let url = webView?.url {
            goToURL(url.absoluteString)
        }
    }
    
    func calculateDimensions(model: DeviceProperties) {
        resetVariables()
        bezels = model.bezel
        ominBar = model.ominBar
        topBarHeight = model.topBarHeight
        topBarPad = model.topBarPad
        ratio = model.ratio
        browserHeaderHeight = model.browserHeaderHeight
        calculatedWidth = model.width * (3 / ratio)
        calculatedHeight = model.height * (3 / ratio)
        padWidth = model.padWidth
        padHeight = model.padHeight
        
        if let screen = NSScreen.main {
            scale = screen.backingScaleFactor
            let widthScale = calculatedWidth / screen.visibleFrame.width
            //    let _heightScale = calculatedHeight / screen.visiVisualEffectBlur(material: .hudWindow)bleFrame.height
            
            frameWidth = (calculatedWidth * widthScale + padWidth) / scale
            frameHeight = (((calculatedHeight) * widthScale) / scale) - browserHeaderHeight - topBarHeight
            
            bezelWidth = frameWidth + bezels[0] + bezels[2] ;
            bezelHeight = frameHeight - (bezels[1] + bezels[3]);
            width = (calculatedWidth * widthScale) + bezels[0] + bezels[2]
            height = (calculatedHeight * widthScale) + bezels[1] + bezels[3]
            lWidth = (((calculatedHeight) * widthScale) / scale)
            lHeight = (calculatedWidth * widthScale + padWidth) / scale
        }
    }
}
