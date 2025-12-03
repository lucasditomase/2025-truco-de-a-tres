Class {
    #name : 'MoonWalkEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
MoonWalkEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
MoonWalkEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
MoonWalkEffectTest >> testMoonWalkMovesOtherShipsBackward [
    | scenario game alpha beta deterministicDie effect |
    effect := MoonWalkEffect new.
    deterministicDie := DeterministicDie withValues: #(7 5).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 5 put: effect ];
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    
    self ensureTurnOf: beta inGame: game.
    game playTurn.
    
    self ensureTurnOf: alpha inGame: game.
    game playTurn.
    
    self assert: alpha position equals: 5.
    self assert: beta position equals: 5.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testMoonWalkWithCustomSteps [
    | scenario game alpha beta deterministicDie effect |
    effect := MoonWalkEffect withSteps: 4.
    deterministicDie := DeterministicDie withValues: #(10 8).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 8 put: effect ];
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    
    self ensureTurnOf: beta inGame: game.
    game playTurn.
    
    self ensureTurnOf: alpha inGame: game.
    game playTurn.
    
    self assert: alpha position equals: 8.
    self assert: beta position equals: 6.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testWithStepsRequiresPositiveInteger [
    self
        should: [ MoonWalkEffect withSteps: 0 ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Steps must be a positive integer' ].
    self
        should: [ MoonWalkEffect withSteps: 'two' ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Steps must be a positive integer' ].
]
