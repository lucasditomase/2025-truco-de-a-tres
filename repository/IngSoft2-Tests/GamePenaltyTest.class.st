Class {
    #name : 'GamePenaltyTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
GamePenaltyTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ].
]

{ #category : 'tests' }
GamePenaltyTest >> testHandlePenaltyOrPassIfNeededReturnsFalseWhenNoPenaltyAndNoPass [
    | ship dice board game result |

    ship := Spaceship withName: 'Neutral'.
    dice := DiceCup with: { Die withSides: 6 }.
    board := Board of: 5 andWormholeAt: #().
    game := Game
        startWithShips: { ship. (Spaceship withName: 'Other') }
        board: board
        dice: dice
        laps: 1.

    result := game handlePenaltyOrPassIfNeeded.

    self assert: result equals: false.
]

{ #category : 'tests' }
GamePenaltyTest >> testHandlePenaltyOrPassIfNeededReturnsTrueWhenPenalized [
    | ship dice board game result |

    ship := Spaceship withName: 'Penalized'.
    dice := DiceCup with: { Die withSides: 6 }.
    board := Board of: 5 andWormholeAt: #().
    game := Game
        startWithShips: { ship. (Spaceship withName: 'Other') }
        board: board
        dice: dice
        laps: 1.

    game penalize: ship forTurns: 1.

    result := game handlePenaltyOrPassIfNeeded.

    self assert: result equals: true.
]

{ #category : 'tests' }
GamePenaltyTest >> testHandlePenaltyOrPassIfNeededReturnsTrueWhenShipWantsToPassTurn [
    | ship dice board game result |

    ship := Spaceship withName: 'Pasante'.
    dice := DiceCup with: { Die withSides: 6 }.
    board := Board of: 5 andWormholeAt: #().
    game := Game
        startWithShips: { ship. (Spaceship withName: 'Other') }
        board: board
        dice: dice
        laps: 1.

    game markShipAsWantingToPassTurn: ship to: true.

    result := game handlePenaltyOrPassIfNeeded.

    self assert: result equals: true.
]

{ #category : 'tests' }
GamePenaltyTest >> testPenalizeAddsPenalizedShip [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Solo'.
    ship2 := Spaceship withName: 'Dummy'.
    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
        startWithShips: { ship1. ship2 }
        board: board
        dice: dice
        laps: 1.

    game penalize: ship1 forTurns: 2.

    self assert: (game isPenalized: ship1).
]

{ #category : 'tests - instance' }
GamePenaltyTest >> testPenaltyShipReturnsPenalizedShipsCollection [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'Pen'.
    ship2 := Spaceship withName: 'Ok'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game penalize: ship1 forTurns: 1.
    self assert: (game penaltyShip size) equals: 1.
    self assert: (game penaltyShip first) equals: ship1.
]

{ #category : 'tests' }
GamePenaltyTest >> testPenaltyTurnsRemainingFor [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Penalized'.
    ship2 := Spaceship withName: 'Other'.
    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
        startWithShips: { ship1. ship2 }
        board: board
        dice: dice
        laps: 1.

    game penalize: ship1 forTurns: 2.

    self assert: (game penalizedTurnsRemainingFor: ship1) equals: 2.

    game reducePenaltyFor: ship1.

    self assert: (game penalizedTurnsRemainingFor: ship1) equals: 1.
]

{ #category : 'tests' }
GamePenaltyTest >> testPlayTurnSkipsPenalizedShip [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Penalized'.
    ship2 := Spaceship withName: 'Next'.
    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
        startWithShips: { ship1. ship2 }
        board: board
        dice: dice
        laps: 1.

    game penalize: ship1 forTurns: 1.
    game playTurn.

    self assert: game currentShip equals: ship2.
]

{ #category : 'tests' }
GamePenaltyTest >> testReducePenaltyDecreasesTurnCount [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'PenaltyShip'.
    ship2 := Spaceship withName: 'Other'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game penalize: ship1 forTurns: 2.
    game reducePenaltyFor: ship1.
    game reducePenaltyFor: ship1.

    self deny: (game isPenalized: ship1).
]

{ #category : 'tests' }
GamePenaltyTest >> testReducePenaltyRemovesPenaltyEventually [
    | ship game dice penalty |

    ship := Spaceship withName: 'Penalized'.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game
        startWithShips: { ship. Spaceship withName: 'Other' }
        board: (Board of: 5 andWormholeAt: {})
        dice: dice
        laps: 1.

    game penalize: ship forTurns: 1.
    penalty := game stateOf: ship.

    self assert: (penalty hasPenalty).

    game reducePenaltyFor: ship.

    self deny: (penalty hasPenalty).
]

{ #category : 'tests' }
GamePenaltyTest >> testIsPenalizedDetectsPenalizedShip [
    | ship1 ship2 game dice |

    ship1 := Spaceship withName: 'P1'.
    ship2 := Spaceship withName: 'P2'.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game
        startWithShips: { ship1. ship2 }
        board: (Board of: 5 andWormholeAt: {})
        dice: dice
        laps: 1.

    game penalize: ship1 forTurns: 2.

    self assert: (game isPenalized: ship1).
    self deny: (game isPenalized: ship2).
]

{ #category : 'tests' }
GamePenaltyTest >> testWhenShipIsPenalizedThenSkipsTurnAndReducesPenalty [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dicesGame boardGame game |

    dice1 := Die withSides: 6.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 25 andWormholeAt: #(  ).

    game := Game
        startWithShips: spaceShipsGame
        board: boardGame
        dice: dicesGame
        laps: 1.

    game penalize: spaceShip1 forTurns: 2.
    game playTurn.

    self assert: game currentShip equals: spaceShip2.

    game playTurn.
    game playTurn.
    game playTurn.

    self assert: (game isPenalized: spaceShip1) not.
    self assert: game currentShip equals: spaceShip1.

    game playTurn.
    game playUntilFinish
]

{ #category : 'tests' }
GamePenaltyTest >> testPenalizedTurnsRemainingAndPenaltyShip [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game penalize: ship1 forTurns: 3.
    self assert: (game penalizedTurnsRemainingFor: ship1) equals: 3.
    self assert: (game penaltyShip includes: ship1).
]
