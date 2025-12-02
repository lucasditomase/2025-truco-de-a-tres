Class {
    #name : 'ShipStatusTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ShipStatusTest >> testInitializationSetsValuesCorrectly [
    | ship status |

    ship := Spaceship withName: 'Voyager'.
    status := ShipStatus for: ship position: 5 laps: 2 penalized: true.

    self assert: status ship equals: ship.
    self assert: status position equals: 5.
    self assert: status lapCount equals: 2.
    self assert: status isPenalized.
]

{ #category : 'tests' }
ShipStatusTest >> testIsPenalizedReturnsFalse [
    | ship status |

    ship := Spaceship withName: 'Enterprise'.
    status := ShipStatus for: ship position: 0 laps: 0 penalized: false.

    self deny: status isPenalized.
]

{ #category : 'tests' }
ShipStatusTest >> testForRequiresSpaceshipInstance [
    self
        should: [ ShipStatus for: 'not a ship' position: 0 laps: 0 penalized: false ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Ship must be a Spaceship instance' ].
]

{ #category : 'tests' }
ShipStatusTest >> testForRequiresNonNegativeIntegerPosition [
    | ship |
    ship := Spaceship withName: 'Apollo'.
    self
        should: [ ShipStatus for: ship position: -1 laps: 0 penalized: false ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Position must be a non-negative integer' ].
]

{ #category : 'tests' }
ShipStatusTest >> testForRequiresNonNegativeIntegerLapCount [
    | ship |
    ship := Spaceship withName: 'Pegasus'.
    self
        should: [ ShipStatus for: ship position: 0 laps: -1 penalized: false ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Lap count must be a non-negative integer' ].
]

{ #category : 'tests' }
ShipStatusTest >> testForRequiresBooleanPenalizedFlag [
    | ship |
    ship := Spaceship withName: 'Discovery'.
    self
        should: [ ShipStatus for: ship position: 0 laps: 0 penalized: 'yes' ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Penalized flag must be a Boolean' ].
]
