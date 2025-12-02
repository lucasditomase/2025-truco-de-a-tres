Class {
    #name : 'GameInitializationTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
GameInitializationTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ].
]

{ #category : 'support' }
GameInitializationTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
GameInitializationTest >> shipsNamed: someNames [
    ^ someNames collect: [ :each | Spaceship withName: each ]
]

{ #category : 'tests' }
GameInitializationTest >> testGameStartsInProgressWithValidConfiguration [
    | scenario game |
    scenario := self builder
        withShipNames: #('First' 'Second');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.

    game
        whenFinishedDo: [ self fail: 'Expected game to be in progress' ]
        whenInProgressDo: [
            self assert: scenario currentShipName equals: 'First'.
            self assert: game class equals: Game ]
]

{ #category : 'tests' }
GameInitializationTest >> testSecondShipCannotPlayBeforeFirstTurn [
    | scenario game secondShip |
    scenario := self builder
        withShipNames: #('First' 'Second');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    secondShip := scenario shipNamed: 'Second'.

    self
        should: [ game validateIsCurrentPlayer: secondShip ]
        raise: Error
        withMessageText: 'It is not the turn of this spaceship'
]

{ #category : 'tests' }
GameInitializationTest >> testPreviousShipCannotPlayAgainAfterAdvancingTurn [
    | scenario game firstShip |
    scenario := self builder
        withShipNames: #('Ship Num1' 'Ship Num2');
        boardWithCells: 6;
        diceWithSides: 1;
        build.
    game := scenario game.
    firstShip := scenario shipNamed: 'Ship Num1'.

    game playTurn.

    self
        should: [ game validateIsCurrentPlayer: firstShip ]
        raise: Error
        withMessageText: 'It is not the turn of this spaceship'
]

{ #category : 'tests' }
GameInitializationTest >> testGameCreationRequiresAtLeastTwoShips [
    | dice board |
    dice := DiceCup with: { Die withSides: 1 }.
    board := Board of: 5 andWormholeAt: #().

    self
        should: [
            Game
                startWithShips: { Spaceship withName: 'Solo' }
                board: board
                dice: dice
                laps: 1 ]
        raise: Error
        withMessageText: 'Need 2 space ships or more to initialize the game'
]

{ #category : 'tests' }
GameInitializationTest >> testGameCreationRequiresSpaceshipInstances [
    | board dice invalidShips |
    board := Board of: 5 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.
    invalidShips := { 'NotAShip'. 'ThisOneToo' } asOrderedCollection.

    self
        should: [
            Game
                startWithShips: invalidShips
                board: board
                dice: dice
                laps: 1 ]
        raise: Error
        withMessageText: 'Ships must be a collection of Spaceship instances'
]

{ #category : 'tests' }
GameInitializationTest >> testGameCreationFailsWithInvalidBoardInstance [
    | ships dice invalidBoard |
    ships := self shipsNamed: #('Ship Num1' 'Ship Num2').
    dice := DiceCup with: { Die withSides: 1 }.
    invalidBoard := 'NotABoard'.

    self
        should: [
            Game
                startWithShips: ships
                board: invalidBoard
                dice: dice
                laps: 1 ]
        raise: Error
        withMessageText: 'Board must be an instance of Board'
]

{ #category : 'tests' }
GameInitializationTest >> testGameCreationFailsWithInvalidDiceInstance [
    | ships board invalidDice |
    ships := self shipsNamed: #('Ship Num1' 'Ship Num2').
    board := Board of: 10 andWormholeAt: #().
    invalidDice := 'NotADiceCup'.

    self
        should: [
            Game
                startWithShips: ships
                board: board
                dice: invalidDice
                laps: 1 ]
        raise: Error
        withMessageText: 'Dice must be an instance of DiceCup'
]

{ #category : 'tests' }
GameInitializationTest >> testGameCreationFailsWithInvalidLapsValue [
    | ships dice board |
    ships := self shipsNamed: #('Ship Num1' 'Ship Num2').
    dice := DiceCup with: { Die withSides: 1 }.
    board := Board of: 10 andWormholeAt: #().

    self
        should: [
            Game
                startWithShips: ships
                board: board
                dice: dice
                laps: 0 ]
        raise: Error
        withMessageText: 'Laps must be a positive integer'
]

{ #category : 'tests' }
GameInitializationTest >> testGameCreationFailsWithSingleShipCollection [
    | board dice singleShip |
    board := Board of: 10 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.
    singleShip := { Spaceship withName: 'OnlyOne' } asOrderedCollection.

    self
        should: [
            Game
                startWithShips: singleShip
                board: board
                dice: dice
                laps: 1 ]
        raise: Error
        withMessageText: 'Need 2 space ships or more to initialize the game'
]
