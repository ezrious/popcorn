//
//  ContentView.swift
//  Popcorn
//
//  Created by Christian Kim on 6/2/22.
//

import SwiftUI

func dotifyText(_ words: [String]) -> String{
    
    var withDots = ""
    
    for (index, word) in words.enumerated() {
        withDots += word
        if (index % 2 == 0 && index != words.count - 1) {
            
            withDots += " · "
            
        }
    }
    return withDots
}

func convertCIImageToImage(_ ciImage: CIImage) -> Image{
    return Image(uiImage: UIImage.init(ciImage: ciImage))
}

/*
func applyBottomGradient(_ image: Image, width: CGFloat) -> CIImage? {
    let bottomGradient: CIFilter? = CIFilter(name: "CILinearGradient")
    bottomGradient?.setValue(CIVector(x: width * 0.90 , y: width * 1.75), forKey:"inputPoint0")
    bottomGradient?.setValue(CIVector(x: width * 0.90, y: 0), forKey: "inputPoint1")
    bottomGradient?.setValue(CIColor.black, forKey:"inputColor0")
    bottomGradient?.setValue(CIColor.clear, forKey:"inputColor1")
    
    let composite: CIFilter? = CIFilter(name: "CIMaskedVariableBlur")
    
    print(composite)
    return composite?.outputImage
}
 */

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}


struct TrailerButton: View {
    var body: some View {
        
        Button(
            action: {print("pressed!")},
            label: {
                Image(systemName: "play").foregroundColor(.white)
                Text("Trailer").foregroundColor(.white)
            }
        ).padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(.white, lineWidth: 1))
        
    }
}

struct DetailsButton: View {
    var body: some View {
        Button(
            action: {print("pressed!")},
            label: {
                Text("Details").foregroundColor(.gray)
            }).padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)).overlay(RoundedRectangle(cornerRadius: 3).stroke(.white, lineWidth: 1))
            .background(.white)
    }
}

struct CardOverlay: View {
    
    enum Genre {
        case thriller, horror, drama, action, romance, scifi, kids, fantasy, adventure, mystery, crime, documentary
    }
    
    private var details = ["2020", "8.7", "2 hr 10 min", "Thriller"]
    
    // trailer button
    // share button
    
    var body: some View {
        VStack {
            Spacer()
            Text(dotifyText(details)).foregroundColor(.white).font(.subheadline)
            HStack {
                TrailerButton()
                DetailsButton()
            }
            
            
            
        }
    }
}




struct DraggableCard: View {
    
    @Binding var animateLike: CGFloat
    @Binding var animateDislike: CGFloat
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0.0
    private var imagePath: String = ""
    
    private let STANDARD_POSTER_SIZE = 0.675 //(27 / 40)
    
    
        
    
    init(_ imagePathName: String, animateLike: Binding<CGFloat>, animateDislike: Binding<CGFloat>){
        self.imagePath = imagePathName
        self._animateLike = animateLike
        self._animateDislike = animateDislike
        
        
    }
    
 
    var body: some View {
        let image: Image = Image("\(imagePath)")
        let width: CGFloat = UIScreen.main.bounds.width * 0.90
        
        
        //let ciWithBottomGradient = applyBottomGradient(image, width: width)
        //let finalizedImage = convertCIImageToImage(ciWithBottomGradient!)
        

        ZStack {
            Rectangle().fill(.black)
            image.resizable().padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                .overlay(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .black, location: 0.1),
                            .init(color: .clear, location: 0.9)
                        ]),startPoint: .bottom, endPoint: .top
                    )
                )
                .clipped()
        }.cornerRadius(10)
            .rotationEffect(Angle(degrees: rotation))
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            .offset(offset)
            .gesture(dragGesture)
            .onAppear(perform: {print(UIScreen.main.bounds)})
            
            
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged({(drag) in
                offset = drag.translation
                rotation =  0.0 - ( drag.translation.width / 20.0 )
                print(offset)
            })
            .onEnded({ (_) in
                if (offset.width < -180) {
                    withAnimation(.spring()){
                        offset.width = offset.width - 220
                    }
                }
                else if (offset.width > 180){
                    withAnimation(.spring()){
                        offset.width = offset.width + 220
                    }
                    
                }
                else {
                    withAnimation(.spring()){
                        offset = .zero
                        rotation = 0.0
                        
                    }
                }
                
            })
    }
}





/*
struct WelcomeView: View {
    var body: some View {
        ZStack { //red 0.98 green 0.6 blue 0.6
            Color(.sRGB, red: 0.557, green: 0, blue:  0 ).ignoresSafeArea(.all)
            Image("happypopcorn")
                .resizable().aspectRatio(contentMode: .fit).frame(width: 90, height: 90)
        }
        
    }
}
 
 
 */

struct HomeView: View {
    @State private var animateLike: CGFloat = 0.0
    @State private var animateDislike: CGFloat = 0.0
    
    
    var body: some View {
        VStack {
            HStack {
                Image("happypopcorn").resizable().aspectRatio(contentMode: .fill).frame(width: 40, height: 40)
                Text("popcorn").bold().font(.title).padding([.top, .bottom]).foregroundColor(Color(.sRGB, red: 242/255, green: 82/255, blue: 96/255))
            }
            ZStack {
                DraggableCard("looper", animateLike: $animateLike, animateDislike: $animateDislike)
                //DragCardWrapper(imagePathName: "batman")
                //DragCardWrapper(imagePathName: "looper")
            }
            
            Spacer()
            HStack {
                Spacer()
                Button(
                    action: {print("disliked")},
                    label: {Image(systemName: "xmark").resizable().foregroundColor(.red)}
                ).padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                    //.overlay(Circle().stroke(.red, lineWidth: 1).background(Circle().foregroundColor(.yellow)))
                    //.overlay(Image(systemName: "xmark").foregroundColor(.red))
                    .frame(width: 70, height: 70, alignment: .center)
                
                Spacer()
                Button(
                    action: {print("liked")},
                    label: {Image(systemName: "heart.fill").resizable().foregroundColor(.green)}
                ).padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                    .frame(width: 70, height: 70, alignment: .center)
                    //.overlay(Circle().stroke(.green, lineWidth: 1))
                    
                Spacer()
            }
            
        }.ignoresSafeArea([]).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(.sRGB, red: 30/255, green: 30/255, blue:  30/255 ))
    }
}



struct Test: View {
    
    var body: some View {
        
        Rectangle().fill(.red).frame(width: 100, height: 100, alignment: .center)
       
    }
}
 
struct WelcomeScene_Preview: PreviewProvider {
    static var previews: some View {
       HomeView()
    }
}


