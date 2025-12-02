Class {
    #name : 'GameFinishedTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
GameFinishedTest >> testWhenFinishedDoReturnsFinishedBlockResult [
    | winner state result inProgressCalled |
    winner := Spaceship withName: 'Victor'.
    state := GameFinished withWinner: winner.
    inProgressCalled := false.

    result := state
        whenFinishedDo: [ :ship |
            self assert: ship equals: winner.
            'completed' ]
        whenInProgressDo: [ inProgressCalled := true ].

    self assert: result equals: 'completed'.
    self deny: inProgressCalled.
]

{ #category : 'tests' }
GameFinishedTest >> testWinnerAccessorExposesStoredShip [
    | winner state |
    winner := Spaceship withName: 'Champion'.
    state := GameFinished withWinner: winner.

    self assert: state winner equals: winner.
]
