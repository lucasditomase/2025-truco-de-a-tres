Class {
    #name : 'Game',
    #superclass : 'Object',
    #instVars : [
        'spaceShips',
        'board',
        'dice',
        'turnManager',
        'wantsToPassTurn',
        'totalLaps',
        'state',
        'shipStatuses',
        'turnData'
        ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialize' }
Game class >> startWithShips: someShips board: aBoard dice: someDices laps: aNumberLaps [
    self validateMinimumShips: someShips.
    self validateShips: someShips.
    self validateBoard: aBoard.
    self validateDice: someDices.
    self validateLaps: aNumberLaps.

    ^ self new
        initializeWithShips: someShips
        board: aBoard
        dice: someDices
        laps: aNumberLaps
]

{ #category : 'initialize' }
Game class >> validateBoard: aBoard [
    [ aBoard validateAsBoard ]
        on: MessageNotUnderstood
        do: [ self error: 'Board must be an instance of Board' ]
]

{ #category : 'initialize' }
Game class >> validateDice: someDices [
    [ someDices validateAsDiceCup ]
        on: MessageNotUnderstood
        do: [ self error: 'Dice must be an instance of DiceCup' ]
]

{ #category : 'initialize' }
Game class >> validateLaps: aNumberLaps [
    (aNumberLaps isInteger and: [ aNumberLaps > 0 ]) ifFalse: [
        self error: 'Laps must be a positive integer' ]
]

{ #category : 'initialize' }
Game class >> validateMinimumShips: someShips [
    someShips size < 2 ifTrue: [
        self error: 'Need 2 space ships or more to initialize the game' ]
]

{ #category : 'initialize' }
Game class >> validateShips: someShips [
    (someShips isCollection) ifFalse: [
        ^ self error: 'Ships must be a collection of Spaceship instances' ].
    [ someShips do: [:each | each validateAsSpaceship ] ]
        on: MessageNotUnderstood
        do: [ self error: 'Ships must be a collection of Spaceship instances' ]
]

{ #category : 'process actions' }
Game >> activeCards [
    | collection |
    collection := OrderedCollection new.
    spaceShips do: [ :ship | collection addAll: ship activeCards ].
    ^ collection
]

{ #category : 'process actions' }
Game >> advanceTurn [
    turnManager advanceTurn
]

{ #category : 'process actions' }
Game >> allStatuses [
    ^ self spaceShips collect: [ :ship | self statusFor: ship ]
]

{ #category : 'accessing' }
Game >> board [
    ^ board
]

{ #category : 'validation' }
Game >> checkWinCondition [
    (self hasWonByLaps: self currentShip) ifFalse: [ ^ self ].
    state := GameFinished withWinner: self currentShip
]

{ #category : 'accessing' }
Game >> currentPlayerIndex [
    ^ self currentTurnIndex
]

{ #category : 'accessing' }
Game >> currentShip [
    ^ turnManager currentShip
]

{ #category : 'accessing' }
Game >> currentTurnIndex [
    ^ turnManager currentTurnIndex
]

{ #category : 'accessing' }
Game >> die [
    ^ dice
]

{ #category : 'process actions' }
Game >> ensureGameIsNotOver [
    self
        whenFinishedDo: [ :aWinner | self error: 'Game is already over' ]
        whenInProgressDo: [  ]
]

{ #category : 'process actions' }
Game >> handlePenaltyOrPassIfNeeded [
    | ship |
    ship := self currentShip.

    (self isPenalized: ship) ifTrue: [
        self reducePenaltyFor: ship.
        self advanceTurn.
        ^ true ].

    (self wantsToPassTurn: ship) ifTrue: [
        self markShipAsWantingToPassTurn: ship to: false.
        ship restoreFuel.
        self advanceTurn.
        ^ true ].

    ^ false
]

{ #category : 'testing' }
Game >> hasWonByLaps: aShip [
    ^ (self lapTrackerFor: aShip) hasWonWithTotalLaps: totalLaps
]

{ #category : 'initialization' }
Game >> initializeWithShips: someShips board: aBoard dice: someDices laps: aNumberLaps [
    self
        initializeBasicDataWithShips: someShips board: aBoard dice: someDices laps: aNumberLaps;
        initializeFuelForShips;
        initializeTurnManager;
        initializeShipStatuses;
        initializeTurnData.
    ^ self
]

{ #category : 'initialization' }
Game >> initializeBasicDataWithShips: someShips board: aBoard dice: someDices laps: aNumberLaps [
    spaceShips := someShips.
    board := aBoard.
    board registerShips: someShips.
    dice := someDices.
    totalLaps := aNumberLaps
]

{ #category : 'initialization' }
Game >> initializeFuelForShips [
    | initialFuel |
    initialFuel := dice maxRoll * 2.

    spaceShips do: [ :ship |
        ship maxFuel: initialFuel.
        ship fuel: initialFuel ]
]

{ #category : 'initialization' }
Game >> initializeTurnManager [
    turnManager := TurnManager withShips: spaceShips.
    wantsToPassTurn := Dictionary new
]

{ #category : 'initialization' }
Game >> initializeShipStatuses [
    shipStatuses := Dictionary new.
    spaceShips do: [ :ship |
        shipStatuses at: ship put: (ShipStatus
            for: ship
            position: 0
            laps: 0
            penalized: false).
        2 timesRepeat: [ ship addCard: board drawCard ] ]
]

{ #category : 'initialization' }
Game >> initializeTurnData [
    state := GameInProgress new.
    turnData := TurnData new.
    turnData initializeFuelHistoryForShips: spaceShips
]

{ #category : 'testing' }
Game >> isPenalized: aShip [
    ^ aShip isPenalized
]

{ #category : 'testing' }
Game >> lapTrackerFor: aShip [
    ^ shipStatuses at: aShip
]

{ #category : 'accessing' }
Game >> lastCardPlayed [
    ^ turnData lastCardPlayed
]

{ #category : 'accessing' }
Game >> lastCardPlayed: aCard [
    turnData lastCardPlayed: aCard
]

{ #category : 'accessing' }
Game >> lastEffectiveCard [
    ^ turnData lastEffectiveCard
]

{ #category : 'accessing' }
Game >> lastEffectiveCard: aCard [
    turnData lastEffectiveCard: aCard
]

{ #category : 'testing' }
Game >> markShipAsWantingToPassTurn: aShip to: aBoolean [
    wantsToPassTurn at: aShip put: aBoolean.
]

{ #category : 'process actions' }
Game >> modifyRoll: aNumber forShip: aShip [
    | value |
    value := aNumber.

    self activeCards do: [ :card |
        value := card modifyRoll: value forShip: aShip inGame: self ].

    ^ value
]

{ #category : 'process actions' }
Game >> passTurn [
    self recordFuelStartFor: self currentShip.
    self currentShip restoreFuel.
    self advanceTurn
]

{ #category : 'process actions' }
Game >> penalize: aShip forTurns: turns [
    aShip penalizeFor: turns.
    (self lapTrackerFor: aShip) penalized: true
]

{ #category : 'testing' }
Game >> penalizedTurnsRemainingFor: aShip [
    ^ aShip penaltyTurnsRemaining
]

{ #category : 'process actions' }
Game >> penalizeAndResetIfNoFuel: aShip [
    aShip fuel > 0 ifTrue: [ ^ self ].

    board moveShip: aShip to: 0.
    self penalize: aShip forTurns: 2
]

{ #category : 'accessing' }
Game >> penaltyShip [
    ^ spaceShips select: [ :ship | ship isPenalized ]
]

{ #category : 'process actions' }
Game >> playTurn [
    self recordFuelStartFor: self currentShip.
    self ensureGameIsNotOver.
    self handlePenaltyOrPassIfNeeded ifTrue: [ ^ self ].
    self rollAndMoveCurrentShip.

    self
        registerLapFor: self currentShip
        from: turnData lastPreviousPosition
        after: turnData lastSteps.

    self applyEffectOfCurrentCell.

    self checkWinCondition.
    self advanceTurn
]

{ #category : 'process actions' }
Game >> playUntilFinish [
    self whenFinishedDo: [ :aWinner | ]
        whenInProgressDo: [
            [ self whenFinishedDo: [ :aWinner | false ] whenInProgressDo: [ true ] ]
                whileTrue: [ self playTurn ].
        ].
]

{ #category : 'process actions' }
Game >> ranking [
    ^ self allStatuses sort: [ :a :b |
        | sameLaps samePosition |
        sameLaps := a lapCount = b lapCount.
        samePosition := a position = b position.

        sameLaps
            ifTrue: [
                samePosition
                    ifTrue: [ a ship name < b ship name ]
                    ifFalse: [ a position > b position ] ]
            ifFalse: [ a lapCount > b lapCount ] ]
]

{ #category : 'process actions' }
Game >> redoLastCardOn: aShip [
    turnData lastEffectiveCard playOn: aShip inGame: self
]

{ #category : 'testing' }
Game >> reducePenaltyFor: aShip [
    aShip reducePenalty.
    (self lapTrackerFor: aShip) penalized: aShip isPenalized.
    aShip restoreFuel
]

{ #category : 'testing' }
Game >> registerLapFor: aShip from: oldPosition after: someSteps [
    | cellCount status |
    cellCount := board cellCount.
    status := self lapTrackerFor: aShip.

    someSteps > 0
        ifTrue: [
            oldPosition + someSteps < cellCount ifTrue: [ ^ self ].
            status addLap ]
        ifFalse: [
            oldPosition + someSteps >= 0 ifTrue: [ ^ self ].
            status removeLap ]
]

{ #category : 'process actions' }
Game >> removeActiveCard: aCard [
    spaceShips do: [ :ship |
        ship activeCards remove: aCard ifAbsent: [  ] ]
]

{ #category : 'process actions' }
Game >> repeatLastEffectOn: aShip [
    | position effect |
    (turnData lastSteps = 0 and: [ turnData lastPreviousPosition = 0 ]) ifTrue: [ ^ self ].
    position := board
        determineNewPositionFrom: turnData lastPreviousPosition
        after: turnData lastSteps.
    effect := board effectAt: position.
    effect applyTo: aShip inBoard: board
]

{ #category : 'process actions' }
Game >> consumeFuel: aNumber forShip: aShip [
    | initialFuel deficit allies ally |
    initialFuel := aShip fuel.
    aShip decreaseFuelBy: aNumber.
    allies := aShip allies.

    initialFuel < aNumber ifFalse: [ ^ self ].

    deficit := aNumber - initialFuel.
    allies isEmpty ifTrue: [
        board moveShip: aShip to: 0.
        self penalize: aShip forTurns: 2.
        ^ self
    ].

    ally := allies first.
    ally decreaseFuelBy: deficit.
    self penalizeAndResetIfNoFuel: ally.

    self penalizeAndResetIfNoFuel: aShip.
]

{ #category : 'process actions' }
Game >> recordFuelStartFor: aShip [
    turnData recordFuelFor: aShip
]

{ #category : 'accessing' }
Game >> fuelHistoryFor: aShip [
    ^ turnData fuelHistoryFor: aShip
]

{ #category : 'accessing' }
Game >> fuelHistory: aDictionary [
    turnData fuelHistory: aDictionary
]

{ #category : 'process actions' }
Game >> rewardForMaxRollTo: aShip [
    self rewardForMaxRollTo: aShip withRoll: (1 to: 100) atRandom
]

{ #category : 'process actions' }
Game >> rewardForMaxRollTo: aShip withRoll: aNumber [
    aNumber <= 80
        ifTrue: [ aShip increaseMaxFuelBy: 1 ]
        ifFalse: [ aShip decreaseFuelBy: 1 ]
]

{ #category : 'process actions' }
Game >> rollAndMoveCurrentShip [
    | steps newPosition modified |
    turnData lastPreviousPosition: self currentShip position.
    steps := dice roll.
    steps = dice maxRoll ifTrue: [
        self rewardForMaxRollTo: self currentShip ].
    modified := self modifyRoll: steps forShip: self currentShip.
    modified >= 0
        ifTrue: [
            newPosition := board
                determineNewPositionFrom: turnData lastPreviousPosition
                after: modified.
            board moveShip: self currentShip to: newPosition ]
        ifFalse: [ board moveShip: self currentShip backward: modified abs ].
    turnData lastSteps: modified.
    self consumeFuel: modified abs forShip: self currentShip
]

{ #category : 'process actions' }
Game >> applyEffectOfCurrentCell [
    | beforePositions effect skipFuel |
    beforePositions := Dictionary new.
    board ships do: [ :ship | beforePositions at: ship put: (board positionOf: ship) ].

    effect := board effectAt: (board positionOf: self currentShip).
    skipFuel := effect class = AtomicBombEffect.

    board clearLastMoves.
    board applyEffectTo: self currentShip.

    board ships do: [ :ship |
        | before diff |
        before := beforePositions at: ship.
        diff := board lastMoveFor: ship.
        diff = 0 ifTrue: [ diff := (board positionOf: ship) - before ].
        diff ~= 0 ifTrue: [
            skipFuel ifFalse: [ self consumeFuel: diff abs forShip: ship ].
            self registerLapFor: ship from: before after: diff
        ]
    ]
]

{ #category : 'accessing' }
Game >> spaceShips [
    ^ spaceShips asOrderedCollection
]

{ #category : 'process actions' }
Game >> spaceshipPositions [
    ^ spaceShips collect: [ :ship | ShipPosition for: ship ]
]

{ #category : 'testing' }
Game >> stateOf: aShip [
    ^ aShip state
]

{ #category : 'process actions' }
Game >> statusFor: aShip [
    | status |
    status := self lapTrackerFor: aShip.

    status position: (board positionOf: aShip).
    status penalized: (self isPenalized: aShip).
    ^ status
]

{ #category : 'validation' }
Game >> validateIsCurrentPlayer: aSpaceship [
    self currentShip = aSpaceship ifFalse: [
        self error: 'It is not the turn of this spaceship' ]
]

{ #category : 'process actions' }
Game >> wantsToPassTurn: aShip [
    ^ wantsToPassTurn at: aShip ifAbsent: [ false ]
]

{ #category : 'testing' }
Game >> whenFinishedDo: finishedBlock whenInProgressDo: inProgressBlock [
    ^ state
        whenFinishedDo: finishedBlock
        whenInProgressDo: inProgressBlock
]

{ #category : 'accessing' }
Game >> winner [
    ^ state whenFinishedDo: [ :w | w ] whenInProgressDo: [ NullSpaceship new ]
]
