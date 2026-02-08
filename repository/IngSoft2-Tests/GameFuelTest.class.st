Class {
    #name : 'GameFuelTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
GameFuelTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
GameFuelTest >> testPassTurnRestoresFuelAndAdvancesTurn [
    | scenario game skip |
    scenario := self builder
        withShipNames: #('Skip' 'Other');
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    skip := scenario shipNamed: 'Skip'.

    game consumeFuel: 3 forShip: skip.
    game passTurn.

    self assert: skip fuel equals: skip maxFuel.
    self assert: game currentShip name equals: 'Other'
]

{ #category : 'tests' }
GameFuelTest >> testFuelConsumptionIncludesBoardEffectMovement [
    | scenario game pilot initialFuel |
    scenario := self builder
        withShipNames: #('Pilot' 'Observer');
        boardWithCells: 10;
        withEffect: (BlockEffect on: [ :ship :aBoard | aBoard moveShip: ship forward: 2 ]) at: 4;
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(4) sides: 7 } ];
        laps: 5;
        build.
    game := scenario game.
    pilot := scenario shipNamed: 'Pilot'.
    initialFuel := pilot fuel.

    scenario playTurns: 1.

    self assert: pilot fuel equals: initialFuel - 6.
    self assert: game currentShip name equals: 'Observer'
]

{ #category : 'tests' }
GameFuelTest >> testPenaltyWhenEffectConsumesRemainingFuel [
    | scenario striker |
    scenario := self builder
        withShipNames: #('Striker' 'Witness');
        boardWithCells: 8;
        withEffect: (BlockEffect on: [ :ship :aBoard | aBoard moveShip: ship forward: 6 ]) at: 2;
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(2) sides: 3 } ];
        laps: 5;
        build.
    scenario playTurns: 1.
    striker := scenario shipNamed: 'Striker'.

    self assert: (scenario game isPenalized: striker).
    self assert: (scenario statusForShipNamed: 'Striker') position equals: 0
]

{ #category : 'tests' }
GameFuelTest >> testAllySharesFuelBeforePenalty [
    | scenario game owner ally card initialAllyFuel availableFuel |
    scenario := self builder
        withShipNames: #('Owner' 'Ally');
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    owner := scenario shipNamed: 'Owner'.
    ally := scenario shipNamed: 'Ally'.
    card := AllyCard withAlly: ally.
    card activateFor: owner inGame: game.

    availableFuel := owner fuel.
    game consumeFuel: availableFuel - 1 forShip: owner.
    initialAllyFuel := ally fuel.
    game consumeFuel: 3 forShip: owner.

    self assert: owner fuel equals: 0.
    self assert: ally fuel equals: initialAllyFuel - 2.
    self assert: (game isPenalized: owner)
]

{ #category : 'tests' }
GameFuelTest >> testAllyPenaltyWhenBothShipsRunOut [
    | scenario game owner ally card |
    scenario := self builder
        withShipNames: #('Owner' 'Friend');
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    owner := scenario shipNamed: 'Owner'.
    ally := scenario shipNamed: 'Friend'.
    card := AllyCard withAlly: ally.
    card activateFor: owner inGame: game.

    game consumeFuel: owner fuel - 1 forShip: owner.
    game consumeFuel: ally fuel - 1 forShip: ally.
    game consumeFuel: 4 forShip: owner.

    self assert: (game isPenalized: owner).
    self assert: (game isPenalized: ally).
    self assert: (scenario statusForShipNamed: 'Owner') position equals: 0.
    self assert: (scenario statusForShipNamed: 'Friend') position equals: 0
]

{ #category : 'tests' }
GameFuelTest >> testMaxRollDuringTurnTriggersReward [
    | scenario ship initialMax initialFuel stepCost fuelDelta |
    scenario := self builder
        withShipNames: #('Reward' 'Watcher');
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(6) } ];
        laps: 5;
        build.
    ship := scenario shipNamed: 'Reward'.
    initialMax := ship maxFuel.
    initialFuel := ship fuel.
    stepCost := scenario game die maxRoll.

    scenario game rollAndMoveCurrentShip.
    fuelDelta := initialFuel - ship fuel.

    self assert: (
        ship maxFuel > initialMax
        or: [ fuelDelta > stepCost ])
]

{ #category : 'tests' }
GameFuelTest >> testRewardForMaxRollIncreasesMaxFuel [
    | scenario ship initial |
    scenario := self builder
        withShipNames: #('Lucky' 'Other');
        diceWithSides: 3;
        laps: 5;
        build.
    ship := scenario shipNamed: 'Lucky'.
    initial := ship maxFuel.

    scenario game rewardForMaxRollTo: ship withRoll: 1.

    self assert: ship maxFuel equals: initial + 1
]

{ #category : 'tests' }
GameFuelTest >> testRewardForMaxRollCanReduceFuel [
    | scenario ship initialFuel |
    scenario := self builder
        withShipNames: #('Risky' 'Other');
        diceWithSides: 3;
        laps: 5;
        build.
    ship := scenario shipNamed: 'Risky'.
    initialFuel := ship fuel.

    scenario game rewardForMaxRollTo: ship withRoll: 100.

    self assert: ship fuel equals: initialFuel - 1
]

{ #category : 'tests' }
GameFuelTest >> testAtomicBombEffectSkipsFuelConsumption [
    | scenario ship initialFuel |
    scenario := self builder
        withShipNames: #('A' 'B');
        boardWithCells: 4;
        withEffect: AtomicBombEffect new at: 1;
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(1) sides: 6 } ];
        laps: 5;
        build.
    ship := scenario shipNamed: 'A'.
    initialFuel := ship fuel.

    scenario playTurns: 1.

    self assert: ship fuel equals: initialFuel - 1
]

{ #category : 'tests' }
GameFuelTest >> testRecordFuelStartRetainsLastEntries [
    | scenario game ship initialFuel history |
    scenario := self builder
        withShipNames: #('Recorder' 'Other');
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Recorder'.
    initialFuel := ship fuel.

    4 timesRepeat: [
        game recordFuelStartFor: ship.
        game consumeFuel: 1 forShip: ship ].

    history := game fuelHistoryFor: ship.
    self assert: history equals: {
        initialFuel - 1.
        initialFuel - 2.
        initialFuel - 3 } asOrderedCollection
]

{ #category : 'tests' }
GameFuelTest >> testPenalizeAndResetIfNoFuelMovesShipToStart [
    | scenario game ship status |
    scenario := self builder
        withShipNames: #('Runner' 'Other');
        boardWithCells: 6;
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Runner'.

    game consumeFuel: ship fuel forShip: ship.
    game penalizeAndResetIfNoFuel: ship.

    status := scenario statusForShipNamed: 'Runner'.
    self assert: status position equals: 0.
    self assert: (game isPenalized: ship)
]

{ #category : 'tests' }
GameFuelTest >> testPenalizeAndResetIfNoFuelDoesNothingWhenShipHasFuel [
    | scenario game ship status |
    scenario := self builder
        withShipNames: #('Runner' 'Other');
        boardWithCells: 6;
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Runner'.

    game consumeFuel: 1 forShip: ship.
    game penalizeAndResetIfNoFuel: ship.

    status := scenario statusForShipNamed: 'Runner'.
    self assert: status position equals: 0.
    self deny: (game isPenalized: ship)
]

{ #category : 'tests' }
GameFuelTest >> testFuelHistorySetterReplacesHistory [
    | scenario game ship history |
    scenario := self builder
        withShipNames: #('Recorder' 'Other');
        diceWithSides: 3;
        laps: 5;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Recorder'.
    history := Dictionary new.
    history at: ship put: (OrderedCollection with: 5).

    game fuelHistory: history.

    self assert: (game fuelHistoryFor: ship) equals: (OrderedCollection with: 5)
]
