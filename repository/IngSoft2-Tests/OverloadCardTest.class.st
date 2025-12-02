Class {
    #name : 'OverloadCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
OverloadCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
OverloadCardTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
OverloadCardTest >> testActivateForAddsCardToShipActiveCards [
    | scenario game alpha beta card |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    card := OverloadCard forShip: beta.
    alpha addCard: card.
    self ensureTurnOf: alpha inGame: game.
    alpha playCard: card inGame: game.

    self assert: (beta activeCards includes: card)
]

{ #category : 'tests' }
OverloadCardTest >> testForShipCreatesCardWithTargetShipSet [
    | ship card |
    ship := Spaceship withName: 'Target'.
    card := OverloadCard forShip: ship.
    self assert: card targetShip equals: ship.
]

{ #category : 'tests' }
OverloadCardTest >> testInitializeForShipSetsTargetShip [
    | ship card |
    ship := Spaceship withName: 'Alpha'.
    card := OverloadCard new initializeForShip: ship.
    self assert: card targetShip equals: ship.
]

{ #category : 'tests' }
OverloadCardTest >> testModifyRollForOtherShipUnchanged [
    | ship1 ship2 card result |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    card := OverloadCard forShip: ship1.
    result := card modifyRoll: 4 forShip: ship2 inGame: nil.
    self assert: result equals: 4.
]

{ #category : 'tests' }
OverloadCardTest >> testModifyRollForTargetShipSubtractsTwo [
    | ship card result |
    ship := Spaceship withName: 'One'.
    card := OverloadCard forShip: ship.
    result := card modifyRoll: 5 forShip: ship inGame: nil.
    self assert: result equals: 3.
]
