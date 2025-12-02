Class {
    #name : 'RedoCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
RedoCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
RedoCardTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnRepeatsLastCardEffect [
    | scenario game ship advance redo |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 4;
        boardWithCells: 10;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    advance := AdvanceCard new.
    redo := RedoCard new.
    ship addCard: advance.
    ship addCard: redo.

    ship playCard: advance inGame: game.
    ship playCard: redo inGame: game.

    self assert: ship position equals: 2.
    self assert: game lastCardPlayed equals: redo
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnAfterRedoReplaysSameEffect [
    | scenario game ship advance firstRedo secondRedo |
    scenario := self builder build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    advance := AdvanceCard new.
    firstRedo := RedoCard new.
    secondRedo := RedoCard new.
    ship addCard: advance.
    ship addCard: firstRedo.

    ship playCard: advance inGame: game.
    ship playCard: firstRedo inGame: game.
    ship addCard: secondRedo.
    ship playCard: secondRedo inGame: game.

    self assert: ship position equals: 3
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnReplaysAccelerationCard [
    | scenario game alpha beta acceleration redo |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    acceleration := AccelerationCard new.
    redo := RedoCard new.

    beta addCard: acceleration.
    alpha addCard: redo.
    self ensureTurnOf: beta inGame: game.
    beta playCard: acceleration inGame: game.
    game removeActiveCard: acceleration.

    self ensureTurnOf: alpha inGame: game.
    alpha playCard: redo inGame: game.

    self assert: (alpha activeCards includes: acceleration).
    self deny: (beta activeCards includes: acceleration).
    self assert: game lastCardPlayed equals: redo
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnReplaysAllyCard [
    | scenario game alpha beta ally redo |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    ally := AllyCard withAlly: beta.
    redo := RedoCard new.

    alpha addCard: ally.
    self ensureTurnOf: alpha inGame: game.
    alpha playCard: ally inGame: game.
    game removeActiveCard: ally.

    alpha addCard: redo.
    alpha playCard: redo inGame: game.

    self assert: (alpha activeCards includes: ally).
    self assert: (beta activeCards includes: ally).
    self assert: game lastCardPlayed equals: redo
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnReplaysCancellationCard [
    | scenario game alpha beta shield cancellation redo |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    shield := ShieldCard new.
    cancellation := CancellationCard cancelling: shield.
    redo := RedoCard new.

    alpha addCard: shield.
    self ensureTurnOf: alpha inGame: game.
    alpha playCard: shield inGame: game.

    beta addCard: cancellation.
    self ensureTurnOf: beta inGame: game.
    beta playCard: cancellation inGame: game.

    shield activateFor: alpha inGame: game.
    alpha addCard: redo.
    alpha playCard: redo inGame: game.

    self deny: (alpha activeCards includes: shield).
    self assert: game lastCardPlayed equals: redo
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnReplaysOverloadCard [
    | scenario game alpha beta overload redo |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    overload := OverloadCard forShip: beta.
    redo := RedoCard new.

    alpha addCard: overload.
    self ensureTurnOf: alpha inGame: game.
    alpha playCard: overload inGame: game.
    game removeActiveCard: overload.

    alpha addCard: redo.
    alpha playCard: redo inGame: game.

    self assert: (beta activeCards includes: overload).
    self assert: game lastCardPlayed equals: redo
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnReplaysRepeatCard [
    | scenario game ship repeat redo |
    scenario := self builder build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    repeat := RepeatCard new.
    redo := RedoCard new.

    ship addCard: repeat.
    ship playCard: repeat inGame: game.

    ship addCard: redo.
    ship playCard: redo inGame: game.

    self assert: ship position equals: 0.
    self assert: game lastCardPlayed equals: redo
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnReplaysShieldCard [
    | scenario game alpha beta shield redo |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    shield := ShieldCard new.
    redo := RedoCard new.

    beta addCard: shield.
    self ensureTurnOf: beta inGame: game.
    beta playCard: shield inGame: game.
    game removeActiveCard: shield.

    alpha addCard: redo.
    alpha playCard: redo inGame: game.

    self assert: (alpha activeCards includes: shield).
    self assert: game lastCardPlayed equals: redo
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnReplaysTimeMachineCard [
    | scenario game ship timeMachine redo initialFuel |
    scenario := self builder
        diceWithSides: 6;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    timeMachine := TimeMachineCard new.
    redo := RedoCard new.

    initialFuel := ship fuel.
    ship fuel: initialFuel - 2.
    game recordFuelStartFor: ship.
    ship fuel: initialFuel - 4.
    game recordFuelStartFor: ship.
    ship fuel: 0.

    ship addCard: timeMachine.
    ship playCard: timeMachine inGame: game.
    ship fuel: 1.

    ship addCard: redo.
    ship playCard: redo inGame: game.

    self assert: ship fuel equals: initialFuel
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnReplaysReversalCard [
    | scenario game board ship reversal redo |
    scenario := self builder
        boardFactory: [ Board of: 5 andWormholeAt: { Wormhole from: 1 to: 3 } ];
        build.
    game := scenario game.
    board := game board.
    ship := scenario shipNamed: 'Alpha'.
    reversal := ReversalCard new.
    redo := RedoCard new.

    board moveShip: ship to: 1.
    ship addCard: reversal.
    self ensureTurnOf: ship inGame: game.
    ship playCard: reversal inGame: game.
    board reverseAt: 1.

    ship addCard: redo.
    ship playCard: redo inGame: game.

    self assert: (board wormholeEnteringAt: 1) class equals: ReversedWormhole
]

{ #category : 'tests' }
RedoCardTest >> testPlayOnWithNoLastCardDoesNothing [
    | scenario game ship redo |
    scenario := self builder build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    redo := RedoCard new.

    ship addCard: redo.
    ship playCard: redo inGame: game.

    self assert: ship position equals: 0.
    self assert: game lastCardPlayed equals: redo
]
