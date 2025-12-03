Class {
    #name : 'GameCoordinator',
    #superclass : 'Object',
    #instVars : [
        'turnManager',
        'fuelManager',
        'lapTracker',
        'penaltyPolicy'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
GameCoordinator class >> forBoard: aBoard withShips: someShips statuses: shipStatuses andDice: aDiceCup [
    
    
    
    ^ self new
        initializeForBoard: aBoard
        withShips: someShips
        statuses: shipStatuses
        andDice: aDiceCup
]

{ #category : 'initialization' }
GameCoordinator >> initializeForBoard: aBoard withShips: someShips statuses: shipStatuses andDice: aDiceCup [
    
    
    
    turnManager := TurnManager withShips: someShips.
    
    lapTracker := LapTracker
        forBoard: aBoard
        statuses: shipStatuses.
    
    penaltyPolicy := PenaltyPolicy
        withStatuses: shipStatuses
        restoreFuelWith: [ :ship | ship restoreFuel ].
    
    fuelManager := FuelManager
        forBoard: aBoard
        penalizeWith: [ :ship :turns | penaltyPolicy penalize: ship forTurns: turns ]
]

{ #category : 'turn management' }
GameCoordinator >> advanceTurn [
    
    turnManager advanceTurn
]

{ #category : 'turn management' }
GameCoordinator >> currentShip [
    
    ^ turnManager currentShip
]

{ #category : 'turn management' }
GameCoordinator >> currentTurnIndex [
    
    ^ turnManager currentTurnIndex
]

{ #category : 'fuel management' }
GameCoordinator >> consumeFuel: aNumber forShip: aShip [
    
    fuelManager consumeFuel: aNumber forShip: aShip
]

{ #category : 'fuel management' }
GameCoordinator >> consumeMovement: steps forShip: aShip [
    
    fuelManager consumeMovement: steps forShip: aShip
]

{ #category : 'fuel management' }
GameCoordinator >> penalizeIfDepleted: aShip [
    
    fuelManager penalizeIfDepleted: aShip
]

{ #category : 'lap management' }
GameCoordinator >> registerLapFor: aShip from: oldPosition after: someSteps [
    
    lapTracker registerLapFor: aShip from: oldPosition after: someSteps
]

{ #category : 'accessing' }
GameCoordinator >> lapTracker [
    
    ^ lapTracker
]

{ #category : 'penalty management' }
GameCoordinator >> penalize: aShip forTurns: turns [
    
    penaltyPolicy penalize: aShip forTurns: turns
]

{ #category : 'penalty management' }
GameCoordinator >> reducePenaltyFor: aShip [
    
    penaltyPolicy reducePenaltyFor: aShip
]
