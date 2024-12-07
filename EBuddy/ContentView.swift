//
//  ContentView.swift
//  EBuddy
//
//  Created by Vincent on 04/12/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = EBuddyViewModel()
    @State var image: UIImage = UIImage()
    private let pageWidth: CGFloat = UIScreen.main.bounds.width
    private let pageHeight: CGFloat = UIScreen.main.bounds.height
    @State var scrollPosition: Int?
    @State var showImagePicker: Bool = false
    
    @State var offsetX: CGFloat = 0.0
    @Environment(\.colorScheme) var colorScheme
        
    var currentPage: Int {
        return Int(round(-offsetX / UIScreen.main.bounds.width))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    if let user = viewModel.users {
                        ForEach(0..<user.count, id:\.self) { index in
                            VStack(alignment: .leading) {
                                // top view
                                HStack(alignment: .center) {
                                    HStack {
                                        Text("Zynx")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 8))
                                        Image(systemName: "circle.fill")
                                            .foregroundStyle(.green)
                                    }
                                    Spacer()
                                    HStack {
                                        Image(
                                            "verified-acc", bundle: nil)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                        Image("ig-black", bundle: nil)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                }
                                .frame(height: 100)
                                
                                ZStack(alignment: .bottomLeading) {
                                    // middle view / photo
                                    ZStack(alignment: .top) {
                                        Button(action: {
                                            self.showImagePicker.toggle()
                                        }) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: pageWidth-10, height: 400, alignment: .top)
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                                .onChange(of: currentPage) { currPage in
                                                    self.changeImage(index: currPage)
                                                }
                                        }
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "bolt")
                                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                            
                                            Text("Available Today!")
                                                .fontWeight(.bold)
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                        .background {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.white.opacity(0.3))
                                                .blur(radius: 1)
                                        }
                                    }
                                    .padding(.top, 20)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                    }
                                    
                                    // game image
                                    HStack(alignment: .bottom) {
                                        ZStack(alignment: .leading) {
                                            Image("cod", bundle: nil)
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .aspectRatio(contentMode: .fit)
                                                .background {
                                                    Circle()
                                                        .fill(LinearGradient(colors: [.orange, .red, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                }
                                                .clipped()
                                            
                                            ZStack {
                                                Image("mole", bundle: nil)
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                    .aspectRatio(contentMode: .fit)
                                                    .background {
                                                        Circle()
                                                    }
                                                    .clipped()
                                                Text("+3")
                                                    .frame(width: 80, height: 80)
                                                    .foregroundStyle(Color(colorScheme == .light ? .black : .white))
                                                    .background {
                                                        Circle()
                                                            .fill(Color(colorScheme == .light ? .white.withAlphaComponent(0.5) : .black.withAlphaComponent(0.5)))
                                                    }
                                            }
                                            .padding(.leading, 60)
                                            
                                        }
                                        Spacer()
                                        Image(systemName: "waveform")
                                            .imageScale(.large)
                                            .frame(width: 80, height: 80)
                                            .foregroundStyle(.white)
                                            .background {
                                                Circle()
                                                    .fill(LinearGradient(colors: [.orange, .red, .purple], startPoint: .topTrailing, endPoint: .bottomLeading))
                                            }
                                        
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: -40, trailing: 20))
                                }
                                Spacer()
                                    .frame(height: 50)
                                // bottom star and hour info
                                HStack {
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundStyle(.yellow)
                                    Text("4.9").font(.title2)
                                        .fontWeight(.bold)
                                    +
                                    Text(" (61)").font(.title2)
                                        .fontWeight(.light)
                                        .foregroundColor(.gray)
                                }
                                .padding(.bottom, 10)
                                
                                HStack {
                                    Image(systemName: "snowflake")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundStyle(.yellow)
                                    Text("110").font(.title2)
                                        .fontWeight(.bold)
                                    +
                                    Text(".00/1Hr")
                                        .fontWeight(.light)
                                }
                            }
                            .read(offsetX: $offsetX)
                            .padding(.horizontal, 10)
                        }
                        .frame(width: pageWidth, height: pageHeight, alignment: .top)
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: .photoLibrary) { image in
                        self.image = image
                        self.viewModel.uploadImage(child: viewModel.users?[currentPage].uid ?? "", image: image) { url in
                            print("url", url)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollPosition)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .safeAreaPadding(.top, 120)
        }
        .navigationBarTitle("EBuddy")
        .background {
            Color(colorScheme == .light ? .white : .black)
        }
        .onAppear() {
            self.viewModel.fetchData(completion: {
                self.changeImage(index: 0)
            })
        }
    }
    
    func changeImage(index: Int) {
        let base64 = viewModel.users?[index].profilePic ?? ""
        let dataDecoded : Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)
        self.image = decodedimage ?? UIImage()
    }
}

#Preview {
    ContentView()
}


struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
    
    final class Coordinator: NSObject,
                             UINavigationControllerDelegate,
                             UIImagePickerControllerDelegate {
        
        @Binding
        private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void
        
        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            onImagePicked(uiImage)
            presentationMode.dismiss()
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
}

extension View {
    func read(offsetX: Binding<CGFloat>) -> some View {
        self
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ViewOffsetXKey.self, value: geo.frame(in: .global).minX)
                }
                    .onPreferenceChange(ViewOffsetXKey.self) { minX in
                        let diff = abs(offsetX.wrappedValue - minX)
                        if diff > 1.0 {
                            offsetX.wrappedValue = minX
                            print("readOffsetX: \(offsetX.wrappedValue)")
                        }
                    }
            )
    }
}

struct ViewOffsetXKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
