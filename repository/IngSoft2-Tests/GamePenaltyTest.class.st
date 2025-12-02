Class {
    #name : 'GamePenaltyTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
GamePenaltyTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
GamePenaltyTest >> scenarioWithPenalizedFirstShipFor: turns [
    | scenario |
    scenario := self builder
        withShipNames: #('Penalized' 'Other');
        boardWithCells: 6;
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(1) } ];
        laps: 5;
        build.
    scenario game penalize: (scenario shipNamed: 'Penalized') forTurns: turns.
    ^ scenario
]

{ #category : 'tests' }
GamePenaltyTest >> testPenaltyFlowSkipsPenalizedShipAndReducesTurns [
    | scenario game |
    scenario := self scenarioWithPenalizedFirstShipFor: 2.
    game := scenario game.

    self assert: game currentShip name equals: 'Penalized'.
    game playTurn.
    self assert: game currentShip name equals: 'Other'.

    game playTurn.
    self assert: (game isPenalized: (scenario shipNamed: 'Penalized')) not.
]

{ #category : 'tests' }
GamePenaltyTest >> testPenaltyTurnsDecreaseAfterEachSkippedTurn [
    | scenario penalizedShip game |
    scenario := self scenarioWithPenalizedFirstShipFor: 3.
    game := scenario game.
    penalizedShip := scenario shipNamed: 'Penalized'.

    self assert: (game penalizedTurnsRemainingFor: penalizedShip) equals: 3.
    game playTurn.
    self assert: (game penalizedTurnsRemainingFor: penalizedShip) equals: 2.
    game playTurn.
    self assert: (game penalizedTurnsRemainingFor: penalizedShip) equals: 1.
]

{ #category : 'tests' }
GamePenaltyTest >> testPenaltyShipListReflectsCurrentPenalizations [
    | scenario penalizedShip |
    scenario := self scenarioWithPenalizedFirstShipFor: 1.
    penalizedShip := scenario shipNamed: 'Penalized'.

    self assert: ((scenario game) penaltyShip includes: penalizedShip).
    (scenario game) reducePenaltyFor: penalizedShip.
    self deny: ((scenario game) penaltyShip includes: penalizedShip).
]

{ #category : 'tests' }
GamePenaltyTest >> testPassingTurnRestoresFuelAndSkips [
    | scenario game passingShip |
    scenario := self builder
        withShipNames: #('Passing' 'Follower');
        boardWithCells: 8;
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(3) } ];
        laps: 5;
        build.
    game := scenario game.
    passingShip := scenario shipNamed: 'Passing'.

    game recordFuelStartFor: passingShip.
    passingShip decreaseFuelBy: 4.
    game markShipAsWantingToPassTurn: passingShip to: true.
    game playTurn.

    self assert: passingShip fuel equals: passingShip maxFuel.
    self assert: game currentShip name equals: 'Follower'.
]

{ #category : 'tests' }
GamePenaltyTest >> testPenaltyEndsAfterEnoughTurns [
    | scenario game penalizedShip |
    scenario := self scenarioWithPenalizedFirstShipFor: 1.
    game := scenario game.
    penalizedShip := scenario shipNamed: 'Penalized'.

    game playTurn.
    self deny: (game isPenalized: penalizedShip).
]

{ #category : 'tests' }
GamePenaltyTest >> testPenaltyStatusPersistsAcrossMultipleRounds [
    | scenario game penalizedShip |
    scenario := self scenarioWithPenalizedFirstShipFor: 2.
    game := scenario game.
    penalizedShip := scenario shipNamed: 'Penalized'.

    game playTurn.
    game playTurn.
    self assert: (game isPenalized: penalizedShip).
    game playTurn.
    self deny: (game isPenalized: penalizedShip).
]
