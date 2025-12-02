Class {
    #name : 'TimeMachineCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'helpers' }
TimeMachineCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'asserting' }
TimeMachineCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error | self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
TimeMachineCardTest >> testApplyEffectRestoresFuel [
    | scenario game ship1 ship2 card |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'One'.
    ship2 := scenario shipNamed: 'Two'.
    game fuelHistory: (Dictionary new
        at: ship1 put: (OrderedCollection with: 20 with: 10);
        at: ship2 put: (OrderedCollection with: 0 with: 0);
        yourself).
    ship1 fuel: 2.
    card := TimeMachineCard new.

    card applyEffectTo: ship1 inGame: game.

    self assert: ship1 fuel equals: 20.
]

{ #category : 'tests' }
TimeMachineCardTest >> testApplyEffectWithAlliesRestoresAll [
    | scenario game ship1 ship2 card ally |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'One'.
    ship2 := scenario shipNamed: 'Two'.
    ally := AllyCard withAlly: ship2.
    ally activateFor: ship1 inGame: game.
    game fuelHistory: (Dictionary new
        at: ship1 put: (OrderedCollection with: 20 with: 10);
        at: ship2 put: (OrderedCollection with: 15 with: 5);
        yourself).
    ship1 fuel: 2.
    ship2 fuel: 1.
    card := TimeMachineCard new.

    card applyEffectTo: ship1 inGame: game.

    self assert: ship1 fuel equals: 20.
    self assert: ship2 fuel equals: 15.
]

{ #category : 'tests' }
TimeMachineCardTest >> testApplyEffectRequiresTwoTurns [
    | scenario game ship1 ship2 card |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'One'.
    ship2 := scenario shipNamed: 'Two'.
    game fuelHistory: (Dictionary new
        at: ship1 put: (OrderedCollection with: 10);
        at: ship2 put: (OrderedCollection with: 0);
        yourself).
    card := TimeMachineCard new.

    self
        should: [ card applyEffectTo: ship1 inGame: game ]
        raise: Error
        withMessageText: 'Not enough turns to use Time Machine'.
]

{ #category : 'tests' }
TimeMachineCardTest >> testApplyEffectWithAlliesRequiresTwoTurns [
    | scenario game ship1 ship2 card ally |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'One'.
    ship2 := scenario shipNamed: 'Two'.
    ally := AllyCard withAlly: ship2.
    ally activateFor: ship1 inGame: game.
    game fuelHistory: (Dictionary new
        at: ship1 put: (OrderedCollection with: 20 with: 10);
        at: ship2 put: (OrderedCollection with: 15);
        yourself).
    card := TimeMachineCard new.

    self
        should: [ card applyEffectTo: ship1 inGame: game ]
        raise: Error
        withMessageText: 'Not enough turns to use Time Machine'.
]

