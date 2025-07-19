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
        withExceptionDo: [ :error | self assert: error messageText equals: errorMessage ].
]

{ #category : 'tests' }
TimeMachineCardTest >> testApplyEffectRestoresFuelFromTwoTurnsAgo [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'Time'.
    ship2 := Spaceship withName: 'Other'.
    ship1 instVarNamed: 'maxFuel' put: 20.
    ship1 instVarNamed: 'fuel' put: 20.
    ship2 instVarNamed: 'maxFuel' put: 20.
    ship2 instVarNamed: 'fuel' put: 20.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ship1 instVarNamed: 'fuel' put: 10.
    game advanceTurn.
    game advanceTurn.
    ship1 instVarNamed: 'fuel' put: 2.
    game advanceTurn.
    game advanceTurn.
    card := TimeMachineCard new.
    ship1 addCard: card.
    ship1 playCard: card inGame: game.
    self assert: (ship1 instVarNamed: 'fuel') equals: 20.
]

{ #category : 'tests' }
TimeMachineCardTest >> testApplyEffectRestoresFuelForAlly [
    | ship1 ship2 board dice game ally card |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ship1 instVarNamed: 'maxFuel' put: 20.
    ship1 instVarNamed: 'fuel' put: 20.
    ship2 instVarNamed: 'maxFuel' put: 20.
    ship2 instVarNamed: 'fuel' put: 15.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ally := AllyCard withAlly: ship2.
    ally activateFor: ship1 inGame: game.
    ship1 instVarNamed: 'fuel' put: 10.
    game advanceTurn.
    ship2 instVarNamed: 'fuel' put: 5.
    game advanceTurn.
    ship1 instVarNamed: 'fuel' put: 2.
    game advanceTurn.
    game advanceTurn.
    card := TimeMachineCard new.
    ship1 addCard: card.
    ship1 playCard: card inGame: game.
    self assert: (ship1 instVarNamed: 'fuel') equals: 20.
    self assert: (ship2 instVarNamed: 'fuel') equals: 15.
]

{ #category : 'tests' }
TimeMachineCardTest >> testCannotPlayWithoutTwoTurns [
    | ship1 ship2 board dice game card |
    ship1 := Spaceship withName: 'T'.
    ship2 := Spaceship withName: 'O'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    card := TimeMachineCard new.
    ship1 addCard: card.
    self
        should: [ ship1 playCard: card inGame: game ]
        raise: Error
        withMessageText: 'Cannot use Time Machine yet'.
]

{ #category : 'tests' }
TimeMachineCardTest >> testCannotPlayWhenAllyHasNotTwoTurns [
    | ship1 ship2 board dice game ally card |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    board := Board of: 5 andWormholeAt: {}.
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship1. ship2 } board: board dice: dice laps: 1.
    ally := AllyCard withAlly: ship2.
    ally activateFor: ship1 inGame: game.
    card := TimeMachineCard new.
    ship1 addCard: card.
    self
        should: [ ship1 playCard: card inGame: game ]
        raise: Error
        withMessageText: 'Cannot use Time Machine yet'.
]
