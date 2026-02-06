Class {
    #name : 'GameTestBuilder',
    #superclass : 'Object',
    #instVars : [
        'shipNames',
        'ships',
        'boardFactory',
        'boardConfigurators',
        'diceFactory',
        'laps'
    ],
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'initialization' }
GameTestBuilder >> initialize [
    shipNames := #('Alpha' 'Beta').
    boardFactory := [ Board of: 10 andWormholeAt: #() ].
    boardConfigurators := OrderedCollection new.
    diceFactory := [ DiceCup with: { Die withSides: 1 } ].
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
    ^ self configureBoardWith: [ :board | | ship |
        ship := board ships detect: [ :s | s name = aName ] ifNone: [ 
            ship := Spaceship withName: aName.
            board registerShips: { ship }.
            ship ].
        ship moveTo: aPosition ]
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
    theShips := ships ifNil: [ shipNames collect: [ :each | Spaceship withName: each ] ].
    board := boardFactory value.
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
