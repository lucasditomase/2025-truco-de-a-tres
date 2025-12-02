Class {
    #name : 'GameTestScenario',
    #superclass : 'Object',
    #instVars : [
        'game',
        'ships',
        'shipsByName'
    ],
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'instance creation' }
GameTestScenario class >> withGame: aGame ships: shipCollection [
    ^ self new initializeWithGame: aGame ships: shipCollection
]

{ #category : 'initialization' }
GameTestScenario >> initializeWithGame: aGame ships: shipCollection [
    game := aGame.
    ships := shipCollection asOrderedCollection.
    shipsByName := Dictionary new.
    ships do: [ :ship | shipsByName at: ship name put: ship ].
    ^ self
]

{ #category : 'accessing' }
GameTestScenario >> game [
    ^ game
]

{ #category : 'accessing' }
GameTestScenario >> shipAt: anIndex [
    ^ ships at: anIndex
]

{ #category : 'accessing' }
GameTestScenario >> shipNamed: aName [
    ^ shipsByName at: aName ifAbsent: [
        self error: 'Ship named ', aName, ' was not registered in this scenario'
    ]
]

{ #category : 'accessing' }
GameTestScenario >> shipNames [
    ^ ships collect: #name
]

{ #category : 'accessing' }
GameTestScenario >> ships [
    ^ ships copy
]

{ #category : 'testing' }
GameTestScenario >> currentShipName [
    ^ game currentShip name
]

{ #category : 'controlling' }
GameTestScenario >> playTurns: aNumber [
    aNumber timesRepeat: [ game playTurn ].
    ^ self
]

{ #category : 'controlling' }
GameTestScenario >> playUntilFinish [
    game playUntilFinish.
    ^ self
]
