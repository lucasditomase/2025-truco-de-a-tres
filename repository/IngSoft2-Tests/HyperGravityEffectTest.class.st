Class {
    #name : 'HyperGravityEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
HyperGravityEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'asserting' }
HyperGravityEffectTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]

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
    | scenario board ship effect |

    scenario := (self builder boardWithCells: 10) build.
    board := scenario game board.
    ship := scenario shipNamed: 'Alpha'.
    board moveShip: ship to: 5.

    effect := HyperGravityEffect new.
    effect applyTo: ship.

    self assert: ship position equals: 5.
]

{ #category : 'tests' }
HyperGravityEffectTest >> testRequiredRollMustBePositiveInteger [
    | effect |
    effect := HyperGravityEffect new.
    self
        should: [ effect requiredRoll: 0 ]
        raise: Error
        withMessageText: 'Required roll must be a positive integer'.
    self
        should: [ effect requiredRoll: -1 ]
        raise: Error
        withMessageText: 'Required roll must be a positive integer'.
    effect requiredRoll: 7.
    self assert: effect requiredRoll equals: 7.
]
