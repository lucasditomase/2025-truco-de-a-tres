Class {
    #name : 'PermanentCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
PermanentCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage].
]

{ #category : 'helpers' }
PermanentCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
PermanentCardTest >> testActivateForRaisesError [
    | card |
    card := PermanentCard new.
    self should: [ card activateFor: (Spaceship withName: 'Pilot') inGame: nil ] raise: Error.
]

{ #category : 'tests' }
PermanentCardTest >> testPlayOnActivatesCardWhenCurrentPlayer [
    | scenario game ship1 card |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'One'.
    card := OverloadCard forShip: ship1.
    card playOn: ship1 inGame: game.
    self assert: (ship1 activeCards includes: card).
]

{ #category : 'tests' }
PermanentCardTest >> testPlayOnRaisesErrorIfGameFinished [
    | scenario game ship card |
    scenario := self builder
        withShipNames: #('First' 'Second');
        boardWithCells: 2;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'First'.
    game playUntilFinish.
    card := OverloadCard forShip: ship.
    ship addCard: card.
    self
        should: [ ship playCard: card inGame: game ]
        raise: Error
        withMessageText: 'Game is already over'.
]

{ #category : 'tests' }
PermanentCardTest >> testPlayOnRaisesErrorIfNotPlayersTurn [
    | scenario game ship card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Beta'.
    card := OverloadCard forShip: ship.
    self
        should: [ card playOn: ship inGame: game ]
        raise: Error
        withMessageText: 'Not your turn'.
]
