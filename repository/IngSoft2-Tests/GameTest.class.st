Class {
    #name : 'GameTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
GameTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
GameTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'support' }
GameTest >> clearHandOf: aShip [
    aShip cards copy do: [ :each | aShip removeCard: each ]
]

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
    | scenario game ship card |
    scenario := self builder
        withShipNames: #('A' 'B');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'A'.
    card := AccelerationCard new.
    ship addCard: card.
    self ensureTurnOf: ship inGame: game.
    ship playCard: card inGame: game.

    self assert: game activeCards size equals: 1.
    self assert: (game activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testAdvanceTurnCyclesCorrectly [
    | scenario game |
    scenario := self builder
        withShipNames: #('One' 'Two' 'Three');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.

    game advanceTurn.
    self assert: game currentTurnIndex equals: 2.

    game advanceTurn.
    self assert: game currentTurnIndex equals: 3.

    game advanceTurn.
    self assert: game currentTurnIndex equals: 1.
]

{ #category : 'tests' }
GameTest >> testAdvanceTurnRotatesToNextShip [
    | scenario game ship1 ship2 |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'One'.
    ship2 := scenario shipNamed: 'Two'.

    self assert: game currentShip equals: ship1.
    game advanceTurn.
    self assert: game currentShip equals: ship2.
]

{ #category : 'tests - instance' }
GameTest >> testBoardAccessorReturnsBoard [
    | scenario game board |
    board := nil.
    scenario := self builder
        boardFactory: [ board := Board of: 5 andWormholeAt: {} ];
        diceWithSides: 1;
        build.
    game := scenario game.
    self assert: game board equals: board.
]

{ #category : 'tests - instance' }
GameTest >> testCurrentPlayerIndexMatchesTurnIndex [
    | scenario game |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    self assert: game currentPlayerIndex equals: game currentTurnIndex.
]

{ #category : 'tests - instance' }
GameTest >> testCurrentShipReturnsCorrectShip [
    | scenario game ship1 ship2 |
    scenario := self builder
        withShipNames: #('First' 'Second');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'First'.
    ship2 := scenario shipNamed: 'Second'.

    self assert: game currentShip equals: ship1.
    game advanceTurn.
    self assert: game currentShip equals: ship2.
]

{ #category : 'tests - instance' }
GameTest >> testDieAccessorReturnsDiceCup [
    | scenario game dice |
    dice := nil.
    scenario := self builder
        diceCup: [ dice := DiceCup with: { Die withSides: 1 } ];
        build.
    game := scenario game.
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
GameTest >> testHyperGravityRequirementsConfiguredWithDiceMaxRoll [
    | ship1 ship2 board dice game effect |
    ship1 := Spaceship withName: 'H1'.
    ship2 := Spaceship withName: 'H2'.
    board := Board of: 5 andWormholeAt: {}.
    effect := HyperGravityEffect new.
    effect requiredRoll: 4.
    board cells at: 1 put: effect.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    self assert: effect requiredRoll equals: 1.
    game yourself.
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
    | scenario game passing next |
    scenario := self builder
        withShipNames: #('Passing' 'Next');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    passing := scenario shipNamed: 'Passing'.
    next := scenario shipNamed: 'Next'.

    game markShipAsWantingToPassTurn: passing to: true.
    game playTurn.

    self assert: game currentShip equals: next.
    self deny: (game wantsToPassTurn: passing).
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
    | scenario game ship |
    scenario := self builder
        withShipNames: #('P1' 'P2');
        boardWithCells: 5;
        configureBoardWith: [ :board | board cells at: 1 put: CardEffect new ];
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'P1'.

    game playTurn.

    self assert: ship cards size equals: 3.
]

{ #category : 'tests' }
GameTest >> testRepeatCardCanApplyLastCardEffectToChosenShip [
    | scenario game alpha beta advance repeat |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceCup: [ DiceCup with: { MockDie value: 1 sides: 6 } ];
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    alpha cards copy do: [ :each | alpha removeCard: each ].
    advance := AdvanceCard new.
    repeat := RepeatCard targeting: beta.
    alpha addCard: advance.
    alpha addCard: repeat.

    self ensureTurnOf: alpha inGame: game.
    alpha playCard: advance inGame: game.
    self assert: alpha position equals: 1.

    alpha playCard: repeat inGame: game.

    self assert: beta position equals: 1.
]

{ #category : 'tests' }
GameTest >> testPlayTurnRaisesErrorWhenGameIsOver [
    | scenario game |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 2;
        diceWithSides: 1;
        build.
    game := scenario game.

    game playUntilFinish.

    game whenFinishedDo: [ :w | self assert: true ]
        whenInProgressDo: [ self fail: 'Expected game to be over' ].

    self should: [ game playTurn ] raise: Error.
]

{ #category : 'tests' }
GameTest >> testPlayUntilFinishDeclaresWinner [
    | scenario game |
    scenario := self builder
        withShipNames: #('Fast' 'Slow');
        boardWithCells: 5;
        diceWithSides: 6;
        build.
    game := scenario game.
    game playUntilFinish.

    game
        whenFinishedDo: [ :w | self assert: w isNotNil ]
        whenInProgressDo: [ self fail: 'Expected game to be finished' ].
]

{ #category : 'tests - instance' }
GameTest >> testPlayUntilFinishEndsWhenWinnerIsFound [
    | scenario game |
    scenario := self builder
        withShipNames: #('Fast' 'Slow');
        boardWithCells: 2;
        diceWithSides: 6;
        build.
    game := scenario game.

    game playUntilFinish.

    game whenFinishedDo: [ :w | self assert: true ]
        whenInProgressDo: [ self fail: 'Expected game to be finished' ].
]

{ #category : 'tests' }
GameTest >> testRankingReturnsShipsOrderedByLapsAndPosition [
    | scenario game ranking ship1 ship2 ship3 |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2' 'Ship Num3');
        boardWithCells: 3;
        diceCup: [ DiceCup with: (OrderedCollection with: (MockDie value: 1 sides: 6)) ];
        laps: 2;
        build.
    game := scenario game.

    game playUntilFinish.
    ranking := game ranking.
    ship1 := scenario shipNamed: 'Ship Num1'.
    ship2 := scenario shipNamed: 'Ship Num2'.
    ship3 := scenario shipNamed: 'Ship Num3'.

    self assert: ranking size equals: 3.
    self assert: ranking first ship equals: ship1.
    self assert: ranking second ship equals: ship2.
    self assert: ranking third ship equals: ship3
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysAccelerationCard [
    | scenario game alpha beta card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    self clearHandOf: alpha.
    card := AccelerationCard new.
    alpha addCard: card.

    self ensureTurnOf: alpha inGame: game.
    alpha playCard: card inGame: game.

    self ensureTurnOf: beta inGame: game.
    self assert: beta activeCards isEmpty.
    game redoLastCardOn: beta.

    self assert: (beta activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysAllyCard [
    | scenario game owner ally newOwner card |
    scenario := self builder
        withShipNames: #('Owner' 'Ally' 'NewOwner');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    owner := scenario shipNamed: 'Owner'.
    ally := scenario shipNamed: 'Ally'.
    newOwner := scenario shipNamed: 'NewOwner'.
    self clearHandOf: owner.
    card := AllyCard withAlly: ally.
    owner addCard: card.

    self ensureTurnOf: owner inGame: game.
    owner playCard: card inGame: game.
    game removeActiveCard: card.

    self ensureTurnOf: newOwner inGame: game.
    game redoLastCardOn: newOwner.

    self assert: (newOwner activeCards includes: card).
    self assert: (ally activeCards includes: card).
    self deny: (owner activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysCancellationCard [
    | scenario game alpha beta shield cancel |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    self clearHandOf: alpha.
    self clearHandOf: beta.
    shield := ShieldCard new.
    alpha addCard: shield.

    self ensureTurnOf: alpha inGame: game.
    alpha playCard: shield inGame: game.

    cancel := CancellationCard cancelling: shield.
    beta addCard: cancel.
    self ensureTurnOf: beta inGame: game.
    beta playCard: cancel inGame: game.

    shield activateFor: alpha inGame: game.
    game redoLastCardOn: alpha.

    self deny: (alpha activeCards includes: shield).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysCard [
    | scenario game alpha beta card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    self clearHandOf: alpha.
    card := AdvanceCard new.
    alpha addCard: card.

    self ensureTurnOf: alpha inGame: game.
    alpha playCard: card inGame: game.

    self ensureTurnOf: beta inGame: game.
    game redoLastCardOn: beta.

    self assert: beta position equals: 1.
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysOverloadCard [
    | scenario game alpha beta card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    self clearHandOf: alpha.
    card := OverloadCard forShip: beta.
    alpha addCard: card.

    self ensureTurnOf: alpha inGame: game.
    alpha playCard: card inGame: game.
    game removeActiveCard: card.

    self ensureTurnOf: beta inGame: game.
    game redoLastCardOn: beta.

    self assert: (beta activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysRepeatCard [
    | scenario game alpha card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    self clearHandOf: alpha.
    card := RepeatCard new.
    alpha addCard: card.

    self ensureTurnOf: alpha inGame: game.
    alpha playCard: card inGame: game.
    game redoLastCardOn: alpha.

    self assert: alpha position equals: 0.
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysShieldCard [
    | scenario game alpha beta card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    self clearHandOf: alpha.
    card := ShieldCard new.
    alpha addCard: card.

    self ensureTurnOf: alpha inGame: game.
    alpha playCard: card inGame: game.
    game removeActiveCard: card.

    self ensureTurnOf: beta inGame: game.
    game redoLastCardOn: beta.

    self assert: (beta activeCards includes: card).
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
    | scenario game ship card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    self clearHandOf: ship.
    card := ShieldCard new.
    ship addCard: card.

    self ensureTurnOf: ship inGame: game.
    ship playCard: card inGame: game.
    self assert: (ship activeCards includes: card).

    game removeActiveCard: card.

    self assert: ship activeCards isEmpty.
]

{ #category : 'tests' }
GameTest >> testRepeatLastEffectOnDoesNothing [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.

    game repeatLastEffectOn: ship.

    self assert: ship position equals: 0.
]

{ #category : 'tests' }
GameTest >> testRepeatLastEffectOnAppliesLastEffect [
    | scenario game alpha beta |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        configureBoardWith: [ :board | board cells at: 1 put: CardEffect new ];
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.

    game playTurn.

    game repeatLastEffectOn: beta.

    self assert: beta cards size equals: 3.
]

{ #category : 'tests' }
GameTest >> testRollAndMoveCurrentShipMovesShipCorrectly [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Mover' 'Otro');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Mover'.

    game rollAndMoveCurrentShip.

    self assert: ship position equals: 1.
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

    dice1 := MockDie value: 1 sides: 6.
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

    dice1 := MockDie value: 1 sides: 6.
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
    dice1 := MockDie value: 1 sides: 6.
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

