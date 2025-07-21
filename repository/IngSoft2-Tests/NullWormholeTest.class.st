Class {
    #name : 'NullWormholeTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests - instance' }
NullWormholeTest >> testHasEntryAtAlwaysReturnsFalse [
    self deny: (NullWormhole new hasEntryAt: 5).
]

{ #category : 'tests - instance' }
NullWormholeTest >> testExitFromReturnsSamePosition [
    | worm |
    worm := NullWormhole new.
    self assert: (worm exitFrom: 3) equals: 3.
]

{ #category : 'tests - instance' }
NullWormholeTest >> testExitFromInBoardReturnsSamePosition [
    | worm board |
    worm := NullWormhole new.
    board := Board of: 10 andWormholeAt: {}.
    self assert: (worm exitFrom: 4 inBoard: board) equals: 4.
]

{ #category : 'tests - instance' }
NullWormholeTest >> testReverseOnBoardReversesEffectAtPosition [
    | worm board |
    worm := NullWormhole new.
    board := Board of: 5 andWormholeAt: {}.
    board cells at: 2 put: NoEffect new.
    worm reverseOnBoard: board at: 2.
    self assert: (board cells at: 2) class equals: ReversedEffect.
]
