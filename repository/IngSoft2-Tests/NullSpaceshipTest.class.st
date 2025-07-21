Class {
    #name : 'NullSpaceshipTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests - instance' }
NullSpaceshipTest >> testIsNilReturnsTrue [
    self assert: (NullSpaceship new isNil).
]

{ #category : 'tests - instance' }
NullSpaceshipTest >> testIsNullShipReturnsTrue [
    self assert: (NullSpaceship new isNullShip).
]

{ #category : 'tests - instance' }
NullSpaceshipTest >> testValidateAsSpaceshipReturnsSelf [
    | ship |
    ship := NullSpaceship new.
    self assert: (ship validateAsSpaceship) equals: ship.
]
