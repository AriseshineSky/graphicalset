//
//  Card.swift
//  Set
//
//  Created by Susana on 2/9/18.
//  Copyright © 2018 SF. All rights reserved.
//

import Foundation

struct Card {
    
    // MARK: properties
    
    let cardNumber: CardNumber
    let cardShape: CardShape
    let cardShading: CardShading
    let cardColor: CardColor
    
    // MARK: enums
    
    enum CardNumber: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var allVallues: [CardNumber] {
            return [.one, .two, .three]
        }
    }
    
    enum CardShape {
        case diamond
        case oval
        case squiggle
        
        static var all: [CardShape] {
            return [.diamond, .oval, .squiggle]
        }
    }
    
    enum CardShading {
        case solid
        case striped
        case open
        
        static var all: [CardShading] {
            return [.solid, .striped, .open]
        }
    }
    
    enum CardColor {
        case red
        case green
        case purple
        
        static var all: [CardColor] {
            return [.red, .green, .purple]
        }
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return
            (lhs.cardColor == rhs.cardColor) &&
                (lhs.cardNumber == rhs.cardNumber) &&
                (lhs.cardShading == rhs.cardShading) &&
                (lhs.cardShape == rhs.cardShape)
    }
}

