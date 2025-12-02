Class {
    #name : 'ShieldCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
ShieldCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
ShieldCardTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
ShieldCardTest >> testActivateForAddsCardToShipActiveCards [
    | scenario game ship card |
    scenario := self builder build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    card := ShieldCard new.
    ship addCard: card.
    self ensureTurnOf: ship inGame: game.
    ship playCard: card inGame: game.

    self assert: (ship activeCards includes: card)
]
