Class {
    #name : 'PenaltyPolicy',
    #superclass : 'Object',
    #instVars : [
        'shipStatuses',
        'fuelRestorer'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
PenaltyPolicy class >> withStatuses: aDictionary restoreFuelWith: aBlock [
    ^ self new
        initializeWithStatuses: (self ensureStatusesFrom: aDictionary)
        restoreFuelWith: (self ensureFuelRestorerFrom: aBlock)
]

{ #category : 'validation' }
PenaltyPolicy class >> ensureFuelRestorerFrom: aBlock [
    ^ aBlock asFuelRestorer
]

{ #category : 'validation' }
PenaltyPolicy class >> ensureStatusesFrom: aDictionary [
    | statuses |
    statuses := aDictionary asShipStatusRegistry.
    statuses valuesDo: [ :each |
        ShipStatus ensureStatus: each errorMessage: self invalidStatusValueMessage
    ].
    ^ statuses
]

{ #category : 'validation' }
PenaltyPolicy class >> invalidStatusRegistryMessage [
    ^ 'Ship statuses must be stored in a Dictionary'
]

{ #category : 'validation' }
PenaltyPolicy class >> invalidStatusValueMessage [
    ^ 'Ship statuses must contain ShipStatus values'
]

{ #category : 'validation' }
PenaltyPolicy class >> invalidFuelRestorerMessage [
    ^ 'Fuel restorer must be a block'
]

{ #category : 'initialization' }
PenaltyPolicy >> initializeWithStatuses: aDictionary restoreFuelWith: aBlock [
    shipStatuses := self class ensureStatusesFrom: aDictionary.
    fuelRestorer := self class ensureFuelRestorerFrom: aBlock.
    ^ self
]

{ #category : 'penalties' }
PenaltyPolicy >> penalize: aShip forTurns: turns [
    aShip penalizeFor: turns.
    (self statusFor: aShip) penalized: true
]

{ #category : 'penalties' }
PenaltyPolicy >> reducePenaltyFor: aShip [
    aShip reducePenalty.
    (self statusFor: aShip) penalized: aShip isPenalized.
    fuelRestorer value: aShip
]

{ #category : 'private' }
PenaltyPolicy >> statusFor: aShip [
    ^ shipStatuses at: aShip
]
