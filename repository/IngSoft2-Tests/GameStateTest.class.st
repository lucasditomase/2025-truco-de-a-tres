Class {
    #name : 'GameStateTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
GameStateTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
GameStateTest >> testGameStartsInProgress [
    | scenario game |
    scenario := self builder
        withShipNames: #('Voyager' 'Explorer');
        boardWithCells: 4;
        diceWithSides: 1;
        build.
    game := scenario game.

    game
        whenFinishedDo: [ self fail: 'Expected game to remain in progress' ]
        whenInProgressDo: [ self assert: scenario currentShipName equals: 'Voyager' ]
]

{ #category : 'tests' }
GameStateTest >> testGameTransitionsToFinishedAndExposesWinner [
    | scenario game |
    scenario := self builder
        withShipNames: #('Winner' 'RunnerUp');
        boardWithCells: 2;
        diceWithSides: 1;
        build.
    scenario playTurns: 3.
    game := scenario game.

    game
        whenFinishedDo: [ :winner | self assert: winner name equals: 'Winner' ]
        whenInProgressDo: [ self fail: 'Expected the game to be finished' ].
    self assert: game winner name equals: 'Winner'
]
