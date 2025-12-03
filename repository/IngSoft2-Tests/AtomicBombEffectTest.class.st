Class {
    #name : 'AtomicBombEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
AtomicBombEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
AtomicBombEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
AtomicBombEffectTest >> testAtomicBombResetsAllShipsWhenTriggered [
    | scenario game alpha beta deterministicDie |
    deterministicDie := DeterministicDie withValues: #(2 7 3).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 5 put: AtomicBombEffect new ];
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    
    self ensureTurnOf: alpha inGame: game.
    game playTurn.
    self ensureTurnOf: beta inGame: game.
    game playTurn.
    
    self ensureTurnOf: alpha inGame: game.
    game playTurn.
    
    self assert: alpha position equals: 0.
    self assert: beta position equals: 0.
]
