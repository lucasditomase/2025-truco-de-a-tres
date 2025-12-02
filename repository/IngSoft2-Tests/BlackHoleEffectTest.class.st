Class {
    #name : 'BlackHoleEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
BlackHoleEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
BlackHoleEffectTest >> testApplyToDoesNotGoBelowZero [
    | scenario board ship effect |
    scenario := (self builder boardWithCells: 10) build.
    board := scenario game board.
    ship := scenario shipNamed: 'Alpha'.
    board moveShip: ship to: 3.

    effect := BlackHoleEffect new.
    effect applyTo: ship.

    self assert: ship position equals: 0
]

{ #category : 'tests' }
BlackHoleEffectTest >> testApplyToMovesShipBackBy4 [
    | scenario board ship effect |
    scenario := (self builder boardWithCells: 10) build.
    board := scenario game board.
    ship := scenario shipNamed: 'Alpha'.
    board moveShip: ship to: 6.

    effect := BlackHoleEffect new.
    effect applyTo: ship.

    self assert: ship position equals: 2
]
