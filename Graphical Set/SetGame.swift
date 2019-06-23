

import Foundation
import GameplayKit.GKRandomSource

class SetGame {
    

    
    var availableCards = [Card]()
    var cardsInGame = [Card]()
    var selectedCards = [Card]()
    var hasMatch = false
    var score = 0
    

    
    init() {
        initAvailableCards()
        draw(numCards: 12)
    }
    
    func selectCard(at index: Int) {
        hasMatch = false
        
        if (index >= 0 && index < cardsInGame.count) {
            let card = cardsInGame[index]
            

            if selectedCards.count < 3 {
                if let selectedCardIndex = selectedCards.index(of: card) {
                    selectedCards.remove(at: selectedCardIndex)
                } else {
                    selectedCards.append(card)
                    hasMatch = isSet()
                }
            }
                
                
            else if selectedCards.count == 3 {
                if checkForMatch() {
                    draw(numCards: 3)
                    score += 3
                } else {
                    score -= 3
                }
                
                selectedCards = selectedCards.contains(card) ? [] : [card]
            }
        }
    }
    
    func dealCards() {
        if checkForMatch() {
            selectedCards.removeAll()
        }
        
        draw(numCards: 3)
        score += 3
    }
    
    func canDealMoreCards() -> Bool {
        return availableCards.count >= 3
    }
    
    func reset() {
        availableCards.removeAll()
        cardsInGame.removeAll()
        selectedCards.removeAll()
        hasMatch = false
        score = 0
        
        initAvailableCards()
        draw(numCards: 12)
    }
    
    func shuffleCardsInPlay() {
        cardsInGame = shuffle(cardsInGame)
    }

    
    private func initAvailableCards() {
        for num in Card.CardNumber.allVallues {
            for symbol in Card.CardShape.all {
                for shade in Card.CardShading.all {
                    for color in Card.CardColor.all {
                        availableCards.append(Card(cardNumber: num,
                                         cardShape: symbol,
                                         cardShading: shade,
                                         cardColor: color))
                    }
                }
            }
        }
        
        availableCards = shuffle(availableCards)
    }
    
    private func draw(numCards: Int) {
        if availableCards.count >= numCards {
            for _ in 1...numCards {
                if let drawnCard = availableCards.popLast() {
                    cardsInGame.append(drawnCard)
                }
            }
        }
    }
    
    private func shuffle(_ availableCards: [Card]) -> [Card] {
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: availableCards) as! [Card]
    }
    
    private func checkForMatch() -> Bool {
        hasMatch = isSet()
        
        if hasMatch {
            for card in selectedCards {
                if let index = cardsInGame.index(of: card) {
                    cardsInGame.remove(at: index)
                }
            }
        }
        
        return hasMatch
    }
    
    private func isSet() -> Bool {
        if selectedCards.count < 3 {
            return false
        }
        
        let card1 = selectedCards[0]
        let card2 = selectedCards[1]
        let card3 = selectedCards[2]
        
        if (!((card1.cardColor == card2.cardColor) && (card1.cardColor == card3.cardColor) ||
            (card1.cardColor != card2.cardColor) && (card1.cardColor != card3.cardColor) && (card2.cardColor != card3.cardColor))) {
            return false
        }
        
        if (!((card1.cardNumber == card2.cardNumber) && (card1.cardNumber == card3.cardNumber) ||
            (card1.cardNumber != card2.cardNumber) && (card1.cardNumber != card3.cardNumber) && (card2.cardNumber != card3.cardNumber))) {
            return false
        }
        
        if (!((card1.cardShape == card2.cardShape) && (card1.cardShape == card3.cardShape) ||
            (card1.cardShape != card2.cardShape) && (card1.cardShape != card3.cardShape) && (card2.cardShape != card3.cardShape))) {
            return false
        }
        
        if (!((card1.cardShading == card2.cardShading) && (card1.cardShading == card3.cardShading) ||
            (card1.cardShading != card2.cardShading) && (card1.cardShading != card3.cardShading) && (card2.cardShading != card3.cardShading))) {
            return false
        }
        
        return true
    }
}

extension SetGame {
    private struct GameConstant {
        static let dealCardsPenalty: Int = -3
    }
}

