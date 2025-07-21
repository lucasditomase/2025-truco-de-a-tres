Class {
    #name : 'ReversedWormholeTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests - instance' }
ReversedWormholeTest >> testHasEntryAtReturnsTrueForEntryAndExit [
    | worm |
    worm := ReversedWormhole from: 2 to: 7.
    self assert: (worm hasEntryAt: 2).
    self assert: (worm hasEntryAt: 7).
    self deny: (worm hasEntryAt: 5).
]

{ #category : 'tests - instance' }
ReversedWormholeTest >> testExitFromReturnsOppositePositions [
    | worm |
    worm := ReversedWormhole from: 1 to: 4.
    self assert: (worm exitFrom: 1) equals: 4.
    self assert: (worm exitFrom: 4) equals: 1.
]

{ #category : 'tests - instance' }
ReversedWormholeTest >> testExitFromRaisesErrorWhenInvalid [
    | worm |
    worm := ReversedWormhole from: 1 to: 4.
    self should: [ worm exitFrom: 3 ] raise: Error.
]

{ #category : 'tests - instance' }
ReversedWormholeTest >> testExitFromInBoardWrapsAroundBoard [
    | worm board |
    worm := ReversedWormhole from: 2 to: 7.
    board := Board of: 10 andWormholeAt: {}.
    self assert: (worm exitFrom: 2 inBoard: board) equals: (7 - board cellCount).
    self assert: (worm exitFrom: 7 inBoard: board) equals: (2 + board cellCount).
]

{ #category : 'tests - instance' }
ReversedWormholeTest >> testReversedReturnsNormalWormhole [
    | worm reversed |
    worm := ReversedWormhole from: 3 to: 8.
    reversed := worm reversed.
    self assert: reversed class equals: Wormhole.
    self assert: reversed entry equals: 3.
    self assert: reversed exit equals: 8.
]
