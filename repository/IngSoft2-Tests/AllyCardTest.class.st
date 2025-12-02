Class {
    #name : 'AllyCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
AllyCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
AllyCardTest >> testActivateForAddsCardToOwnerAndAlly [
    | scenario owner ally card |
    scenario := self builder build.
    owner := scenario shipNamed: 'Alpha'.
    ally := scenario shipNamed: 'Beta'.
    card := AllyCard withAlly: ally.
    owner addCard: card.
    owner playCard: card inGame: scenario game.
    self assert: (owner activeCards includes: card).
    self assert: (ally activeCards includes: card).
    self assert: card ownerShip equals: owner.
]

{ #category : 'tests' }
AllyCardTest >> testAllyForReturnsCorrectShip [
    | scenario owner ally other card |
    scenario := self builder
        withShipNames: #('Owner' 'Ally' 'Other');
        build.
    owner := scenario shipNamed: 'Owner'.
    ally := scenario shipNamed: 'Ally'.
    other := scenario shipNamed: 'Other'.
    card := AllyCard withAlly: ally.
    owner addCard: card.
    owner playCard: card inGame: scenario game.
    self assert: (card allyFor: owner) equals: ally.
    self assert: (card allyFor: ally) equals: owner.
    self assert: (card allyFor: other) isNullShip.
]

{ #category : 'tests' }
AllyCardTest >> testInitializeWithAllySetsAllyShip [
    | ally card |
    ally := Spaceship withName: 'Friend'.
    card := AllyCard new initializeWithAlly: ally.
    self assert: card allyShip equals: ally.
]

{ #category : 'tests' }
AllyCardTest >> testWithAllyInitializesAllyShip [
    | ally card |
    ally := Spaceship withName: 'Ally'.
    card := AllyCard withAlly: ally.
    self assert: card allyShip equals: ally.
]
