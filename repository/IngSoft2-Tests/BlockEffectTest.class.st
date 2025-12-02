Class {
    #name : 'BlockEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
BlockEffectTest >> testOnCreatesEffectThatRunsAction [
    | effect ship board |
    effect := BlockEffect on: [ :aShip :aBoard | aBoard moveShip: aShip forward: 2 ].
    ship := Spaceship withName: 'Runner'.
    board := Board of: 5 andWormholeAt: {}.
    board registerShips: { ship }.
    ship moveTo: 1.

    effect applyEffectTo: ship inBoard: board.

    self assert: ship position equals: 3.
]

{ #category : 'tests' }
BlockEffectTest >> testOnRequiresBlockClosure [
    self
        should: [ BlockEffect on: 'not a block' ]
        raise: Error
        withMessageText: 'Block effect action must be a block that takes two arguments'.
]

{ #category : 'tests' }
BlockEffectTest >> testOnRequiresBlockWithTwoArguments [
    self
        should: [ BlockEffect on: [ :ship | ship moveForward: 1 ] ]
        raise: Error
        withMessageText: 'Block effect action must be a block that takes two arguments'.
]
