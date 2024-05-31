//
//  ContentView.swift
//  Jankenpon
//
//  Created by user256510 on 2/28/24.
//

import SwiftUI

struct Result: View {
    let wOl: String
    
    var body: some View {
        Text(wOl)
            .font(.title2)
    }
}

struct MoveStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 80.0,maxHeight: 80.0)
            .padding()
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
    }
}

extension View {
    func moveStyle() -> some View{
        modifier(MoveStyle())
    }
}

struct ContentView: View {
    let moves = ["rock", "paper", "scizzors"]
    let lose = ["rock": 2, "paper": 0, "scizzors": 1]
    let win = ["rock": 1, "paper": 2, "scizzors": 0]
    let MAX_ROUNDS = 10
    
    @State var shouldWin = Bool.random()
    @State var systemSelection = Int.random(in: 0...2)
    @State var score = 0
    @State var rounds = 1
    
    @State var restart = false
    
    var body: some View {
        
        ZStack{
            LinearGradient(colors: [.purple.opacity(0.8),.indigo.opacity(0.8)], startPoint: .topLeading, endPoint: .trailing)
                .ignoresSafeArea()
            VStack(spacing: 10.0){
                Text("JANKENPON")
                    .font(.largeTitle.weight(.bold))
                Text("Score: \(score)")
                    .font(.title.weight(.medium))
                
                VStack {
                    Result(wOl: shouldWin ? "WIN AGAINST" : "LOSE AGAINST")
                    Result(wOl: moves[systemSelection].uppercased())
                    
                    
                    HStack{
                        ForEach(moves, id: \.self){ move in
                            Button {
                                imageTapped(move)
                            } label: {
                                Image(move)
                                    .resizable()
                                    .moveStyle()
                            }
                            
                        }
                    }
//                    .frame(width: 400, height: 400)
//                    .background(.thinMaterial)
//                    .clipShape(.rect(cornerRadius: 20))
                }
            }
            
        }
        .alert("Restart?", isPresented: $restart) {
            Button("Yes", role:.cancel,action: resetGame)
            Button("No", role:.destructive) {
                //not sure how to end game
            }
        }
    }
    
    func imageTapped(_ userSelection: String){
        if !shouldWin && win[userSelection] == systemSelection{
            score += 1
        }
        else if shouldWin && lose[userSelection] == systemSelection{
            score += 1
        }
        
        if rounds == MAX_ROUNDS{
            restart = true
            rounds = 1
        }
        else{
            rounds += 1
            shouldWin = Bool.random()
            systemSelection = Int.random(in: 0...2)
        }
    }
    
    func resetGame() {
        score = 0
        shouldWin = Bool.random()
        systemSelection = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
