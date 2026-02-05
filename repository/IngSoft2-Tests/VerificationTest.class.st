Class {
    #name : 'VerificationTest',
    #superclass : 'GameIntegrationTest',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
VerificationTest >> playReversalFor: aShip inGame: aGame [
    | card |
    card := ReversalCard new.
    aShip addCard: card.
    self ensureTurnOf: aShip inGame: aGame.
    aShip playCard: card inGame: aGame.
    ^ card
]

{ #category : 'tests' }
VerificationTest >> testWormholeReversalAdjustsLapsCorrectly [
    | scenario game ship1 wormhole |
    
    wormhole := Wormhole from: 3 to: 8.
    
    scenario := self builder
        withShipNames: #('Alpha');
        boardFactory: [ Board of: 10 andWormholeAt: { wormhole } ];
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    
    "Advance ship to Lap 1 manually to test decrement."
    (game lapTrackerFor: ship1) addLap.
    self assert: (game lapTrackerFor: ship1) lapCount equals: 1.
    
    "Move Ship1 to 8 (Exit) to setup reversal."
    scenario moveShip: ship1 to: 8.
    
    "Apply Reversal to Wormhole (at 8)."
    self playReversalFor: ship1 inGame: game.
    
    "Scenario A: Falling into 3 (Original Entry)."
    "Should go to 8 (Exit) of Previous Lap (-1 Lap)."
    scenario moveShip: ship1 to: 3.
    game applyEffectOfCurrentCell.
    
    "Assert Position 8."
    self assert: ship1 position equals: 8.
    "Assert Laps decreased by 1 (1 -> 0)."
    self assert: (game lapTrackerFor: ship1) lapCount equals: 0.
    
    "Scenario B: Falling into 8 (Original Exit)."
    "Should go to 3 (Entry) of Next Lap (+1 Lap)."
    "Currently at 8, Lap 0."
    scenario moveShip: ship1 to: 8.
    game applyEffectOfCurrentCell.
    
    self assert: ship1 position equals: 3.
    "Laps +1 (0 -> 1)."
    self assert: (game lapTrackerFor: ship1) lapCount equals: 1.
]

{ #category : 'tests' }
VerificationTest >> testDoubleReversalCancelsOut [
    | scenario game ship1 wormhole |
    
    wormhole := Wormhole from: 3 to: 8.
    scenario := self builder
        withShipNames: #('Alpha');
        boardFactory: [ Board of: 10 andWormholeAt: { wormhole } ];
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    
    "Reverse at 8."
    scenario moveShip: ship1 to: 8.
    self playReversalFor: ship1 inGame: game.
    
    "Reverse again at 8."
    self playReversalFor: ship1 inGame: game.
    
    "Now should be normal."
    "Test Entry 3 -> 8 (Same Lap)."
    scenario moveShip: ship1 to: 3.
    
    game applyEffectOfCurrentCell.
    
    self assert: ship1 position equals: 8.
    "Laps should not change (Start 0 -> End 0)."
    self assert: (game lapTrackerFor: ship1) lapCount equals: 0.
]

{ #category : 'tests' }
VerificationTest >> testTimeMachineInProductionScenario [
    | scenario game ship1 tmCard deterministicDie initialFuel |
    
    "Scenario: 100 cells. 3 Laps."
    deterministicDie := DeterministicDie withValues: #(10) sides: 10.
    scenario := self builder
        withShipNames: #('Alpha');
        diceCup: [ DiceCup with: { deterministicDie } ];
        laps: 3;
        boardWithCells: 100;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    
    initialFuel := ship1 fuel.
    
    "Turn 1: Move 10. Consumes Fuel."
    game playTurn.
    "Turn 2: Move 10. Consumes Fuel."
    game playTurn.
    
    "Now Turn 3 Start."
    "History: [StartT1, StartT2, StartT3]."
    "Antepenultimate = StartT1 = Initial."
    
    tmCard := TimeMachineCard new.
    ship1 addCard: tmCard.
    self ensureTurnOf: ship1 inGame: game.
    ship1 playCard: tmCard inGame: game.
    
    self assert: ship1 fuel equals: initialFuel.
]
