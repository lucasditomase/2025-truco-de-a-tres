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
        withShipNames: #('Alpha' 'Beta');
        boardFactory: [ Board of: 10 andWormholeAt: { wormhole } ];
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    
    (game lapTrackerFor: ship1) addLap.
    self assert: (game lapTrackerFor: ship1) lapCount equals: 1.
    
    scenario moveShip: ship1 to: 8.
    self playReversalFor: ship1 inGame: game.
    
    scenario moveShip: ship1 to: 3.
    game applyEffectOfCurrentCell.
    
    self assert: ship1 position equals: 8.
    self assert: (game lapTrackerFor: ship1) lapCount equals: 0.
    
    scenario moveShip: ship1 to: 8.
    game applyEffectOfCurrentCell.
    
    self assert: ship1 position equals: 3.
    self assert: (game lapTrackerFor: ship1) lapCount equals: 1.
]

{ #category : 'tests' }
VerificationTest >> testDoubleReversalCancelsOut [
    | scenario game ship1 wormhole |
    
    wormhole := Wormhole from: 3 to: 8.
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardFactory: [ Board of: 10 andWormholeAt: { wormhole } ];
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    
    scenario moveShip: ship1 to: 8.
    self playReversalFor: ship1 inGame: game.
    self playReversalFor: ship1 inGame: game.
    
    scenario moveShip: ship1 to: 3.
    
    game applyEffectOfCurrentCell.
    
    self assert: ship1 position equals: 8.
    self assert: (game lapTrackerFor: ship1) lapCount equals: 0.
]

{ #category : 'tests' }
VerificationTest >> testTimeMachineInProductionScenario [
    | scenario game ship1 tmCard deterministicDie initialFuel |
    
    
    deterministicDie := DeterministicDie withValues: #(10) sides: 10.
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        laps: 3;
        boardWithCells: 100;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    
    initialFuel := ship1 fuel.
    
    4 timesRepeat: [ game playTurn ].
    
    tmCard := TimeMachineCard new.
    ship1 addCard: tmCard.
    self ensureTurnOf: ship1 inGame: game.
    ship1 playCard: tmCard inGame: game.
    
    self assert: ship1 fuel equals: initialFuel.
]
