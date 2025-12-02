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
        'turnData',
        'fuelManager',
        'lapTracker',
        'penaltyPolicy',
        'rankingService'
        ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialize' }
Game class >> startWithShips: someShips board: aBoard dice: someDices laps: aNumberLaps [
    | ensuredShips ensuredBoard ensuredDice ensuredLaps |

    ensuredShips := self ensureShipsFrom: someShips.
    ensuredBoard := self ensureBoardFrom: aBoard.
    ensuredDice := self ensureDiceCupFrom: someDices.
    ensuredLaps := self ensureLapCountFrom: aNumberLaps.

    ^ self new
        initializeWithShips: ensuredShips
        board: ensuredBoard
        dice: ensuredDice
        laps: ensuredLaps
]

{ #category : 'probabilities' }
Game class >> maxRollRewardIncreaseChance [
    ^ 80
]

{ #category : 'initialize' }
Game class >> validateBoard: aBoard [
    (aBoard isKindOf: Board) ifFalse: [
        self error: 'Board must be an instance of Board' ]
]

{ #category : 'validation' }
Game class >> ensureBoardFrom: aBoard [
    self validateBoard: aBoard.
    ^ aBoard
]

{ #category : 'initialize' }
Game class >> validateDice: someDices [
    (someDices isKindOf: DiceCup) ifFalse: [
        self error: 'Dice must be an instance of DiceCup' ]
]

{ #category : 'validation' }
Game class >> ensureDiceCupFrom: someDices [
    self validateDice: someDices.
    ^ someDices
]

{ #category : 'initialize' }
Game class >> validateLaps: aNumberLaps [
    (aNumberLaps isInteger and: [ aNumberLaps > 0 ]) ifFalse: [
        self error: 'Laps must be a positive integer' ]
]

{ #category : 'validation' }
Game class >> ensureLapCountFrom: aNumberLaps [
    self validateLaps: aNumberLaps.
    ^ aNumberLaps
]

{ #category : 'initialize' }
Game class >> validateMinimumShips: someShips [
    Spaceship ensureMinimumCountIn: someShips
]

{ #category : 'initialize' }
Game class >> validateShips: someShips [
    Spaceship ensureCollectionOfSpaceships: someShips
]

{ #category : 'validation' }
Game class >> ensureShipsFrom: someShips [
    self validateMinimumShips: someShips.
    self validateShips: someShips.
    ^ someShips asOrderedCollection
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
        penaltyPolicy reducePenaltyFor: ship.
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
        initializeHyperGravityRequirements;
        initializeTurnManager;
        initializeShipStatuses;
        initializeManagers;
        initializeTurnData.
    ^ self
]

{ #category : 'initialization' }
Game >> initializeManagers [
    lapTracker := LapTracker
        forBoard: board
        statuses: shipStatuses.
    penaltyPolicy := PenaltyPolicy
        withStatuses: shipStatuses
        restoreFuelWith: [ :ship | ship restoreFuel ].
    fuelManager := FuelManager
        forBoard: board
        penalizeWith: [ :ship :turns | penaltyPolicy penalize: ship forTurns: turns ].
    rankingService := RankingService new
]

{ #category : 'initialization' }
Game >> initializeHyperGravityRequirements [
    board configureHyperGravityRequirementsWithMaxRoll: dice maxRoll
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
    penaltyPolicy penalize: aShip forTurns: turns
]

{ #category : 'process actions' }
Game >> penalizeAndResetIfNoFuel: aShip [
    fuelManager penalizeIfDepleted: aShip
]

{ #category : 'testing' }
Game >> penalizedTurnsRemainingFor: aShip [
    ^ aShip penaltyTurnsRemaining
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
    [ self whenFinishedDo: [ :winner | false ] whenInProgressDo: [ true ] ]
        whileTrue: [ self playTurn ]
]

{ #category : 'process actions' }
Game >> ranking [
    ^ rankingService rankingFor: self allStatuses
]

{ #category : 'process actions' }
Game >> redoLastCardOn: aShip [
    turnData lastEffectiveCard playOn: aShip inGame: self
]

{ #category : 'testing' }
Game >> reducePenaltyFor: aShip [
    penaltyPolicy reducePenaltyFor: aShip
]

{ #category : 'testing' }
Game >> registerLapFor: aShip from: oldPosition after: someSteps [
    lapTracker registerLapFor: aShip from: oldPosition after: someSteps
]

{ #category : 'process actions' }
Game >> removeActiveCard: aCard [
    spaceShips do: [ :ship |
        ship activeCards remove: aCard ifAbsent: [  ] ]
]

{ #category : 'process actions' }
Game >> repeatLastEffectOn: aShip [
    | position effect card skipFuel |
    turnData lastEffectWasCard ifTrue: [
        card := turnData lastEffectiveCard.
        card class = NullCard ifTrue: [ ^ self ].
        card playOn: aShip inGame: self.
        ^ self
    ].
    (turnData lastSteps = 0 and: [ turnData lastPreviousPosition = 0 ]) ifTrue: [ ^ self ].
    position := board
        determineNewPositionFrom: turnData lastPreviousPosition
        after: turnData lastSteps.
    effect := board effectAt: position.
    skipFuel := effect consumesFuel not.
    self
        applyEffectSkippingFuel: skipFuel
        during: [ effect applyTo: aShip inBoard: board ]
]

{ #category : 'process actions' }
Game >> consumeFuel: aNumber forShip: aShip [
    fuelManager consumeFuel: aNumber forShip: aShip
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
    aNumber <= self class maxRollRewardIncreaseChance
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
    newPosition := board
        determineNewPositionFrom: turnData lastPreviousPosition
        after: modified.
    board moveShip: self currentShip to: newPosition.
    turnData lastSteps: modified.
    fuelManager consumeMovement: modified forShip: self currentShip
]

{ #category : 'process actions' }
Game >> applyEffectOfCurrentCell [
    | effect skipFuel |
    effect := board effectAt: (board positionOf: self currentShip).
    skipFuel := effect consumesFuel not.
    self
        applyEffectSkippingFuel: skipFuel
        during: [ board applyEffectTo: self currentShip ]
]

{ #category : 'process actions' }
Game >> applyEffectSkippingFuel: skipFuel during: effectBlock [
    | movementRecords movementOccurred |
    movementRecords := board recordMovesDuring: effectBlock.
    movementOccurred := false.
    movementRecords keysAndValuesDo: [ :ship :report |
        | start delta |
        start := report startPosition.
        delta := report delta.
        delta ~= 0 ifTrue: [
            movementOccurred := true.
            skipFuel ifFalse: [ fuelManager consumeMovement: delta forShip: ship ].
            lapTracker registerLapFor: ship from: start after: delta
        ]
    ].
    movementOccurred ifTrue: [ turnData lastEffectWasCard: false ]
]

{ #category : 'accessing' }
Game >> spaceShips [
    ^ spaceShips asOrderedCollection
]

{ #category : 'process actions' }
Game >> spaceshipPositions [
    ^ spaceShips collect: [ :ship |
        | tracker |
        tracker := self lapTrackerFor: ship.
        ShipStatus
            for: ship
            position: ship position
            laps: tracker lapCount
            penalized: tracker isPenalized ]
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
