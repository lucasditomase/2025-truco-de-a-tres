Class {
    #name : 'GameFuelTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
GameFuelTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ].
]

{ #category : 'tests' }
GameFuelTest >> testPassTurnRestoresFuelToMax [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'Skip'.
    ship2 := Spaceship withName: 'Other'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ship1 maxFuel: 5.
    ship1 fuel: 2.

    game passTurn.

    self assert: ship1 fuel equals: ship1 maxFuel.
    self assert: game currentShip equals: ship2.
]

{ #category : 'tests' }
GameFuelTest >> testFuelConsumptionIncludesEffectMovement [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'P1'.
    ship2 := Spaceship withName: 'P2'.
    board := Board of: 10 andWormholeAt: {}.
    board cells at: 1 put: BlackHoleEffect new.
    dice := DiceCup with: { MockDie value: 1 sides: 6 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ship1 maxFuel: 10.
    ship1 fuel: 10.

    game playTurn.

    self assert: ship1 fuel equals: 5.
]

{ #category : 'tests' }
GameFuelTest >> testPenaltyWhenFuelRunsOutDueToEffect [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'P1'.
    ship2 := Spaceship withName: 'P2'.
    board := Board of: 10 andWormholeAt: {}.
    board cells at: 1 put: BlackHoleEffect new.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ship1 maxFuel: 5.
    ship1 fuel: 3.

    game playTurn.

    self assert: (game isPenalized: ship1).
    self assert: (board positionOf: ship1) equals: 0.
]

{ #category : 'tests' }
GameFuelTest >> testAllySharesFuelWhenOwnerRunsOut [
    | owner ally board dice game card |
    owner := Spaceship withName: 'Owner'.
    ally := Spaceship withName: 'Ally'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { owner. ally } board: board dice: dice laps: 1.
    card := AllyCard withAlly: ally.
    card activateFor: owner inGame: nil.
    owner maxFuel: 5.
    owner fuel: 1.
    ally maxFuel: 5.
    ally fuel: 4.
    game consumeFuel: 2 forShip: owner.
    self assert: owner fuel equals: 0.
    self assert: ally fuel equals: 3.
]

{ #category : 'tests' }
GameFuelTest >> testAllyPenaltyWhenBothRunOutOfFuel [
    | owner allyShip board dice game card |
    owner := Spaceship withName: 'Owner'.
    allyShip := Spaceship withName: 'Friend'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { owner. allyShip } board: board dice: dice laps: 1.
    card := AllyCard withAlly: allyShip.
    card activateFor: owner inGame: nil.
    owner maxFuel: 5.
    owner fuel: 1.
    allyShip maxFuel: 5.
    allyShip fuel: 1.
    game consumeFuel: 2 forShip: owner.
    self assert: (game isPenalized: owner).
    self assert: (game isPenalized: allyShip).
    self assert: (board positionOf: owner) equals: 0.
    self assert: (board positionOf: allyShip) equals: 0.
]

{ #category : 'tests' }
GameFuelTest >> testRewardOnMaxRollChangesFuel [
    | ship otherShip dice board game initialMax initialFuel |
    ship := Spaceship withName: 'Reward'.
    otherShip := Spaceship withName: 'Other'.
    dice := DiceCup with: { Die withSides: 1 }.
    board := Board of: 5 andWormholeAt: #().
    ship maxFuel: 5.
    ship fuel: 5.
    game := Game startWithShips: { ship. otherShip } board: board dice: dice laps: 1.
    initialMax := ship maxFuel.
    initialFuel := ship fuel.
    game rollAndMoveCurrentShip.
    self assert: (
        (ship maxFuel = (initialMax + 1) and: [ ship fuel = (initialFuel - 1) ])
        or: [ ship maxFuel = initialMax and: [ ship fuel = (initialFuel - 2) ] ]).
]

{ #category : 'tests' }
GameFuelTest >> testAtomicBombDoesNotConsumeFuel [
    | ship1 ship2 board dice game initial |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 3 andWormholeAt: {}.
    board cells at: 1 put: AtomicBombEffect new.
    dice := DiceCup with: { MockDie value: 1 sides: 6 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    initial := ship1 fuel.
    game playTurn.
    self assert: ship1 fuel equals: initial - 1.
]

{ #category : 'tests' }
GameFuelTest >> testRecordFuelStartForMaintainsHistory [
    | ship1 ship2 board dice game history |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ship1 fuel: 5.
    game recordFuelStartFor: ship1.
    ship1 fuel: 4.
    game recordFuelStartFor: ship1.
    ship1 fuel: 3.
    game recordFuelStartFor: ship1.
    ship1 fuel: 2.
    game recordFuelStartFor: ship1.
    history := game fuelHistoryFor: ship1.
    self assert: history equals: { 4. 3. 2 } asOrderedCollection.
]

{ #category : 'tests' }
GameFuelTest >> testRewardForMaxRollIncreasesMaxFuel [
    | ship1 ship2 board dice game initial |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    initial := ship1 maxFuel.
    game rewardForMaxRollTo: ship1 withRoll: 1.
    self assert: ship1 maxFuel equals: initial + 1.
]

{ #category : 'tests' }
GameFuelTest >> testRewardForMaxRollCanReduceFuel [
    | ship1 ship2 board dice game initial |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ship1 fuel: 5.
    initial := ship1 fuel.
    game rewardForMaxRollTo: ship1 withRoll: 100.
    self assert: ship1 fuel equals: initial - 1.
]

{ #category : 'tests' }
GameFuelTest >> testPenalizeAndResetIfNoFuelAppliesPenalty [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    ship1 moveTo: 3.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ship1 fuel: 0.
    game penalizeAndResetIfNoFuel: ship1.
    self assert: (board positionOf: ship1) equals: 0.
    self assert: (game isPenalized: ship1).
]

{ #category : 'tests' }
GameFuelTest >> testPenalizeAndResetIfNoFuelDoesNothingWhenHasFuel [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    ship1 moveTo: 2.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ship1 fuel: 5.
    game penalizeAndResetIfNoFuel: ship1.
    self assert: (board positionOf: ship1) equals: 2.
    self deny: (game isPenalized: ship1).
]

{ #category : 'tests' }
GameFuelTest >> testFuelHistorySetterReplacesHistory [
    | ship1 ship2 board dice game history |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    history := Dictionary new.
    history at: ship1 put: (OrderedCollection with: 5).
    game fuelHistory: history.
    self assert: (game fuelHistoryFor: ship1) equals: (OrderedCollection with: 5).
]
