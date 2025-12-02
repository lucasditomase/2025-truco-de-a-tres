Class {
    #name : 'NullSpaceshipTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests - instance' }
NullSpaceshipTest >> testIsNullShipReturnsTrue [
    self assert: (NullSpaceship new isNullShip).
]
