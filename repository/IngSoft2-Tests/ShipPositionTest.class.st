Class {
    #name : 'ShipPositionTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ShipPositionTest >> testForReturnsShipPosition [
    | ship shipPosition |

    ship := Spaceship withName: 'Runner'.
    ship moveTo: 7.
    shipPosition := ShipPosition for: ship.

    self assert: shipPosition ship equals: ship.
    self assert: shipPosition position equals: ship position.
]

{ #category : 'tests' }
ShipPositionTest >> testForRequiresSpaceshipInstance [
    self
        should: [ ShipPosition for: 'not a ship' ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Ship must be a Spaceship instance' ].
]

{ #category : 'tests' }
ShipPositionTest >> testShipPositionRequiresNonNegativeIntegerPosition [
    | ship |
    ship := Spaceship withName: 'Explorer'.
    self
        should: [ ShipPosition ship: ship position: -1 ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Position must be a non-negative integer' ].
]
