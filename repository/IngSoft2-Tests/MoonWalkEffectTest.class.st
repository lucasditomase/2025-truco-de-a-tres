Class {
    #name : 'MoonWalkEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
MoonWalkEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
MoonWalkEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
MoonWalkEffectTest >> testWithStepsRequiresPositiveInteger [
    self
        should: [ MoonWalkEffect withSteps: 0 ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Steps must be a positive integer' ].
    self
        should: [ MoonWalkEffect withSteps: 'two' ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Steps must be a positive integer' ].
]
