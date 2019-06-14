//
//  Set.swift
//  Set
//
//  Created by Susana on 2/9/18.
//  Copyright © 2018 SF. All rights reserved.
//

import Foundation
import GameplayKit.GKRandomSource

class SetGame {
    
    // MARK: properties
    
    var availableCards = [Card]()
    var cardsInGame = [Card]()
    var selectedCards = [Card]()
    var hasMatch = false
    var score = 0
    
    // MARK: public functions
    
    init() {
        initAvailableCards()
        draw(numCards: GameConstant.numInitialCards)
    }
    
    func selectCard(at index: Int) {
        hasMatch = false
        
        if (index >= 0 && index < cardsInGame.count) {
            let card = cardsInGame[index]
            
            // deselect card if it's already been selected and fewer
            // than 3 cards have been selected
            // else select the card
            if selectedCards.count < GameConstant.numCardsPerSet {
                if let selectedCardIndex = selectedCards.index(of: card) {
                    selectedCards.remove(at: selectedCardIndex)
                } else {
                    selectedCards.append(card)
                    hasMatch = isSet()
                }
            }
                
                // this block executes when 4th card is selected
                // (selected card has not yet been added to selectedCard)
            else if selectedCards.count == GameConstant.numCardsPerSet {
                if checkForMatch() {
                    draw(numCards: GameConstant.numCardsPerDeal)
                    score += GameConstant.matchedSetPoints
                } else {
                    score += GameConstant.incorrectSetPenalty
                }
                
                // if the selected card was already matched,
                // selectedCards should be empty
                selectedCards = selectedCards.contains(card) ? [] : [card]
            }
        }
    }
    
    func dealCards() {
        if checkForMatch() {
            selectedCards.removeAll()
        }
        
        draw(numCards: GameConstant.numCardsPerDeal)
        score += GameConstant.dealCardsPenalty
    }
    
    func canDealMoreCards() -> Bool {
        return availableCards.count >= GameConstant.numCardsPerDeal
    }
    
    func reset() {
        availableCards.removeAll()
        cardsInGame.removeAll()
        selectedCards.removeAll()
        hasMatch = false
        score = 0
        
        initAvailableCards()
        draw(numCards: GameConstant.numInitialCards)
    }
    
    func shuffleCardsInPlay() {
        cardsInGame = shuffle(cardsInGame)
    }
    
    // MARK: private functions
    
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
    
    // if selected cards are a match, remove them from cardsInPlay
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
    
    // return true if selected cards are a set or return false otherwise
    private func isSet() -> Bool {
        if selectedCards.count < GameConstant.numCardsPerSet {
            return false
        }
        
        let card1 = selectedCards[0]
        let card2 = selectedCards[1]
        let card3 = selectedCards[2]
        
        // check for color
        if (!((card1.cardColor == card2.cardColor) && (card1.cardColor == card3.cardColor) ||
            (card1.cardColor != card2.cardColor) && (card1.cardColor != card3.cardColor) && (card2.cardColor != card3.cardColor))) {
            return false
        }
        
        // check for number
        if (!((card1.cardNumber == card2.cardNumber) && (card1.cardNumber == card3.cardNumber) ||
            (card1.cardNumber != card2.cardNumber) && (card1.cardNumber != card3.cardNumber) && (card2.cardNumber != card3.cardNumber))) {
            return false
        }
        
        // check for symbol
        if (!((card1.cardShape == card2.cardShape) && (card1.cardShape == card3.cardShape) ||
            (card1.cardShape != card2.cardShape) && (card1.cardShape != card3.cardShape) && (card2.cardShape != card3.cardShape))) {
            return false
        }
        
        // check for shading
        if (!((card1.cardShading == card2.cardShading) && (card1.cardShading == card3.cardShading) ||
            (card1.cardShading != card2.cardShading) && (card1.cardShading != card3.cardShading) && (card2.cardShading != card3.cardShading))) {
            return false
        }
        
        return true
    }
}

extension SetGame {
    private struct GameConstant {
        static let numInitialCards: Int = 12
        static let numCardsPerDeal: Int = 3
        static let numCardsPerSet: Int = 3
        
        static let dealCardsPenalty: Int = -3
        static let incorrectSetPenalty: Int = -3
        static let matchedSetPoints: Int = 3
    }
}

