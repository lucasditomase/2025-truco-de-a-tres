Class {
    #name : 'InstantCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'helpers' }
InstantCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'asserting' }
InstantCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error | self assert: error messageText equals: errorMessage ].
]

{ #category : 'tests' }
InstantCardTest >> testApplyEffectToIsAbstract [
    | card |
    card := InstantCard new.
    self should: [ card applyEffectTo: (Spaceship withName: 'Ship') inGame: nil ] raise: Error.
]

{ #category : 'tests' }
InstantCardTest >> testPlayOnInvokesApplyEffect [
    | scenario game ship card |
    scenario := self builder
        withShipNames: #('One' 'Two');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'One'.
    card := AdvanceCard new.

    card playOn: ship inGame: game.

    self assert: ship position equals: 1.
]
