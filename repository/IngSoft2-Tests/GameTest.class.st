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
        withDeckCyclingThrough: { AccelerationCard };
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'A'.
    
    self ensureTurnOf: ship inGame: game.
    card := ship cards first.
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
    | scenario game |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 1;
        diceWithSides: 100;
        build.
    game := scenario game.

    game playTurn.

    self should: [ game ensureGameIsNotOver ] raise: Error.
]

{ #category : 'tests' }
GameTest >> testFindPenaltyForReturnsExistingPenalty [
    | scenario game penalized |
    scenario := self builder
        withShipNames: #('Penalized' 'Unpunished');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    penalized := scenario shipNamed: 'Penalized'.

    game penalize: penalized forTurns: 2.

    self assert: (game isPenalized: penalized).
]

{ #category : 'tests' }
GameTest >> testGameEndsWithPlayUntilFinish [
    | scenario game |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 25;
        diceWithSides: 6;
        build.
    game := scenario game.

    game playUntilFinish.

    game whenFinishedDo: [ :w | self assert: true ] whenInProgressDo: [ self fail: 'Expected game to be finished' ].
]

{ #category : 'tests' }
GameTest >> testGameReturnsAllStatuses [
    | scenario game statuses |
    scenario := self builder
        withShipNames: #('A' 'B');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.

    statuses := game allStatuses.

    self assert: statuses size equals: 2.
    self assert: (statuses allSatisfy: [ :status | status ship isNotNil ]).
]

{ #category : 'tests' }
GameTest >> testGameReturnsFinalPositionsOfSpaceships [
    | scenario game ship1 ship2 positions pos1 pos2 |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 10;
        diceWithSides: 6;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Ship Num1'.
    ship2 := scenario shipNamed: 'Ship Num2'.

    game playUntilFinish.

    positions := game allShipStatuses.
    pos1 := positions detect: [ :each | each ship = ship1 ].
    pos2 := positions detect: [ :each | each ship = ship2 ].

    self assert: pos1 position equals: ship1 position.
    self assert: pos2 position equals: ship2 position.
]

{ #category : 'tests - instance' }
GameTest >> testHasWonByLapsReturnsFalseIfNotEnoughLaps [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Almost' 'Filler');
        boardWithCells: 3;
        diceCup: [ DiceCup with: { MockDie value: 3 sides: 6 } ];
        laps: 2;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Almost'.

    game playTurn.

    self deny: (game hasWonByLaps: ship).
]

{ #category : 'tests - instance' }
GameTest >> testHasWonByLapsReturnsTrueWhenEnoughLaps [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Winner' 'Filler');
        boardWithCells: 3;
        diceCup: [ DiceCup with: { MockDie value: 3 sides: 6 } ];
        laps: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Winner'.

    game playTurn.

    self assert: (game hasWonByLaps: ship).
]

{ #category : 'tests' }
GameTest >> testIsGameOverReturnsTrueWhenWinnerExists [
    | scenario game |
    scenario := self builder
        withShipNames: #('Closer' 'Later');
        boardWithCells: 5;
        diceWithSides: 6;
        build.
    game := scenario game.

    game playUntilFinish.

    game whenFinishedDo: [ :w | self assert: true ]
        whenInProgressDo: [ self fail: 'Expected the game to be over' ].
]

{ #category : 'tests - instance' }
GameTest >> testLastCardPlayedAccessors [
    | scenario game card |
    scenario := self builder
        withShipNames: #('A' 'B');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    card := AdvanceCard new.

    game lastCardPlayed: card.

    self assert: game lastCardPlayed equals: card.
]

{ #category : 'tests' }
GameTest >> testLastEffectiveCardAccessorDelegatesToTurnData [
    | scenario game card |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    card := ShieldCard new.

    game lastEffectiveCard: card.

    self assert: game lastEffectiveCard equals: card.
]

{ #category : 'tests' }
GameTest >> testAccelerationCardModifiesMovement [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 10;
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(2) sides: 6 } ];
        withDeckCyclingThrough: { AccelerationCard };
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.

    self ensureTurnOf: ship inGame: game.
    ship playCard: (ship cards first) inGame: game.

    game playTurn.

    self assert: (game board positionOf: ship) equals: 3.
]

{ #category : 'tests' }
GameTest >> testHyperGravityRequirementsConfiguredWithDiceMaxRoll [
    | scenario game effect |
    effect := HyperGravityEffect new.
    scenario := self builder
        withShipNames: #('H1' 'H2');
        boardWithCells: 5;
        configureBoardWith: [ :board | board cells at: 1 put: effect ];
        diceWithSides: 1;
        build.
    game := scenario game.

    self assert: effect requiredRoll equals: 1.
    game yourself.
]

{ #category : 'tests' }
GameTest >> testPassTurnAdvancesIndex [
    | scenario game skipper other |
    scenario := self builder
        withShipNames: #('Skip' 'Other');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    skipper := scenario shipNamed: 'Skip'.
    other := scenario shipNamed: 'Other'.

    self assert: game currentShip equals: skipper.
    game passTurn.
    self assert: game currentShip equals: other.
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
    | scenario game ship1 ship2 |
    scenario := self builder
        withShipNames: #('Player1' 'Player2');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Player1'.
    ship2 := scenario shipNamed: 'Player2'.

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
GameTest >> testDeckCyclingConfigurationProvidesDeterministicCards [
    | scenario game alpha beta |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        configureBoardWith: [ :board | board cells at: 1 put: CardEffect new ];
        withDeckCyclingThrough: { ShieldCard. AdvanceCard };
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(1) sides: 6 } ];
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    self clearHandOf: alpha.
    self clearHandOf: beta.

    game playTurn.
    self assert: alpha cards size equals: 1.
    self assert: alpha cards last class equals: ShieldCard.

    game playTurn.
    self assert: beta cards size equals: 1.
    self assert: beta cards last class equals: AdvanceCard.
]

{ #category : 'tests' }
GameTest >> testRepeatCardCanApplyLastCardEffectToChosenShip [
    | scenario game alpha beta advance repeat deck |
    alpha := Spaceship withName: 'Alpha'.
    beta := Spaceship withName: 'Beta'.
    advance := AdvanceCard new.
    repeat := RepeatCard targeting: beta.
    deck := OrderedCollection withAll: { advance. repeat. Card new. Card new }.
    
    scenario := self builder
        withShips: { alpha. beta };
        boardWithCells: 5;
        diceCup: [ DiceCup with: { MockDie value: 1 sides: 6 } ];
        withCardDealer: [ deck removeFirst ];
        build.
    game := scenario game.
    
    self ensureTurnOf: alpha inGame: game.
    alpha playCard: advance inGame: game.
    self assert: (game board positionOf: alpha) equals: 1.

    alpha playCard: repeat inGame: game.

    self assert: (game board positionOf: beta) equals: 1.
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
        withDeckCyclingThrough: { AccelerationCard };
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.

    self ensureTurnOf: alpha inGame: game.
    card := alpha cards first.
    alpha playCard: card inGame: game.

    self ensureTurnOf: beta inGame: game.
    self assert: beta activeCards isEmpty.
    game redoLastCardOn: beta.

    self assert: (beta activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysAllyCard [
    | scenario game owner ally newOwner card deck |
    owner := Spaceship withName: 'Owner'.
    ally := Spaceship withName: 'Ally'.
    newOwner := Spaceship withName: 'NewOwner'.
    card := AllyCard withAlly: ally.
    deck := OrderedCollection withAll: { card. Card new. Card new. Card new. Card new. Card new }.

    scenario := self builder
        withShips: { owner. ally. newOwner };
        boardWithCells: 5;
        diceWithSides: 1;
        withCardDealer: [ deck removeFirst ];
        build.
    game := scenario game.
    
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
    | scenario game alpha beta shield cancel deck |
    alpha := Spaceship withName: 'Alpha'.
    beta := Spaceship withName: 'Beta'.
    shield := ShieldCard new.
    cancel := CancellationCard cancelling: shield.
    deck := OrderedCollection withAll: { shield. Card new. cancel. Card new }.

    scenario := self builder
        withShips: { alpha. beta };
        boardWithCells: 5;
        diceWithSides: 1;
        withCardDealer: [ deck removeFirst ];
        build.
    game := scenario game.
    
    self ensureTurnOf: alpha inGame: game.
    alpha playCard: shield inGame: game.

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
        withDeckCyclingThrough: { AdvanceCard };
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    
    self ensureTurnOf: alpha inGame: game.
    card := alpha cards first.
    alpha playCard: card inGame: game.

    self ensureTurnOf: beta inGame: game.
    game redoLastCardOn: beta.

    self assert: (game board positionOf: beta) equals: 1.
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysOverloadCard [
    | scenario game alpha beta card deck |
    alpha := Spaceship withName: 'Alpha'.
    beta := Spaceship withName: 'Beta'.
    card := OverloadCard forShip: beta.
    deck := OrderedCollection withAll: { card. Card new. Card new. Card new }.

    scenario := self builder
        withShips: { alpha. beta };
        boardWithCells: 5;
        diceWithSides: 1;
        withCardDealer: [ deck removeFirst ];
        build.
    game := scenario game.
    
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
        withDeckCyclingThrough: { RepeatCard };
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    
    self ensureTurnOf: alpha inGame: game.
    card := alpha cards first.
    alpha playCard: card inGame: game.
    game redoLastCardOn: alpha.

    self assert: (game board positionOf: alpha) equals: 0.
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnReplaysShieldCard [
    | scenario game alpha beta card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        withDeckCyclingThrough: { ShieldCard };
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    
    self ensureTurnOf: alpha inGame: game.
    card := alpha cards first.
    alpha playCard: card inGame: game.
    game removeActiveCard: card.

    self ensureTurnOf: beta inGame: game.
    game redoLastCardOn: beta.

    self assert: (beta activeCards includes: card).
]

{ #category : 'tests' }
GameTest >> testRedoLastCardOnDoesNothingWhenNoCardWasPlayed [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.

    game redoLastCardOn: ship.

    self assert: ship position equals: 0.
]

{ #category : 'tests - instance' }
GameTest >> testRegisterLapWhenCrossesFinishLine [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Runner' 'Filler');
        boardWithCells: 3;
        diceCup: [ DiceCup with: { MockDie value: 3 sides: 6 } ];
        laps: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Runner'.

    game playTurn.

    self assert: (game lapTrackerFor: ship) lapCount equals: 1.
]

{ #category : 'tests' }
GameTest >> testRemoveActiveCardRemovesFromAllShips [
    | scenario game ship card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        withDeckCyclingThrough: { ShieldCard };
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    self ensureTurnOf: ship inGame: game.
    card := ship cards first.
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
GameTest >> testRepeatLastEffectOnReplaysLastCardEffect [
    | scenario game alpha beta card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        withDeckCyclingThrough: { AdvanceCard };
        diceWithSides: 1;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    
    self ensureTurnOf: alpha inGame: game.
    card := alpha cards first.
    alpha playCard: card inGame: game.

    game repeatLastEffectOn: beta.

    self assert: (game board positionOf: beta) equals: 1.
]

{ #category : 'tests' }
GameTest >> testRepeatLastEffectOnIgnoresNullCard [
    | scenario game beta |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    beta := scenario shipNamed: 'Beta'.

    game lastCardPlayed: NullCard new.
    game repeatLastEffectOn: beta.

    self assert: beta position equals: 0.
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
    | scenario game picky |
    scenario := self builder
        withShipNames: #('Picky' 'Spare');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    picky := scenario shipNamed: 'Picky'.

    self deny: (game wantsToPassTurn: picky).

    game markShipAsWantingToPassTurn: picky to: true.

    self assert: (game wantsToPassTurn: picky).
]

{ #category : 'tests' }
GameTest >> testShipPositionsReflectCurrentPositionsOfAllShips [
    | scenario game positions alpha beta pos1 pos2 |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    positions := game allShipStatuses.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.

    pos1 := positions detect: [ :each | each ship = alpha ].
    pos2 := positions detect: [ :each | each ship = beta ].

    self assert: pos1 position equals: alpha position.
    self assert: pos2 position equals: beta position.
]

{ #category : 'tests - instance' }
GameTest >> testShipStatusReturnsCorrectValues [
    | scenario game ship status |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 25;
        diceWithSides: 2;
        laps: 2;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Ship Num1'.

    game playTurn.
    game playTurn.

    status := game statusFor: ship.

    self assert: status ship equals: ship.
    self assert: status position equals: ship position.
    self assert: status lapCount equals: 0.
    self assert: status isPenalized equals: false.
]

{ #category : 'tests' }
GameTest >> testStateOfDelegatesToShipState [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    ship penalizeFor: 1.

    self assert: (game stateOf: ship) class equals: PenalizedShipState.
]

{ #category : 'tests' }
GameTest >> testShipStatusReturnsCurrentLap [
    | scenario game ship1 ship2 status1 status2 |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 2;
        diceWithSides: 1;
        laps: 2;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Ship Num1'.
    ship2 := scenario shipNamed: 'Ship Num2'.

    game playTurn.
    game playTurn.
    game playTurn.

    status1 := game statusFor: ship1.
    status2 := game statusFor: ship2.

    self assert: status1 lapCount equals: 1.
    self assert: status2 lapCount equals: 0.
]

{ #category : 'tests' }
GameTest >> testShipStatusReturnsCurrentPosition [
    | scenario game ship1 ship2 status1 status2 |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 2;
        diceWithSides: 1;
        laps: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Ship Num1'.
    ship2 := scenario shipNamed: 'Ship Num2'.

    game playUntilFinish.

    status1 := game statusFor: ship1.
    status2 := game statusFor: ship2.

    self assert: status1 position equals: ship1 position.
    self assert: status2 position equals: ship2 position.
]

{ #category : 'tests' }
GameTest >> testShipsStartWithTwoCards [
    | scenario ship1 ship2 |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    ship1 := scenario shipNamed: 'One'.
    ship2 := scenario shipNamed: 'Two'.
    self assert: ship1 cards size equals: 2.
    self assert: ship2 cards size equals: 2.
]

{ #category : 'tests - instance' }
GameTest >> testSpaceShipsAccessorReturnsShips [
    | scenario game |
    scenario := self builder
        withShipNames: #('A' 'B');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    self assert: game spaceShips equals: scenario ships.
]

{ #category : 'tests' }
GameTest >> testSpaceshipPositionsReturnsCorrectMapping [
    | scenario game positions mapOne mapTwo pos1 pos2 |
    scenario := self builder
        withShipNames: #('MapOne' 'MapTwo');
        boardWithCells: 20;
        diceCup: [ DiceCup with: { MockDie value: 2 sides: 6 } ];
        build.
    game := scenario game.
    mapOne := scenario shipNamed: 'MapOne'.
    mapTwo := scenario shipNamed: 'MapTwo'.

    game playTurn.
    game playTurn.
    game playTurn.

    positions := game allShipStatuses.
    pos1 := positions detect: [ :each | each ship = mapOne ].
    pos2 := positions detect: [ :each | each ship = mapTwo ].

    self assert: pos1 position equals: mapOne position.
    self assert: pos2 position equals: mapTwo position.
]

{ #category : 'tests' }
GameTest >> testSpaceshipPositionsReturnsCorrectPositions [
    | scenario game positions ship1 ship2 pos1 pos2 |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 10;
        diceCup: [ DiceCup with: (OrderedCollection with: (MockDie value: 1 sides: 6)) ];
        laps: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Ship Num1'.
    ship2 := scenario shipNamed: 'Ship Num2'.

    game playTurn.

    positions := game allShipStatuses.
    pos1 := positions detect: [ :each | each ship = ship1 ].
    pos2 := positions detect: [ :each | each ship = ship2 ].

    self assert: pos1 position equals: ship1 position.
    self assert: pos2 position equals: ship2 position.
]

{ #category : 'tests' }
GameTest >> testStatusForReturnsCorrectInfo [
    | scenario game ship status |
    scenario := self builder
        withShipNames: #('StatusShip' 'Dummy');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'StatusShip'.

    status := game statusFor: ship.

    self assert: status ship equals: ship.
    self assert: status position equals: ship position.
    self assert: status lapCount equals: 0.
    self deny: status isPenalized.
]

{ #category : 'tests' }
GameTest >> testStatusForReturnsCorrectShipStatus [
    | scenario game ship status |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 10;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.

    status := game statusFor: ship.

    self assert: status ship equals: ship.
    self assert: status position equals: ship position.
]

{ #category : 'tests' }
GameTest >> testWhenPlayTurnThenAdvancesShip [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 10;
        diceCup: [ DiceCup with: { MockDie value: 1 sides: 6 } ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Ship Num1'.

    self assert: ship position equals: 0.
    game playTurn.
    self assert: ship position equals: 1.
]

{ #category : 'tests' }
GameTest >> testWhenShipDecidesToPassTurnThenSkipTurn [
    | scenario game ship1 ship2 |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 25;
        diceWithSides: 6;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Ship Num1'.
    ship2 := scenario shipNamed: 'Ship Num2'.

    game playTurn.
    game playTurn.
    game markShipAsWantingToPassTurn: ship1 to: true.
    game playTurn.

    self assert: game currentShip equals: ship2.

    game playUntilFinish.
]


{ #category : 'tests' }
GameTest >> testWhenShipReachesGoalThenGameEnds [
    | scenario game |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 1;
        diceWithSides: 100;
        build.
    game := scenario game.

    game playTurn.

    game whenFinishedDo: [ :w | self assert: true ]
        whenInProgressDo: [ self fail: 'Expected game to be finished' ].
]

{ #category : 'tests' }
GameTest >> testWhenShipWinsByCompletingRequiredLapsThenEndsGame [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 3;
        diceCup: [ DiceCup with: (OrderedCollection with: (MockDie value: 1 sides: 6)) ];
        laps: 3;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Ship Num1'.

    game playUntilFinish.

    self assert: (game lapTrackerFor: ship) lapCount equals: 3.
    self assert: (game hasWonByLaps: ship).
]

{ #category : 'tests' }
GameTest >> testWhenSpaceShipEndsTurnThenRotatesPlayerTurn [
    | scenario game ship1 ship2 expectedSequence actualSequence |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Ship Num1'.
    ship2 := scenario shipNamed: 'Ship Num2'.

    expectedSequence := OrderedCollection withAll: {
        ship1.
        ship2.
        ship1.
        ship2.
        ship1 }.

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
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 1;
        diceWithSides: 100;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Ship Num1'.

    game playTurn.

    game
        whenFinishedDo: [ :winner | self assert: winner equals: ship ]
        whenInProgressDo: [ self fail: 'Expected game to be finished' ]
]

{ #category : 'tests' }
GameTest >> testWinnerReturnsNilWhenGameInProgress [
    | scenario game |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 3;
        diceWithSides: 1;
        laps: 2;
        build.
    game := scenario game.
    self assert: game winner isNullShip.
]

{ #category : 'tests' }
GameTest >> testWinnerReturnsShipWhenGameFinishes [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 1;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.

    game playTurn.

    self assert: game winner equals: ship.
]

{ #category : 'tests' }
GameTest >> testValidateIsCurrentPlayerRaisesError [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('A' 'B');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'B'.

    self
        should: [ game validateIsCurrentPlayer: ship ]
        raise: Error
        withMessageText: 'It is not the turn of this spaceship'.
]

