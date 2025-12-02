Class {
    #name : 'AccelerationCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
AccelerationCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
AccelerationCardTest >> testActivateForAddsCardToShipActiveCards [
    | scenario game ship card |
    scenario := self builder build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    card := AccelerationCard new.
    ship addCard: card.
    ship playCard: card inGame: game.
    self assert: (ship activeCards includes: card).
]

{ #category : 'tests' }
AccelerationCardTest >> testModifyRollAddsOne [
    | scenario game ship card result |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 6;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    card := AccelerationCard new.
    result := card modifyRoll: 3 forShip: ship inGame: game.
    self assert: result equals: 4.
]
