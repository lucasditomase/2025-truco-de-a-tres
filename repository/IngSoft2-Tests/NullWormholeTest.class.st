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
    board placeEffect: NoEffect new at: 2.
    worm reverseOnBoard: board at: 2.
    self assert: (board effectAt: 2) class equals: ReversedEffect.
]
