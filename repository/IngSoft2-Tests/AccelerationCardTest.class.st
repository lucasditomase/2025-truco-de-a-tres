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
AccelerationCardTest >> testAccelerationCardIncreasesMovementDuringGamePlay [
    | scenario game ship card deterministicDie |
    deterministicDie := DeterministicDie withValues: #(3).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    card := AccelerationCard new.
    
    ship addCard: card.
    ship playCard: card inGame: game.
    game playTurn.
    
    self assert: ship position equals: 4.
]
