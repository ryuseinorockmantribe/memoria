//
//  ContentView.swift
//  Memoria
//
//  Created by App Designer2 on 24.09.24.
//

import SwiftUI

struct GameOverMessage: Identifiable {
    var id = UUID()
    var message: String
    var que: String
    var action: () -> Void
}

struct ContentView: View {
    @State private var cards = ["🍎", "🍌", "🍇", "🍑", "🍓", "🍍"]
    @State private var shuffledCards: [String] = []
    @State private var selectedCards: [Int] = []
    @State private var matchedCards: [Int] = []
    
    @State private var gameOverMessage: GameOverMessage? = nil
    @State private var level = 1 //MARK: 1 = Fácil, 2 = Medio, 3 = Difícil, 4 = Mas Difícil
    
    @State private var timeRemaining = 30
    @State private var timer: Timer? = nil
    
    

    var body: some View {
        VStack {
            Text("Juego de Memoria - Nivel \(level)")
                .font(.largeTitle)
                .padding()

            GridStack(rows: numberOfRows(), columns: numberOfColumns()) { row, col in
                let index = row * numberOfColumns() + col
                if index < shuffledCards.count {
                    return AnyView(
                        CardView(symbol: self.shuffledCards[index],
                                 isFlipped: self.selectedCards.contains(index) || self.matchedCards.contains(index))
                        .onTapGesture {
                            withAnimation(.smooth) {
                                self.cardTapped(at: index)
                            }
                        }
                    )
                } else {
                    return AnyView(EmptyView())
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).stroke(Color.purple, lineWidth: 4))
            .padding()

            //MARK: Muestra el tiempo restante:
            Text("Tiempo restante: \(timeRemaining) segundos")
                .font(.title2)
                .padding()
                .contentTransition(.numericText(value: Double(timeRemaining)))

            HStack {
                
                //MARK: Reiniciar juego:
                Button("Reiniciar") {
                    withAnimation {
                        self.restartGame()
                    }
                }
                .font(.title2)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)

                //MARK: Cambiar nivel:
                Button("Cambiar Nivel") {
                    withAnimation {
                        self.changeLevel()
                    }
                }
                .font(.title2)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            }//MARK: HStack
            
        }//MARK: VStack
        
        .onAppear(perform: startGame)
        .alert(item: $gameOverMessage) { message in
                    Alert(
                        title: Text(message.message),
                        primaryButton: .default(Text(message.que), action: {
                            message.action()
                        }),
                        secondaryButton: .cancel(Text("Cancelar"))
                    )
                }
        
    }

    func startGame() {
        shuffleCards()
        startTimer()
    }

    func shuffleCards() {
        let additionalCards = ["🍋", "🍉", "🥝", "🥥", "🍒", "🥭", "🍈", "🍊", "🍏", "🍐", "🍒", "🍍"]
        let numberOfPairs = (level + 2) * 2 //MARK: Aumenta el número de pares con el nivel

        //MARK: Selecciona las cartas necesarias para formar los pares
        let cardsToUse = (cards + additionalCards).prefix(numberOfPairs / 2)
        
        //MARK: Duplicar las cartas para formar pares
        shuffledCards = (cardsToUse + cardsToUse).shuffled()
    }

    func cardTapped(at index: Int) {
        if selectedCards.count == 2 {
            selectedCards.removeAll()
        }
        if !matchedCards.contains(index) {
            selectedCards.append(index)
            if selectedCards.count == 2 {
                checkForMatch()
            }
        }
    }

    //MARK: Verificar si se han encontrado todos los pares:
    func checkForMatch() {
        let firstIndex = selectedCards[0]
        let secondIndex = selectedCards[1]
        if shuffledCards[firstIndex] == shuffledCards[secondIndex] {
            matchedCards += selectedCards
            if matchedCards.count == shuffledCards.count {
                
                timer?.invalidate()
                gameOverMessage = GameOverMessage(message: "¡Ganaste! Felicidades, has encontrado todos los pares.", que: "Siguiente", action: { withAnimation(.smooth){
                    self.changeLevel()
                    
                }
                }
                )
                
            }
        }
       
    }

    //MARK: Reiniciar el juego:
    func restartGame() {
        matchedCards.removeAll()
        selectedCards.removeAll()
        timeRemaining = timeForLevel()
        gameOverMessage = nil
        shuffleCards()
        startTimer()
    }

    //MARK: Cambiar de nivel:
    func changeLevel() {
        if level < 4 {
            level += 1
        } else {
            level = 1 //MARK: Reiniciar al primer nivel si se llega al máximo
        }
        restartGame()
    }

    //MARK: Empezar el conteo regresivo:
    func startTimer() {
        timeRemaining = timeForLevel()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                timer?.invalidate()
                gameOverMessage = GameOverMessage(message: "¡Tiempo agotado! Inténtalo de nuevo.", que: "Reiniciar", action: {
                    withAnimation(.smooth) {
                    self.restartGame()}
                }
                )
            }
        }
    }

    //MARK: Numeros de columnas:
    func numberOfColumns() -> Int {
        switch level {
        case 1:
            return 3 //MARK: Nivel 1: 3 columnas
        case 2:
            return 4 //MARK: Nivel 2: 4 columnas
        case 3:
            return 5 //MARK: Nivel 3: 5 columnas
        case 4:
            return 6 //MARK: Nivel 4: 6 columnas
        default:
            return 6
        }
    }

    //MARK: He agregado este metodo, para aumentar el numero de filas por cada nivel:
    func numberOfRows() -> Int {
        return level + 1
    }

    //MARK: Disminuir el tiempo según aumenta el nivel, de fácil y difícil:
    func timeForLevel() -> Int {
        switch level {
        case 1:
            return 60 //MARK: Fácil: Más tiempo
        case 2:
            return 45 //MARK: Medio: Tiempo moderado
        case 3:
            return 30 //MARK: Difícil: Menos tiempo
        case 4:
            return 20 //MARK: Mas Difícil: Menos tiempo aun
        default:
            return 45
        }
    }
}

#Preview {
    ContentView()
}

