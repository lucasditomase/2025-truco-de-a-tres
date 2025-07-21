Class {
    #name : 'HyperGravityEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
HyperGravityEffectTest >> testAllowsEntryWithRollFalseWhenLow [
    | effect |

    effect := HyperGravityEffect new.
    effect requiredRoll: 6.

    self deny: (effect allowsEntryWithRoll: 5).
]

{ #category : 'tests' }
HyperGravityEffectTest >> testAllowsEntryWithRollTrueWhenEnough [
    | effect |

    effect := HyperGravityEffect new.
    effect requiredRoll: 3.

    self assert: (effect allowsEntryWithRoll: 5).
    self assert: (effect allowsEntryWithRoll: 3).
]

{ #category : 'tests' }
HyperGravityEffectTest >> testApplyEffectDoesNotMoveShip [
    | ship effect |

    ship := Spaceship withName: 'Heavy'.
    ship moveTo: 5.

    effect := HyperGravityEffect new.
    effect applyTo: ship.

    self assert: ship position equals: 5.
]

{ #category : 'tests' }
HyperGravityEffectTest >> testRequiredRollCannotExceedMaximum [
    | effect |
    effect := HyperGravityEffect new.
    self
        should: [ effect requiredRoll: 13 ]
        raise: Error
        withMessageText: 'Required roll cannot exceed dice maximum'.
]
