Class {
    #name : 'CardEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CardEffectTest >> testApplyEffectToAddsCardToShipFromBoardDeck [
    | board ship effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := CardEffect new.
    ship := Spaceship withName: 'Player'.
    board registerShips: { ship }.
    board moveShip: ship to: 2.

    effect applyEffectTo: ship inBoard: board.

    self assert: ship cards size equals: 1.
]

{ #category : 'tests' }
CardEffectTest >> testApplyEffectUsesInjectedBoardDealer [
    | board ship effect |
    board := Board of: 5 andWormholeAt: {}.
    board useCardDealerCyclingThrough: { ShieldCard }.
    effect := CardEffect new.
    ship := Spaceship withName: 'Player'.
    board registerShips: { ship }.
    board moveShip: ship to: 2.

    effect applyEffectTo: ship inBoard: board.

    self assert: ship cards size equals: 1.
    self assert: ship cards first class equals: ShieldCard.
]
