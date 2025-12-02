Class {
    #name : 'CancellationCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
CancellationCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
CancellationCardTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'support' }
CancellationCardTest >> activate: aCard for: aShip inGame: aGame [
    aCard requiresTurnToActivate
        ifTrue: [
            aShip addCard: aCard.
            self ensureTurnOf: aShip inGame: aGame.
            aShip playCard: aCard inGame: aGame ]
        ifFalse: [ aShip addActiveCard: aCard ]
]

{ #category : 'asserting' }
CancellationCardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error | self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests - instance' }
CancellationCardTest >> testApplyEffectToCancelsAccelerationCard [
    | scenario game alpha beta target card |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    target := AccelerationCard new.
    self activate: target for: alpha inGame: game.

    card := CancellationCard cancelling: target.
    card applyEffectTo: beta inGame: game.

    self deny: (alpha activeCards includes: target).
]

{ #category : 'tests - instance' }
CancellationCardTest >> testApplyEffectToCancelsAdvanceCard [
    | scenario game alpha beta target card |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    target := AdvanceCard new.
    self activate: target for: alpha inGame: game.

    card := CancellationCard cancelling: target.
    card applyEffectTo: beta inGame: game.

    self deny: (alpha activeCards includes: target).
]

{ #category : 'tests - instance' }
CancellationCardTest >> testApplyEffectToCancelsAllyCard [
    | scenario game owner ally player target card |
    scenario := self builder
        withShipNames: #('Owner' 'Ally' 'Player');
        build.
    game := scenario game.
    owner := scenario shipNamed: 'Owner'.
    ally := scenario shipNamed: 'Ally'.
    player := scenario shipNamed: 'Player'.
    target := AllyCard withAlly: ally.
    self activate: target for: owner inGame: game.

    card := CancellationCard cancelling: target.
    card applyEffectTo: player inGame: game.

    self deny: (owner activeCards includes: target).
]

{ #category : 'tests - instance' }
CancellationCardTest >> testApplyEffectToCancelsCancellationCard [
    | scenario game alpha beta target card |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    target := CancellationCard cancelling: (AdvanceCard new).
    self activate: target for: alpha inGame: game.

    card := CancellationCard cancelling: target.
    card applyEffectTo: beta inGame: game.

    self deny: (alpha activeCards includes: target).
]

{ #category : 'tests - instance' }
CancellationCardTest >> testApplyEffectToCancelsOverloadCard [
    | scenario game alpha beta target card |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    target := OverloadCard forShip: alpha.
    self activate: target for: alpha inGame: game.

    card := CancellationCard cancelling: target.
    card applyEffectTo: beta inGame: game.

    self deny: (alpha activeCards includes: target).
]

{ #category : 'tests - instance' }
CancellationCardTest >> testApplyEffectToCancelsRedoCard [
    | scenario game alpha beta target card |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    target := RedoCard new.
    self activate: target for: alpha inGame: game.

    card := CancellationCard cancelling: target.
    card applyEffectTo: beta inGame: game.

    self deny: (alpha activeCards includes: target).
]

{ #category : 'tests - instance' }
CancellationCardTest >> testApplyEffectToCancelsShieldCard [
    | scenario game alpha beta target card |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    target := ShieldCard new.
    self activate: target for: alpha inGame: game.

    card := CancellationCard cancelling: target.
    card applyEffectTo: beta inGame: game.

    self deny: (alpha activeCards includes: target).
]

{ #category : 'tests - instance' }
CancellationCardTest >> testApplyEffectToRemovesCardFromGame [
    | scenario game alpha beta target card |
    scenario := self builder build.
    game := scenario game.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    target := RepeatCard new.
    self activate: target for: alpha inGame: game.

    card := CancellationCard cancelling: target.
    card applyEffectTo: beta inGame: game.

    self deny: (alpha activeCards includes: target).
    self deny: (game activeCards includes: target).
]

{ #category : 'tests - class' }
CancellationCardTest >> testCancellingCreatesCardWithTarget [
    | target card |

    target := RepeatCard new.
    card := CancellationCard cancelling: target.

    self assert: card class equals: CancellationCard.
    self assert: card cardToCancel equals: target.
]

{ #category : 'tests - instance' }
CancellationCardTest >> testInitializeCancellingSetsCardToCancel [
    | target card returned |

    target := RepeatCard new.
    card := CancellationCard new.
    returned := card initializeCancelling: target.

    self assert: returned equals: card.
    self assert: card cardToCancel equals: target.
]

{ #category : 'tests - instance' }
CancellationCardTest >> testPlayOnRaisesErrorWhenNoActiveCards [
    | scenario game ship card |

    scenario := self builder build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    card := CancellationCard cancelling: (AccelerationCard new).
    ship addCard: card.

    self ensureTurnOf: ship inGame: game.
    self
        should: [ ship playCard: card inGame: game ]
        raise: Error
        withMessageText: 'No active cards to cancel'.
]
