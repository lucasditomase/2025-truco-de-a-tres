Class {
    #name : 'ReversedEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
ReversedEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
ReversedEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedBlackHoleMovesShipForward [
    | scenario game ship deterministicDie effect reversed |
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    deterministicDie := DeterministicDie withValues: #(4).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 4 put: reversed ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    self ensureTurnOf: ship inGame: game.
    game playTurn.
    
    self assert: ship position equals: 8.
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedHyperJumpMovesShipBackward [
    | scenario game ship deterministicDie effect reversed initialPosition |
    effect := HyperJumpEffect withValues: #(2).
    reversed := ReversedEffect of: effect.
    deterministicDie := DeterministicDie withValues: #(5).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :aBoard |
            aBoard cells at: 5 put: reversed ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    initialPosition := 5.
    
    self ensureTurnOf: ship inGame: game.
    game playTurn.
    
    self assert: ship position < initialPosition.
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedMoonWalkMovesOthersForward [
    | scenario game alpha beta deterministicDie effect reversed |
    effect := MoonWalkEffect withSteps: 3.
    reversed := ReversedEffect of: effect.
    deterministicDie := DeterministicDie withValues: #(3 6).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 6 put: reversed ];
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    
    self ensureTurnOf: beta inGame: game.
    game playTurn.
    
    self ensureTurnOf: alpha inGame: game.
    game playTurn.
    
    self assert: alpha position equals: 6.
    self assert: beta position equals: 6.
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedReturnsOriginal [
    | effect reversed |
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    self assert: reversed reversed equals: effect.
]
