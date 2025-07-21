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

{ #category : 'tests' }
GameInitializationTest >> testValidateIsCurrentPlayerRaisesError [
    | ship1 ship2 board dice game |
    ship1 := Spaceship withName: 'First'.
    ship2 := Spaceship withName: 'Second'.
    board := Board of: 5 andWormholeAt: {  }.
    dice := DiceCup with: { (Die withSides: 6) }.

    game := Game
        startWithShips: {
            ship1.
            ship2 }
        board: board
        dice: dice
        laps: 1.

    self
        should: [ game validateIsCurrentPlayer: ship2 ]
        raise: Error
        withMessageText: 'It is not the turn of this spaceship'
]

{ #category : 'tests' }
GameInitializationTest >> testValidateMinimumSpaceShipsFailsWithOneShip [
    | dice board |
    dice := DiceCup with: { (Die withSides: 6) }.
    board := Board of: 5 andWormholeAt: {  }.

    self
        should: [
            Game
                startWithShips: { (Spaceship withName: 'Solo') }
                board: board
                dice: dice
                laps: 1 ]
        raise: Error
        withMessageText: 'Need 2 space ships or more to initialize the game'
]

{ #category : 'tests' }
GameInitializationTest >> testWhenAShipTriesToPlayOutOfTurnThenError [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dicesGame boardGame game |
    dice1 := Die withSides: 6.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 25 andWormholeAt: #(  ).

    game := Game
        startWithShips: spaceShipsGame
        board: boardGame
        dice: dicesGame
        laps: 1.

    game playTurn.

    self
        should: [ game validateIsCurrentPlayer: spaceShip1]
        raise: Error
        withMessageText: 'It is not the turn of this spaceship'
]

{ #category : 'tests' }
GameInitializationTest >> testWhenGameCorrectlyCreatedThenNotNil [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dice2 dicesGame boardGame game |

    dice1 := Die withSides: 1.
    dice2 := Die withSides: 6.
    dicesGame := DiceCup with: (OrderedCollection with: dice1 with: dice2).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 10 andWormholeAt: #(  ).

    game := Game
        startWithShips: spaceShipsGame
        board: boardGame
        dice: dicesGame
        laps: 1.

    self assert: game class equals: Game
]

{ #category : 'tests' }
GameInitializationTest >> testWhenGameCreatedWithInvalidBoardThenIsInvalid [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dice2 dicesGame invalidBoard |
    dice1 := Die withSides: 1.
    dice2 := Die withSides: 6.
    dicesGame := DiceCup with: (OrderedCollection with: dice1 with: dice2).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    invalidBoard := 'NotABoard'.

    self
        should: [
            Game
                startWithShips: spaceShipsGame
                board: invalidBoard
                dice: dicesGame
                laps: 1 ]
        raise: Error
        withMessageText: 'Board must be an instance of Board'
]

{ #category : 'tests' }
GameInitializationTest >> testWhenGameCreatedWithInvalidDiceThenIsInvalid [
    | spaceShip1 spaceShip2 spaceShipsGame invalidDice boardGame |
    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 10 andWormholeAt: #(  ).
    invalidDice := 'NotADiceCup'.

    self
        should: [
            Game
                startWithShips: spaceShipsGame
                board: boardGame
                dice: invalidDice
                laps: 1 ]
        raise: Error
        withMessageText: 'Dice must be an instance of DiceCup'
]

{ #category : 'tests' }
GameInitializationTest >> testWhenGameCreatedWithInvalidLapsThenIsInvalid [
    | spaceShip1 spaceShip2 spaceShipsGame dice1 dice2 dicesGame boardGame invalidLaps |

    dice1 := Die withSides: 1.
    dice2 := Die withSides: 6.
    dicesGame := DiceCup with: (OrderedCollection with: dice1 with: dice2).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShip2 := Spaceship withName: 'Ship Num2'.
    spaceShipsGame := OrderedCollection with: spaceShip1 with: spaceShip2.

    boardGame := Board of: 10 andWormholeAt: #().
    invalidLaps := -1.

    self
        should: [
            Game
                startWithShips: spaceShipsGame
                board: boardGame
                dice: dicesGame
                laps: invalidLaps ]
        raise: Error
        withMessageText: 'Laps must be a positive integer'.
]

{ #category : 'tests' }
GameInitializationTest >> testWhenGameCreatedWithInvalidShipsThenIsInvalid [
    | invalidShips dice1 dice2 dicesGame boardGame |
    dice1 := Die withSides: 1.
    dice2 := Die withSides: 6.
    dicesGame := DiceCup with: (OrderedCollection with: dice1 with: dice2).

    invalidShips := OrderedCollection with: 'NotAShip'.
    invalidShips add: 'ThisOneIsNotAShipEither'.

    boardGame := Board of: 10 andWormholeAt: #(  ).

    self
        should: [
            Game
                startWithShips: invalidShips
                board: boardGame
                dice: dicesGame
                laps: 1 ]
        raise: Error
        withMessageText: 'Ships must be a collection of Spaceship instances'
]

{ #category : 'tests' }
GameInitializationTest >> testWhenGameCreatedWithoutTwoOrMoreShipsThenIsInvalid [
    | spaceShip1 spaceShipsGame dice1 dice2 dicesGame boardGame |

    dice1 := Die withSides: 1.
    dice2 := Die withSides: 6.
    dicesGame := DiceCup with: (OrderedCollection with: dice1 with: dice2).

    spaceShip1 := Spaceship withName: 'Ship Num1'.
    spaceShipsGame := OrderedCollection with: spaceShip1.

    boardGame := Board of: 10 andWormholeAt: #(  ).

    self
        should: [
            Game
                startWithShips: spaceShipsGame
                board: boardGame
                dice: dicesGame
                laps: 1 ]
        raise: Error
        withMessageText: 'Need 2 space ships or more to initialize the game'
]