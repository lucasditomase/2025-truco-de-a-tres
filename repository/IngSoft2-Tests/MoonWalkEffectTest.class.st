Class {
    #name : 'MoonWalkEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
MoonWalkEffectTest >> testApplyToDoesNothing [
    | effect ship originalPosition |

    effect := MoonWalkEffect new.
    ship := Spaceship withName: 'TestShip'.

    originalPosition := ship position.
    effect applyTo: ship.

    self assert: ship position equals: originalPosition.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testApplyToInContextMovesOthersBack [
    | effect ship1 ship2 ship3 allShips |

    effect := MoonWalkEffect new.

    ship1 := Spaceship withName: 'TargetShip'.
    ship2 := Spaceship withName: 'Ship2'.
    ship3 := Spaceship withName: 'Ship3'.

    ship1 moveTo: 5.
    ship2 moveTo: 5.
    ship3 moveTo: 5.

    allShips := { ship1. ship2. ship3 }.

    effect applyTo: ship1 inContextOf: allShips.

    self assert: ship1 position equals: 5.
    self assert: ship2 position equals: 3.
    self assert: ship3 position equals: 3.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testApplyToInContextWithCustomSteps [
    | effect ship1 ship2 allShips |

    effect := MoonWalkEffect withSteps: 4.

    ship1 := Spaceship withName: 'Target'.
    ship2 := Spaceship withName: 'Other'.

    ship1 moveTo: 6.
    ship2 moveTo: 6.

    allShips := { ship1. ship2 }.

    effect applyTo: ship1 inContextOf: allShips.

    self assert: ship1 position equals: 6.
    self assert: ship2 position equals: 2.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testApplyEffectToReturnsSelf [
    | effect board ship result |
    effect := MoonWalkEffect new.
    board := Board of: 5 andWormholeAt: {}.
    ship := Spaceship withName: 'S'.
    board registerShips: { ship }.
    ship moveTo: 1.
    result := effect applyEffectTo: ship inBoard: board.
    self assert: result equals: effect.
    self assert: ship position equals: 1.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testStepsAccessorWorks [
    | effect |
    effect := MoonWalkEffect withSteps: 5.
    self assert: effect steps equals: 5.
    effect steps: 3.
    self assert: effect steps equals: 3.
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
