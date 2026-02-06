Class {
    #name : 'GameTestBuilder',
    #superclass : 'Object',
    #instVars : [
        'shipNames',
        'ships',
        'boardFactory',
        'boardConfigurators',
        'diceFactory',
        'shipPositions',
        'laps'
    ],
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'initialization' }
GameTestBuilder >> initialize [
    shipNames := OrderedCollection new.
    boardFactory := [ Board of: 10 andWormholeAt: #() ].
    boardConfigurators := OrderedCollection new.
    diceFactory := [ DiceCup with: { Die withSides: 1 } ].
    shipPositions := Dictionary new.
    laps := 1.
]

{ #category : 'instance creation' }
GameTestBuilder class >> withShipNames: aCollection [
    ^ self new withShipNames: aCollection
]

{ #category : 'configuration' }
GameTestBuilder >> withShipNames: aCollection [
    shipNames := aCollection.
    ^ self
]

{ #category : 'configuration' }
GameTestBuilder >> withShips: aCollection [
    ships := aCollection.
    ^ self
]

{ #category : 'configuration' }
GameTestBuilder >> laps: aNumber [
    laps := aNumber.
    ^ self
]

{ #category : 'configuration' }
GameTestBuilder >> withShipNamed: aName at: aPosition [
    (shipNames includes: aName) ifFalse: [ shipNames add: aName ].
    shipPositions at: aName put: aPosition.
    ^ self
]

{ #category : 'configuration' }
GameTestBuilder >> boardWithCells: aNumber [
    boardFactory := [ Board of: aNumber andWormholeAt: #() ].
    ^ self
]

{ #category : 'configuration' }
GameTestBuilder >> boardFactory: aBlock [
    boardFactory := aBlock.
    ^ self
]

{ #category : 'configuration' }
GameTestBuilder >> configureBoardWith: aBlock [
    boardConfigurators add: aBlock.
    ^ self
]

{ #category : 'configuration' }
GameTestBuilder >> diceWithSides: aNumber [
    diceFactory := [ DiceCup with: { Die withSides: aNumber } ].
    ^ self
]

{ #category : 'configuration' }
GameTestBuilder >> diceCup: aBlock [
    diceFactory := aBlock.
    ^ self
]

{ #category : 'configuration' }
GameTestBuilder >> withDice: aDie [
    diceFactory := [ DiceCup with: { aDie } ].
    ^ self
]

{ #category : 'instance creation' }
GameTestBuilder >> build [
    | theShips board dice game |
    theShips := ships ifNil: [ 
        shipNames ifEmpty: [ shipNames addAll: #('Alpha' 'Beta') ].
        shipNames collect: [ :each | Spaceship withName: each ] ].
    
    board := boardFactory value.
    board registerShips: theShips.
    
    shipPositions keysAndValuesDo: [ :name :pos |
        (theShips detect: [ :s | s name = name ]) moveTo: pos ].

    boardConfigurators do: [ :config | config value: board ].
    dice := diceFactory value.
    game := Game
        startWithShips: theShips
        board: board
        dice: dice
        laps: laps.
    ^ GameTestScenario withGame: game ships: theShips
]

{ #category : 'configuration' }
GameTestBuilder >> withCardDealer: aCallable [
    ^ self configureBoardWith: [ :board | board useCardDealer: aCallable ]
]

{ #category : 'configuration' }
GameTestBuilder >> withDeckCyclingThrough: cardClasses [
    ^ self configureBoardWith: [ :board | board useCardDealerCyclingThrough: cardClasses ]
]

{ #category : 'configuration' }
GameTestBuilder >> withEffect: anEffect at: aPosition [
    ^ self configureBoardWith: [ :board | board cells at: aPosition put: anEffect ]
]
