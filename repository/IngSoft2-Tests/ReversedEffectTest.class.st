Class {
    #name : 'ReversedEffectTest',
    #superclass : 'GameIntegrationTest',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ReversedEffectTest >> testReversedBlackHoleMovesShipForward [
    | scenario game ship deterministicDie effect reversed status |
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
    
    status := game statusFor: ship.
    self assert: status position equals: 8.
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedWormholeEntersAtExitAndGoesToNextLap [
    | scenario game ship deterministicDie wormhole reversed |
    wormhole := Wormhole from: 3 to: 9.
    reversed := wormhole reversed.
    
    deterministicDie := DeterministicDie withValues: #(9) sides: 10.
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board addWormhole: reversed ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    game playTurn.
    
    self assert: (game statusFor: ship) position equals: 3.
    self assert: (game statusFor: ship) lapCount equals: 1.
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedWormholeEntersAtEntryAndGoesToPreviousLap [
    | scenario game ship deterministicDie wormhole reversed |
    wormhole := Wormhole from: 3 to: 9.
    reversed := wormhole reversed.
    
    
    
    deterministicDie := DeterministicDie withValues: #(3) sides: 6.
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board addWormhole: reversed ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    game playTurn.
    
    self assert: (game statusFor: ship) position equals: 9.
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedMoonWalkMovesOthersForward [
    | scenario game ship1 ship2 deterministicDie effect reversed |
    effect := MoonWalkEffect withSteps: 2.
    reversed := ReversedEffect of: effect.
    
    deterministicDie := DeterministicDie withValues: #(3 3) sides: 6.
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 3 put: reversed ];
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    ship2 := scenario shipNamed: 'Beta'.
    
    
    
    game playTurn.
    
    self assert: (game statusFor: ship1) position equals: 3.
    self assert: (game statusFor: ship2) position equals: 2.
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedAtomicBombDoesNothing [
    | scenario game ship1 ship2 deterministicDie effect reversed |
    effect := AtomicBombEffect new.
    reversed := ReversedEffect of: effect.
    
    deterministicDie := DeterministicDie withValues: #(3) sides: 6.
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 3 put: reversed ];
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    ship2 := scenario shipNamed: 'Beta'.
    
    
    
    game playTurn.
    
    self assert: (game statusFor: ship1) position equals: 3.
    self assert: (game statusFor: ship2) position equals: 0.
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedCardGiverDiscardsCard [
    | scenario game ship deterministicDie effect reversed initialCardCount |
    effect := CardEffect new.
    reversed := ReversedEffect of: effect.
    
    deterministicDie := DeterministicDie withValues: #(3) sides: 6.
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 3 put: reversed ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    
    initialCardCount := (game activeCards select: [:c | true]) size.
    initialCardCount := (game activeCards) size.
]
