Class {
    #name : 'GameTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
GameTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
    should: anErrorBlock
    raise: anErrorClass
    withExceptionDo: [ :error |
    self assert: error messageText equals: errorMessage].
]

{ #category : 'tests' }
GameTest >> testActiveCardsReturnsAllActiveCards [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.
    card := AccelerationCard new.
    ship1 addActiveCard: card.
    self assert: (game activeCards size) equals: 1.
    self assert: (game activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testAdvanceTurnCyclesCorrectly [
    | ship1 ship2 ship3 board dice game |

    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ship3 := Spaceship withName: 'Three'.

    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2. ship3 }
    board: board
    dice: dice
    laps: 1.

    game advanceTurn.
    self assert: game currentTurnIndex equals: 2.

    game advanceTurn.
    self assert: game currentTurnIndex equals: 3.

    game advanceTurn.
    self assert: game currentTurnIndex equals: 1.
]

{ #category : 'tests' }
GameTest >> testAdvanceTurnRotatesToNextShip [
    | ship1 ship2 game dice |

    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game
    startWithShips: { ship1. ship2 }
    board: (Board of: 5 andWormholeAt: {})
    dice: dice
    laps: 1.

    self assert: game currentShip equals: ship1.
    game advanceTurn.
    self assert: game currentShip equals: ship2.
]

{ #category : 'tests - instance' }
GameTest >> testBoardAccessorReturnsBoard [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.
    self assert: game board equals: board.
]

{ #category : 'tests - instance' }
GameTest >> testCurrentPlayerIndexMatchesTurnIndex [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.
    self assert: game currentPlayerIndex equals: game currentTurnIndex.
]

{ #category : 'tests - instance' }
GameTest >> testCurrentShipReturnsCorrectShip [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'First'.
    ship2 := Spaceship withName: 'Second'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.

    self assert: game currentShip equals: ship1.
    game advanceTurn.
    self assert: game currentShip equals: ship2.
]

{ #category : 'tests - instance' }
GameTest >> testDieAccessorReturnsDiceCup [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'S1'.
    ship2 := Spaceship withName: 'S2'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.
    self assert: game die equals: dice.
]

{ #category : 'tests' }
GameTest >> testEnsureGameIsNotOverRaisesErrorIfGameFinished [
    | ship1 ship2 dice board game |

    ship1 := Spaceship withName: 'Alpha'.
    ship2 := Spaceship withName: 'Beta'.

    dice := DiceCup with: { Die withSides: 100 }.
    board := Board of: 5 andWormholeAt: #().

    ship1 moveTo: 4.
    ship2 moveTo: 0.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.
    game playTurn.
    game checkWinCondition.

    self should: [ game ensureGameIsNotOver ] raise: Error.
]

{ #category : 'tests' }
GameTest >> testFindPenaltyForReturnsExistingPenalty [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Penalized'.
    ship2 := Spaceship withName: 'Unpunished'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.
    game penalize: ship1 forTurns: 2.

    self assert: (game isPenalized: ship1).
]

{ #category : 'tests' }
GameTest >> testGameEndsWithPlayUntilFinish [
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

    game playUntilFinish.

    game whenFinishedDo: [ :w | self assert: true ] whenInProgressDo: [ self fail: 'Expected game to be finished' ].
]

{ #category : 'tests' }
GameTest >> testGameReturnsAllStatuses [
    | ship1 ship2 board dice game statuses |

    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.

    statuses := game allStatuses.

    self assert: statuses size equals: 2.
    self assert: (statuses allSatisfy: [ :status | status ship isNotNil ]).
]

{ #category : 'tests' }
GameTest >> testGameReturnsFinalPositionsOfSpaceships [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dicesGame boardGame game positions finalPositionShip1 finalPositionShip2 pos1 pos2 |

    dice1 := Die withSides: 100.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 10 andWormholeAt: #().

    game := Game
    startWithShips: spaceShipsGame
    board: boardGame
    dice: dicesGame
    laps: 1.

    [ game whenFinishedDo: [ :w | false ] whenInProgressDo: [ true ] ]
    whileTrue: [ game playTurn ].

    positions := game spaceshipPositions.
    finalPositionShip1 := spaceShip1 position.
    finalPositionShip2 := spaceShip2 position.

    pos1 := positions detect: [ :each | each ship = spaceShip1 ].
    pos2 := positions detect: [ :each | each ship = spaceShip2 ].

    self assert: pos1 position equals: finalPositionShip1.
    self assert: pos2 position equals: finalPositionShip2.
]

{ #category : 'tests - instance' }
GameTest >> testHasWonByLapsReturnsFalseIfNotEnoughLaps [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Almost'.
    ship2 := Spaceship withName: 'Filler'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 2.

    ship1 moveTo: 10.
    game registerLapFor: ship1 from: 9 after: 1.

    self deny: (game hasWonByLaps: ship1).
]

{ #category : 'tests - instance' }
GameTest >> testHasWonByLapsReturnsTrueWhenEnoughLaps [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Winner'.
    ship2 := Spaceship withName: 'Loser'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.

    ship1 moveTo: 10.
    game registerLapFor: ship1 from: 9 after: 1.

    self assert: (game hasWonByLaps: ship1).
]

{ #category : 'tests' }
GameTest >> testIsGameOverReturnsTrueWhenWinnerExists [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Closer'.
    ship2 := Spaceship withName: 'Later'.
    board := Board of: 5 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 6 }.

    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game playUntilFinish.

    game whenFinishedDo: [ :w | self assert: true ]
    whenInProgressDo: [ self fail: 'Expected the game to be over' ].
]

{ #category : 'tests - instance' }
GameTest >> testLastCardPlayedAccessors [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := AdvanceCard new.
    game lastCardPlayed: card.
    self assert: game lastCardPlayed equals: card.
]

{ #category : 'tests' }
GameTest >> testModifyRollAppliesActiveCardEffect [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := AccelerationCard new.
    ship1 addActiveCard: card.
    self assert: (game modifyRoll: 2 forShip: ship1) equals: 3.
]

{ #category : 'tests' }
GameTest >> testPassTurnAdvancesIndex [
    | ship1 ship2 game board dice |

    ship1 := Spaceship withName: 'Skip'.
    ship2 := Spaceship withName: 'Other'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.

    self assert: game currentShip equals: ship1.
    game passTurn.
    self assert: game currentShip equals: ship2.
]

{ #category : 'tests' }
GameTest >> testPlayTurnHandlesPassTurnCorrectly [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Passing'.
    ship2 := Spaceship withName: 'Next'.
    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.

    game markShipAsWantingToPassTurn: ship1 to: true.
    game playTurn.

    self assert: game currentShip equals: ship2.
    self deny: (game wantsToPassTurn: ship1).
]

{ #category : 'tests' }
GameTest >> testPlayTurnMovesShipAndAdvancesTurn [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Player1'.
    ship2 := Spaceship withName: 'Player2'.
    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.

    game playTurn.

    self assert: ship1 position equals: 1.
    self assert: game currentShip equals: ship2.
]

{ #category : 'tests' }
GameTest >> testPlayTurnAppliesBoardEffect [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'P1'.
    ship2 := Spaceship withName: 'P2'.
    board := Board of: 5 andWormholeAt: {}.
    board cells at: 1 put: CardEffect new.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.

    game playTurn.

    self assert: ship1 cards size equals: 3.
]

{ #category : 'tests' }
GameTest >> testPlayTurnRaisesErrorWhenGameIsOver [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    board := Board of: 2 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.

    ship1 moveTo: 1.
    game playTurn.

    game whenFinishedDo: [ :w | self assert: true ]
    whenInProgressDo: [ self fail: 'Expected game to be over' ].

    self should: [ game playTurn ] raise: Error.
]

{ #category : 'tests' }
GameTest >> testPlayUntilFinishDeclaresWinner [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Fast'.
    ship2 := Spaceship withName: 'Slow'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 6 }.

    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game playUntilFinish.

    game
    whenFinishedDo: [ :w | self assert: w isNotNil ]
    whenInProgressDo: [ self fail: 'Expected game to be finished' ].
]

{ #category : 'tests - instance' }
GameTest >> testPlayUntilFinishEndsWhenWinnerIsFound [
    | ship1 ship2 game dice |

    ship1 := Spaceship withName: 'Fast'.
    ship2 := Spaceship withName: 'Slow'.
    dice := DiceCup with: { Die withSides: 6 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: (Board of: 2 andWormholeAt: #())
    dice: dice
    laps: 1.

    game playUntilFinish.

    game whenFinishedDo: [ :w | self assert: true ]
    whenInProgressDo: [ self fail: 'Expected game to be finished' ].
]

{ #category : 'tests' }
GameTest >> testRankingReturnsShipsOrderedByLapsAndPosition [
    | spaceShip1 spaceShip2 spaceShip3 spaceShipsGame  dice1  dicesGame boardGame game ranking |

    dice1 := Die withSides: 1.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShip3 := Spaceship withName: 'Ship Num3'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2 with: spaceShip3.

    boardGame := Board of: 3 andWormholeAt: #(  ).

    game := Game
    startWithShips: spaceShipsGame
    board: boardGame
    dice: dicesGame
    laps: 2.

    game playUntilFinish.

    ranking := game ranking.

    self assert: ranking size equals: 3.

    self assert: ranking first ship equals: spaceShip1.
    self assert: ranking second ship equals: spaceShip2.
    self assert: ranking third ship equals: spaceShip3
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysAccelerationCard [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := AccelerationCard new.
    game lastCardPlayed: card.
    game redoLastCardOn: ship1.
    self assert: (ship1 activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysAllyCard [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := AllyCard withAlly: ship2.
    game lastCardPlayed: card.
    game redoLastCardOn: ship1.
    self assert: (ship1 activeCards includes: card).
    self assert: (ship2 activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysCancellationCard [
    | ship1 ship2 board dice game card target |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    target := ShieldCard new.
    ship1 addActiveCard: target.
    card := CancellationCard cancelling: target.
    game lastCardPlayed: card.
    game redoLastCardOn: ship1.
    self deny: (ship1 activeCards includes: target).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysCard [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := AdvanceCard new.
    game lastCardPlayed: card.
    game redoLastCardOn: ship1.
    self assert: ship1 position equals: 1.
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysOverloadCard [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := OverloadCard forShip: ship1.
    game lastCardPlayed: card.
    game redoLastCardOn: ship1.
    self assert: (ship1 activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysRepeatCard [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {  }.
    dice := DiceCup with: { (Die withSides: 1) }.
    game := Game
    startWithShips: {
        ship1.
        ship2 }
    board: board
    dice: dice
    laps: 1.
    card := RepeatCard new.
    game lastCardPlayed: card.
    game redoLastCardOn: ship1.
    self assert: ship1 position equals: 0
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysShieldCard [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := ShieldCard new.
    game lastCardPlayed: card.
    game redoLastCardOn: ship1.
    self assert: (ship1 activeCards includes: card).
]

{ #category : 'tests - instance' }
GameTest >> testRegisterLapWhenCrossesFinishLine [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Runner'.
    ship2 := Spaceship withName: 'Other'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.

    ship1 moveTo: 9.
    game registerLapFor: ship1 from: 9 after: 2.

    self assert: ((game lapTrackerFor: ship1) lapCount) equals: 1.
]

{ #category : 'tests' }
GameTest >> testRemoveActiveCardRemovesFromAllShips [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := AccelerationCard new.
    ship1 addActiveCard: card.
    game removeActiveCard: card.
    self assert: ship1 activeCards isEmpty.
]

{ #category : 'tests' }
GameTest >> testRepeatLastEffectOnDoesNothing [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game repeatLastEffectOn: ship1.
    self assert: ship1 position equals: 0.
]

{ #category : 'tests' }
GameTest >> testRepeatLastEffectOnAppliesLastEffect [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    board := Board of: 5 andWormholeAt: {}.
    board cells at: 1 put: CardEffect new.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.

    game rollAndMoveCurrentShip.
    board applyEffectTo: ship1.

    game repeatLastEffectOn: ship2.

    self assert: ship2 cards size equals: 3.
]

{ #category : 'tests' }
GameTest >> testRollAndMoveCurrentShipMovesShipCorrectly [
    | ship otherShip dice board game originalPosition |

    ship := Spaceship withName: 'Mover'.
    otherShip := Spaceship withName: 'Otro'.
    dice := DiceCup with: { Die withSides: 1 }.
    board := Board of: 10 andWormholeAt: #().
    game := Game startWithShips: { ship. otherShip } board: board dice: dice laps: 1.

    originalPosition := ship position.

    game rollAndMoveCurrentShip.

    self assert: ship position equals: originalPosition + 1.
]

{ #category : 'tests - instance' }
GameTest >> testSetAndQueryWantsToPassTurn [
    | ship1 ship2 board dice game |

    ship1 := Spaceship withName: 'Picky'.
    ship2 := Spaceship withName: 'Spare'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    self deny: (game wantsToPassTurn: ship1).

    game markShipAsWantingToPassTurn: ship1 to: true.
    self assert: (game wantsToPassTurn: ship1).
]

{ #category : 'tests' }
GameTest >> testShipPositionsReflectCurrentPositionsOfAllShips [
    | ship1 ship2 board dice game positions pos1 pos2 |

    ship1 := Spaceship withName: 'Alpha'.
    ship2 := Spaceship withName: 'Beta'.
    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.

    positions := game spaceshipPositions.

    pos1 := positions detect: [ :each | each ship = ship1 ].
    pos2 := positions detect: [ :each | each ship = ship2 ].

    self assert: pos1 position equals: 0.
    self assert: pos2 position equals: 0.
]

{ #category : 'tests - instance' }
GameTest >> testShipStatusReturnsCorrectValues [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dicesGame boardGame game status |
    dice1 := Die withSides: 2.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 25 andWormholeAt: #(  ).

    game := Game
    startWithShips: spaceShipsGame
    board: boardGame
    dice: dicesGame
    laps: 2.

    game playTurn.
    game playTurn.

    status := game statusFor: spaceShip1.

    self assert: status ship equals: spaceShip1.
    self assert: status position equals: spaceShip1 position.
    self assert: status lapCount equals: 0.
    self assert: status isPenalized equals: false
]

{ #category : 'tests' }
GameTest >> testShipStatusReturnsCurrentLap [
    | spaceShip1 spaceShip2  spaceShipsGame die dicesGame boardGame game status1 status2 |

    die := Die withSides: 1.
    dicesGame := DiceCup with: (OrderedCollection with: die).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection
        with: spaceShip1
        with: spaceShip2.

    boardGame := Board of: 2 andWormholeAt: #(  ).

    game := Game
        startWithShips: spaceShipsGame
        board: boardGame
        dice: dicesGame
        laps: 2.

    game playTurn.
    game playTurn.
    game playTurn.

    status1 := game statusFor: spaceShip1.
    status2 := game statusFor: spaceShip2.

    self assert: status1 lapCount equals: 1.
    self assert: status2 lapCount equals: 0.
]

{ #category : 'tests' }
GameTest >> testShipStatusReturnsCurrentPosition [
    | spaceShip1 spaceShip2  spaceShipsGame die dicesGame boardGame game status1 status2 |

    die := Die withSides: 1.
    dicesGame := DiceCup with: (OrderedCollection with: die).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection
        with: spaceShip1
        with: spaceShip2.

    boardGame := Board of: 2 andWormholeAt: #(  ).

    game := Game
    startWithShips: spaceShipsGame
    board: boardGame
    dice: dicesGame
    laps: 1.

    game playUntilFinish.

    status1 := game statusFor: spaceShip1.
    status2 := game statusFor: spaceShip2.

    self assert: status1 position equals: 0.
    self assert: status2 position equals: 1.
]

{ #category : 'tests' }
GameTest >> testShipsStartWithTwoCards [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    self assert: ship1 cards size equals: 2.
    self assert: ship2 cards size equals: 2.
]

{ #category : 'tests - instance' }
GameTest >> testSpaceShipsAccessorReturnsShips [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    self assert: game spaceShips equals: { ship1. ship2 } asOrderedCollection.
]

{ #category : 'tests' }
GameTest >> testSpaceshipPositionsReturnsCorrectMapping [
    | ship1 ship2 game board dice positions pos1 pos2 |

    ship1 := Spaceship withName: 'MapOne'.
    ship2 := Spaceship withName: 'MapTwo'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ship1 moveTo: 3.
    ship2 moveTo: 7.

    positions := game spaceshipPositions.

    pos1 := positions detect: [ :each | each ship = ship1 ].
    pos2 := positions detect: [ :each | each ship = ship2 ].

    self assert: pos1 position equals: 3.
    self assert: pos2 position equals: 7.
]

{ #category : 'tests' }
GameTest >> testSpaceshipPositionsReturnsCorrectPositions [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dicesGame boardGame game positions pos1 pos2 |

    dice1 := Die withSides: 1.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 10 andWormholeAt: #().

    game := Game
    startWithShips: spaceShipsGame
    board: boardGame
    dice: dicesGame
    laps: 1.

    game playTurn.

    positions := game spaceshipPositions.

    pos1 := positions detect: [ :each | each ship = spaceShip1 ].
    pos2 := positions detect: [ :each | each ship = spaceShip2 ].

    self assert: pos1 position equals: 1.
    self assert: pos2 position equals: 0.
]

{ #category : 'tests' }
GameTest >> testStatusForReturnsCorrectInfo [
    | ship1 ship2 board dice game status |

    ship1 := Spaceship withName: 'StatusShip'.
    ship2 := Spaceship withName: 'Dummy'.
    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game
    startWithShips: { ship1. ship2 }
    board: board
    dice: dice
    laps: 1.

    status := game statusFor: ship1.

    self assert: status ship equals: ship1.
    self assert: status position equals: 0.
    self assert: status lapCount equals: 0.
    self deny: status isPenalized.
]

{ #category : 'tests' }
GameTest >> testStatusForReturnsCorrectShipStatus [
    | ship1 ship2 game board dice status |

    ship1 := Spaceship withName: 'Alpha'.
    ship2 := Spaceship withName: 'Beta'.
    board := Board of: 10 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.

    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.

    status := game statusFor: ship1.

    self assert: status ship equals: ship1.
    self assert: status position equals: 0.
]

{ #category : 'tests' }
GameTest >> testWhenPlayTurnThenAdvancesShip [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dice2 dicesGame boardGame game originalPosition newPosition |

    dice1 := Die withSides: 1.
    dice2 := Die withSides: 6.
    dicesGame := DiceCup with: (OrderedCollection with: dice1 with: dice2).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 10 andWormholeAt: #(  ).

    game := Game
    startWithShips: spaceShipsGame
    board: boardGame
    dice: dicesGame
    laps: 1.

    originalPosition := spaceShip1 position.
    game playTurn.
    newPosition := spaceShip1 position.

    self deny: originalPosition equals: newPosition.
]

{ #category : 'tests' }
GameTest >> testWhenShipDecidesToPassTurnThenSkipTurn [
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

    game playTurn.
    game playTurn.
    game markShipAsWantingToPassTurn: spaceShip1 to: true.
    game playTurn.

    self assert: game currentShip equals: spaceShip2.

    game playUntilFinish.
]

{ #category : 'tests' }
GameTest >> testWhenShipReachesGoalThenGameEnds [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dicesGame boardGame game |

    dice1 := Die withSides: 100.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 1 andWormholeAt: #().

    game := Game
    startWithShips: spaceShipsGame
    board: boardGame
    dice: dicesGame
    laps: 1.

    game playTurn.

    game whenFinishedDo: [ :w | self assert: true ]
    whenInProgressDo: [ self fail: 'Expected game to be finished' ].
]

{ #category : 'tests' }
GameTest >> testWhenShipWinsByCompletingRequiredLapsThenEndsGame [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dicesGame boardGame totalLaps game |
    dice1 := Die withSides: 1.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 3 andWormholeAt: #(  ).

    totalLaps := 3.

    game := Game
            startWithShips: spaceShipsGame
            board: boardGame
            dice: dicesGame
            laps: totalLaps.

    game playUntilFinish.
    self assert: (game lapTrackerFor: spaceShip1) lapCount equals: 3.
    self assert: (game hasWonByLaps: spaceShip1)
]

{ #category : 'tests' }
GameTest >> testWhenSpaceShipEndsTurnThenRotatesPlayerTurn [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dicesGame boardGame game expectedSequence actualSequence |

    dice1 := Die withSides: 1.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 5 andWormholeAt: #().

    game := Game
    startWithShips: spaceShipsGame
    board: boardGame
    dice: dicesGame
    laps: 1.

    expectedSequence := OrderedCollection withAll: {
        spaceShip1.
        spaceShip2.
        spaceShip1.
        spaceShip2.
        spaceShip1 }.

    actualSequence := OrderedCollection new.

    [ actualSequence size < expectedSequence size and: (
        game whenFinishedDo: [ :w | false ]
        whenInProgressDo: [ true ]) ]
    whileTrue: [
        actualSequence add: game currentShip.
        game playTurn
    ].

    self assert: actualSequence equals: expectedSequence.
]

{ #category : 'tests' }
GameTest >> testWhenWinnerSpaceShipIsCorrectWhenGameEnds [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dicesGame boardGame game |

    dice1 := Die withSides: 100.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 1 andWormholeAt: #(  ).

    game := Game
    startWithShips: spaceShipsGame
    board: boardGame
    dice: dicesGame
    laps: 1.

    game playTurn.

    game
    whenFinishedDo: [ :winner | self assert: winner equals: spaceShip1 ]
    whenInProgressDo: [ self fail: 'Expected game to be finished' ]
]

{ #category : 'tests' }
GameTest >> testWinnerReturnsNilWhenGameInProgress [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'Alpha'.
    ship2 := Spaceship withName: 'Beta'.
    board := Board of: 3 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 2.
    self assert: (game winner) isNullShip.
]

{ #category : 'tests' }
GameTest >> testWinnerReturnsShipWhenGameFinishes [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'Alpha'.
    ship2 := Spaceship withName: 'Beta'.
    board := Board of: 1 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game playTurn.
    self assert: game winner equals: ship1.
]



{ #category : 'tests' }
GameTest >> testValidateIsCurrentPlayerRaisesError [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    self
        should: [ game validateIsCurrentPlayer: ship2 ]
        raise: Error
        withMessageText: 'It is not the turn of this spaceship'.
]

