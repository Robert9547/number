//
//  ContentView.swift
//  number
//
//  Created by 賴冠宏 on 2022/4/19.
//

import SwiftUI

struct Data: Identifiable{
    let id = UUID()
    var name: Int
}

struct ContentView: View {
    @State private var puzzle = [Data]()
    @State private var number = 1
    @State private var score = 0
    @State private var isFull = false
    @State private var showAlert = false
    func initial(){
        number = 1
        score = 0
        isFull = false
        puzzle.removeAll()
        for i in 1...25{
            if(i==12){
                puzzle.append(Data(name: 1))
            }
            else{
                puzzle.append(Data(name: -1))
            }
        }
        //.background("Image")
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Image")!)
    }
    
    func random(){
        number = Int.random(in: 1..<4)
    }
    
    func addNumber(index: Int){
//        if(number)==1{
//            datas[index].name = "\(number)"
//
//        }
//        if(number)==2{
//            datas[index].name = "\(number)"
//
//        }
//        if(number)==3{
//            datas[index].name = "\(number)"
//
//        }
//        if(number)==4{
//            datas[index].name = "\(number)"
//
//        }
        puzzle[index].name = number
    }
    
    func game(index: Int){
        let up = index - 5
        let down = index + 5
        let right = index + 1
        let left = index - 1
        
        var target = puzzle[index].name
        var originScore = score
        
        while true{
            
            if(up >= 0 && target == puzzle[up].name){
                puzzle[up].name = -1
                score += 1
            }
            if(down <= 24 && target == puzzle[down].name){
                puzzle[down].name = -1
                score += 1
            }
            if(right<25 && index%5 < right%5 && target == puzzle[right].name){
                puzzle[right].name = -1
                score += 1
            }
            if(left>=0 && index%5 > left%5 && target == puzzle[left].name){
                puzzle[left].name = -1
                score += 1
            }
            if(score>originScore){
                puzzle[index].name = target + 1
                originScore = score
                target = puzzle[index].name
                isFull = false
            }
            else{
                break
            }
        }
    }
    
    func judgeFull()->Bool{
        var isFull = true
        for i in 0..<25{
            if(puzzle[i].name == -1){
                isFull = false
                break
            }
        }
        return isFull
    }
    
    var body: some View {
        
        VStack{
            Button("START"){
                showAlert = true
                initial()
            }
            
            .padding()
            .background(Color.orange)
            .cornerRadius(30)
            .foregroundColor(.white)
            .padding(7)
            .overlay(
                RoundedRectangle(cornerRadius:40)
                    .stroke(Color.orange, lineWidth: 3)
            )
            ZStack{
                
            }
            ZStack(alignment:.top){
                Text("      \(score)      ")
                    .font(.title)
                    .background(Image("score").resizable().scaledToFill())
                    .offset(x: 0, y: 10)
            }
            ZStack{
                Text("\(number)")
                    .font(.title)
                    .overlay(Image("\(number)").resizable().scaledToFill())
                    .offset(x: 0, y: 430)
            }
            let columns = Array(repeating: GridItem(), count: 5)
            LazyVGrid(columns: columns) {
                ForEach(Array(puzzle.enumerated()), id: \.element.id) { index, data in
                    if(data.name == -1){
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(height: 60)
                            .padding(3)
                            .onTapGesture {
                                if(data.name == -1){
                                    addNumber(index: index)
                                    random()
                                    game(index: index)
                                    isFull = judgeFull()
                                }
                        }
                    }
                    else{
                        if(data.name>=5){
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(height: 60)
                                .padding(3)
                                .overlay(Image("5").resizable())
                                .overlay(Text("\(data.name)"))
                        }
                        else{
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(height: 60)
                                .padding(3)
                                .overlay(Image("\(data.name)").resizable().scaledToFill())
                                .overlay(Text("\(data.name)"))
                        }
                    }
                }
            }
            .alert(isPresented: $isFull, content: {
                 let answer = "Your Score : \(score)!!"
                 return Alert(title: Text(answer), message: Text(""), primaryButton: .default(Text("ok"), action: {
                                print("ok")
                            }), secondaryButton: .default(Text("restart"), action: {
                                print("restart")
                                initial()
                            }))
            }) 
        }.background(Image("Image").resizable().scaledToFill())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
