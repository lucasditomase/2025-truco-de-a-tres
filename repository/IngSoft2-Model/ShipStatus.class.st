Class {
    #name : 'ShipStatus',
    #superclass : 'Object',
    #instVars : [
        'ship',
        'position',
        'lapCount',
        'penalized',
        'fuel'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
ShipStatus class >> for: aShip position: aPosition laps: aLapCount penalized: isPenalized fuel: aFuelAmount [
    ^ self new
        initializeWith: (self ensureShipFrom: aShip)
        position: (self ensurePositionFrom: aPosition)
        laps: (self ensureLapCountFrom: aLapCount)
        penalized: (self ensurePenaltyFlagFrom: isPenalized)
        fuel: (self ensureFuelFrom: aFuelAmount)
]

{ #category : 'validation' }
ShipStatus class >> ensureLapCountFrom: aLapCount [
    (aLapCount isInteger and: [ aLapCount >= 0 ]) ifFalse: [
        self error: 'Lap count must be a non-negative integer'
    ].
    ^ aLapCount
]

{ #category : 'validation' }
ShipStatus class >> ensurePenaltyFlagFrom: aFlag [
    ^ aFlag asPenaltyFlagWithMessage: self invalidPenaltyFlagMessage
]

{ #category : 'validation' }
ShipStatus class >> ensurePositionFrom: aPosition [
    (aPosition isInteger and: [ aPosition >= 0 ]) ifFalse: [
        self error: 'Position must be a non-negative integer'
    ].
    ^ aPosition
]

{ #category : 'validation' }
ShipStatus class >> ensureShipFrom: aShip [
    ^ Spaceship ensureSpaceship: aShip errorMessage: self invalidShipMessage
]

{ #category : 'validation' }
ShipStatus class >> ensureFuelFrom: aFuelAmount [
    (aFuelAmount isInteger and: [ aFuelAmount >= 0 ]) ifFalse: [
        self error: 'Fuel must be a non-negative integer'
    ].
    ^ aFuelAmount
]

{ #category : 'validation' }
ShipStatus class >> ensureStatus: aStatus errorMessage: errorMessage [
    ^ aStatus asShipStatusWithMessage: errorMessage
]

{ #category : 'validation' }
ShipStatus class >> invalidPenaltyFlagMessage [
    ^ 'Penalized flag must be a Boolean'
]

{ #category : 'validation' }
ShipStatus class >> invalidShipMessage [
    ^ 'Ship must be a Spaceship instance'
]

{ #category : 'updating' }
ShipStatus >> addLap [
    lapCount := lapCount + 1
]

{ #category : 'methods' }
ShipStatus >> removeLap [
    lapCount := (lapCount - 1) max: 0
]

{ #category : 'accessing' }
ShipStatus >> hasWonWithTotalLaps: aNumber [
    ^ lapCount >= aNumber
]

{ #category : 'initialization' }
ShipStatus >> initializeWith: aShip position: aPosition laps: aLapCount penalized: isPenalized fuel: aFuelAmount [
    ship := self class ensureShipFrom: aShip.
    position := self class ensurePositionFrom: aPosition.
    lapCount := self class ensureLapCountFrom: aLapCount.
    penalized := self class ensurePenaltyFlagFrom: isPenalized.
    fuel := self class ensureFuelFrom: aFuelAmount
]

{ #category : 'accessing' }
ShipStatus >> isPenalized [
    ^ penalized
]

{ #category : 'accessing' }
ShipStatus >> lapCount [
    ^ lapCount
]

{ #category : 'accessing' }
ShipStatus >> penalized: aBoolean [
    penalized := aBoolean
]

{ #category : 'accessing' }
ShipStatus >> fuel [
    ^ fuel
]

{ #category : 'accessing' }
ShipStatus >> fuel: aFuelAmount [
    fuel := aFuelAmount
]

{ #category : 'accessing' }
ShipStatus >> position [
    ^ position
]

{ #category : 'accessing' }
ShipStatus >> position: aPosition [
    position := aPosition
]

{ #category : 'accessing' }
ShipStatus >> ship [
    ^ ship
]

{ #category : 'converting' }
ShipStatus >> asShipStatusWithMessage: errorMessage [
    ^ self
]
