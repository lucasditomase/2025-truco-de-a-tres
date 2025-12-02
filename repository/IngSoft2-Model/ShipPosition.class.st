Class {
    #name : 'ShipPosition',
    #superclass : 'Object',
    #instVars : [
        'ship',
        'position'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
ShipPosition class >> for: aShip [
    ^ self ship: (self ensureShipFrom: aShip) position: aShip position
]

{ #category : 'initialization' }
ShipPosition class >> ship: aShip position: aPosition [
    ^ self new initializeWithShip: (self ensureShipFrom: aShip) position: (self ensurePositionFrom: aPosition)
]

{ #category : 'validation' }
ShipPosition class >> ensurePositionFrom: aPosition [
    (aPosition isInteger and: [ aPosition >= 0 ]) ifFalse: [
        self error: 'Position must be a non-negative integer'
    ].
    ^ aPosition
]

{ #category : 'validation' }
ShipPosition class >> ensureShipFrom: aShip [
    ^ Spaceship ensureSpaceship: aShip errorMessage: 'Ship must be a Spaceship instance'
]

{ #category : 'accessing' }
ShipPosition >> initializeWithShip: aShip position: aPosition [
    ship := self class ensureShipFrom: aShip.
    position := self class ensurePositionFrom: aPosition.
    ^ self
]

{ #category : 'testing' }
ShipPosition >> isGreaterThan: anotherShipPosition [
    ^ position > anotherShipPosition position
]

{ #category : 'testing' }
ShipPosition >> isLessThan: anotherShipPosition [
    ^ position < anotherShipPosition position
]

{ #category : 'accessing' }
ShipPosition >> position [
    ^ position
]

{ #category : 'accessing' }
ShipPosition >> ship [
    ^ ship
]

