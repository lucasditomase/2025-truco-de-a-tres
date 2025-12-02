Class {
    #name : 'CardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
CardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
CardTest >> testModifyRollReturnsSameNumber [
    | scenario game ship card result |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 6;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    card := Card new.
    result := card modifyRoll: 5 forShip: ship inGame: game.
    self assert: result equals: 5.
]

{ #category : 'tests' }
CardTest >> testPlayOnRaisesSubclassResponsibilityError [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 6;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.

    self should: [ Card new playOn: ship inGame: game ] raise: Error.
]

{ #category : 'tests' }
CardTest >> testAllyForReturnsNullSpaceship [
    | scenario ship card ally |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 6;
        build.
    ship := scenario shipNamed: 'Alpha'.
    card := Card new.
    ally := card allyFor: ship.
    self assert: ally class equals: NullSpaceship.
]

{ #category : 'tests' }
CardTest >> testPermanentCardRequiresTurnToActivate [
    | card |
    card := ShieldCard new.
    self assert: card requiresTurnToActivate.
]

{ #category : 'tests' }
CardTest >> testInstantCardDoesNotRequireTurnToActivate [
    | card |
    card := AdvanceCard new.
    self deny: card requiresTurnToActivate.
]
