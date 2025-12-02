Class {
    #name : 'GameLapTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
GameLapTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
GameLapTest >> testShipAccumulatesMultipleLapsInSingleTurn [
    | scenario |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        laps: 10;
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(4 1 12) } ];
        build.

    scenario playTurns: 3.

    self assert: (scenario lapCountForShipNamed: 'Alpha') equals: 3.
]

{ #category : 'tests' }
GameLapTest >> testBackwardEffectRemovesSingleLapWhenCrossingStart [
    | scenario |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        laps: 5;
        configureBoardWith: [ :board |
            board cells
                at: 1
                put: (BlockEffect on: [ :ship :aBoard | aBoard moveShip: ship backward: 3 ]) ];
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(5 1 1) } ];
        build.

    scenario playTurns: 3.

    self assert: (scenario lapCountForShipNamed: 'Alpha') equals: 0.
]

{ #category : 'tests' }
GameLapTest >> testBackwardEffectCanRemoveMultipleLaps [
    | scenario |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        laps: 5;
        configureBoardWith: [ :board |
            board cells
                at: 2
                put: (BlockEffect on: [ :ship :aBoard | aBoard moveShip: ship backward: 11 ]) ];
        diceCup: [ DiceCup with: { DeterministicDie withValues: #(4 1 12 1 6) } ];
        build.

    scenario playTurns: 5.

    self assert: (scenario lapCountForShipNamed: 'Alpha') equals: 2.
]
