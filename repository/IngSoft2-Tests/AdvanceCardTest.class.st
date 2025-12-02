Class {
    #name : 'AdvanceCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
AdvanceCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'asserting' }
AdvanceCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ].
]

{ #category : 'tests' }
AdvanceCardTest >> testApplyEffectMovesShipForward [
    | scenario game ship card |
    scenario := (self builder boardWithCells: 10) build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    card := AdvanceCard new.
    scenario game board moveShip: ship to: 2.
    card applyEffectTo: ship inGame: game.
    self assert: ship position equals: 3.
]

{ #category : 'tests' }
AdvanceCardTest >> testPlayOnMovesShipForwardWhenInProgress [
    | scenario game ship card |
    scenario := (self builder boardWithCells: 10) build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    card := AdvanceCard new.
    scenario game board moveShip: ship to: 1.
    ship addCard: card.
    ship playCard: card inGame: game.
    self assert: ship position equals: 2.
]
