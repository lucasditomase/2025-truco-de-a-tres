Class {
    #name : 'GameCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
GameCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
GameCardTest >> advanceCardTargeting: aShip [
    | card |
    card := AdvanceCard new.
    aShip addCard: card.
    ^ card
]

{ #category : 'tests' }
GameCardTest >> testLastEffectiveCardTracksPlayedCards [
    | scenario game ship card |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    card := self advanceCardTargeting: ship.

    ship playCard: card inGame: game.

    self assert: game lastCardPlayed equals: card.
    self assert: game lastEffectiveCard equals: card
]

{ #category : 'tests' }
GameCardTest >> testRedoCardDoesNotReplaceEffectiveCard [
    | scenario game ship advance redo |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    advance := self advanceCardTargeting: ship.
    redo := RedoCard new.
    ship addCard: redo.

    ship playCard: advance inGame: game.
    ship playCard: redo inGame: game.

    self assert: game lastCardPlayed equals: redo.
    self assert: game lastEffectiveCard equals: advance
]

{ #category : 'tests' }
GameCardTest >> testRepeatCardDoesNotReplaceEffectiveCard [
    | scenario game alpha beta advance repeat |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    advance := self advanceCardTargeting: alpha.
    repeat := RepeatCard targeting: alpha.
    alpha addCard: repeat.

    beta playCard: self advanceCardTargeting: beta inGame: game.
    alpha playCard: advance inGame: game.
    alpha playCard: repeat inGame: game.

    self assert: game lastCardPlayed equals: repeat.
    self assert: game lastEffectiveCard equals: advance
]

{ #category : 'tests' }
GameCardTest >> testRepeatCardTargetsOtherShip [
    | scenario game alpha beta betaAdvance repeat |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    betaAdvance := self advanceCardTargeting: beta.
    repeat := RepeatCard targeting: beta.
    alpha addCard: repeat.

    beta playCard: betaAdvance inGame: game.
    alpha playCard: repeat inGame: game.

    self assert: beta position equals: 2.
    self assert: game lastCardPlayed equals: repeat.
    self assert: game lastEffectiveCard equals: betaAdvance
]

{ #category : 'tests' }
GameCardTest >> testRedoCardReplaysLastEffectiveCard [
    | scenario game alpha beta advance redo |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 4;
        laps: 5;
        build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    advance := self advanceCardTargeting: beta.
    redo := RedoCard new.
    alpha addCard: redo.

    beta playCard: advance inGame: game.
    alpha playCard: redo inGame: game.

    self assert: beta position equals: 2.
    self assert: game lastCardPlayed equals: redo.
    self assert: game lastEffectiveCard equals: advance
]
