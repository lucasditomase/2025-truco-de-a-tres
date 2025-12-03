Class {
    #name : 'BlackHoleEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
BlackHoleEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
BlackHoleEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
BlackHoleEffectTest >> testBlackHoleMovesShipBackBy4Positions [
    | scenario game ship deterministicDie |
    deterministicDie := DeterministicDie withValues: #(6).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 6 put: BlackHoleEffect new ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    self ensureTurnOf: ship inGame: game.
    game playTurn.
    
    self assert: ship position equals: 2.
]

{ #category : 'tests' }
BlackHoleEffectTest >> testBlackHoleDoesNotMoveBelowZero [
    | scenario game ship deterministicDie |
    deterministicDie := DeterministicDie withValues: #(3).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 3 put: BlackHoleEffect new ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    self ensureTurnOf: ship inGame: game.
    game playTurn.
    
    self assert: ship position equals: 0.
]
