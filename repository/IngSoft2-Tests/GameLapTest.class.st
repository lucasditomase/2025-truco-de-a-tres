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
