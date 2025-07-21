Class {
    #name : 'GameCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
GameCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
GameCardTest >> testLastEffectiveCardUpdatesWithNewCard [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := AdvanceCard new.
    game lastCardPlayed: card.
    self assert: game lastEffectiveCard equals: card.
]

{ #category : 'tests' }
GameCardTest >> testLastEffectiveCardStaysWhenRedoCardPlayed [
    | ship1 ship2 board dice game card oldEffective |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := AdvanceCard new.
    game lastCardPlayed: card.
    oldEffective := game lastEffectiveCard.
    game lastCardPlayed: RedoCard new.
    self assert: game lastEffectiveCard equals: oldEffective.
]
