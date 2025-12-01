Class {
    #name : 'GameLapTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
GameLapTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
GameLapTest >> testRegisterLapForSubtractsLapWhenMovingBackwardsPastStart [
    | ship1 ship2 board dice game status |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 3.
    status := game lapTrackerFor: ship1.
    status addLap.
    game registerLapFor: ship1 from: 1 after: -3.
    self assert: status lapCount equals: 0.
]

{ #category : 'tests' }
GameLapTest >> testRegisterLapForAddsMultipleForwardLapsWhenWrappingRepeatedly [
    | ship1 ship2 board dice game status |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 10.
    status := game lapTrackerFor: ship1.

    game registerLapFor: ship1 from: 4 after: 12.

    self assert: status lapCount equals: 3.
]

{ #category : 'tests' }
GameLapTest >> testRegisterLapForSubtractsMultipleBackwardLapsWhenWrappingRepeatedly [
    | ship1 ship2 board dice game status |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 10.
    status := game lapTrackerFor: ship1.
    4 timesRepeat: [ status addLap ].

    game registerLapFor: ship1 from: 1 after: -11.

    self assert: status lapCount equals: 2.
]
