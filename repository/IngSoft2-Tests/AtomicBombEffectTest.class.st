Class {
    #name : 'AtomicBombEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
AtomicBombEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
AtomicBombEffectTest >> testApplyToDoesNothing [
    | scenario ship board effect |
    scenario := (self builder boardWithCells: 10) build.
    board := scenario game board.
    ship := scenario shipNamed: 'Alpha'.
    board moveShip: ship to: 5.

    effect := AtomicBombEffect new.
    effect applyTo: ship.

    self assert: ship position equals: 5
]

{ #category : 'tests' }
AtomicBombEffectTest >> testApplyToInContextResetsAllPositions [
    | scenario board alpha beta effect |
    scenario := (self builder boardWithCells: 10) build.
    board := scenario game board.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    board moveShip: alpha to: 5.
    board moveShip: beta to: 9.

    effect := AtomicBombEffect new.
    effect applyTo: alpha inContextOf: { alpha. beta } inBoard: board.

    self assert: alpha position equals: 0.
    self assert: beta position equals: 0
]
