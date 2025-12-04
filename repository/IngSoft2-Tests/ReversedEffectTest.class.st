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
    
    deterministicDie := DeterministicDie withValues: #(4) sides: 6.
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
ReversedEffectTest >> testReversedReturnsOriginal [
    | effect reversed |
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    self assert: reversed reversed equals: effect.
]

{ #category : 'tests' }
ReversedEffectTest >> testOriginalReturnsTheOriginalEffect [
    | effect reversed |
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    
    self assert: reversed original equals: effect.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToInBoardReturnsSelf [
    | effect reversed scenario game ship |
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    scenario := self builder
        withShipNames: #('Alpha');
        boardWithCells: 10;
        diceWithSides: 6;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    self assert: (reversed applyEffectTo: ship inBoard: game board) equals: reversed.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyToWithShipCallsApplyToInBoard [
    | effect reversed scenario ship |
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    scenario := self builder
        withShipNames: #('Alpha');
        boardWithCells: 10;
        diceWithSides: 6;
        build.
    ship := scenario shipNamed: 'Alpha'.
    
    self shouldnt: [ reversed applyTo: ship ] raise: Error.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyToInBoardCreatesParticipants [
    | effect reversed scenario game ship |
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 10;
        diceWithSides: 6;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    self shouldnt: [ reversed applyTo: ship inBoard: game board ] raise: Error.
]
