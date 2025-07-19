Class {
    #name : 'TimeMachineCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
TimeMachineCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error | self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
TimeMachineCardTest >> testApplyEffectRestoresFuel [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game instVarNamed: 'fuelHistory' put: (Dictionary new
        at: ship1 put: (OrderedCollection with: 20 with: 10);
        at: ship2 put: (OrderedCollection with: 0 with: 0);
        yourself).
    ship1 instVarNamed: 'fuel' put: 2.
    card := TimeMachineCard new.
    card applyEffectTo: ship1 inGame: game.
    self assert: (ship1 instVarNamed: 'fuel') equals: 20.
]

{ #category : 'tests' }
TimeMachineCardTest >> testApplyEffectWithAlliesRestoresAll [
    | ship1 ship2 board dice game card ally |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ally := AllyCard withAlly: ship2.
    ally activateFor: ship1 inGame: nil.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game instVarNamed: 'fuelHistory' put: (Dictionary new
        at: ship1 put: (OrderedCollection with: 20 with: 10);
        at: ship2 put: (OrderedCollection with: 15 with: 5);
        yourself).
    ship1 instVarNamed: 'fuel' put: 2.
    ship2 instVarNamed: 'fuel' put: 1.
    card := TimeMachineCard new.
    card applyEffectTo: ship1 inGame: game.
    self assert: (ship1 instVarNamed: 'fuel') equals: 20.
    self assert: (ship2 instVarNamed: 'fuel') equals: 15.
]

{ #category : 'tests' }
TimeMachineCardTest >> testApplyEffectRequiresTwoTurns [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    game instVarNamed: 'fuelHistory' put: (Dictionary new
        at: ship1 put: (OrderedCollection with: 10);
        at: ship2 put: (OrderedCollection with: 0);
        yourself).
    card := TimeMachineCard new.
    self
        should: [ card applyEffectTo: ship1 inGame: game ]
        raise: Error
        withMessageText: 'Not enough turns to use Time Machine'.
]

