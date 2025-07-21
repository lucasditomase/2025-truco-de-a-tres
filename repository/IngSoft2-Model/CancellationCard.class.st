Class {
    #name : 'CancellationCard',
    #superclass : 'InstantCard',
    #instVars : [
        'cardToCancel'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
CancellationCard class >> cancelling: aCard [
    ^ self new initializeCancelling: aCard
]

{ #category : 'playing' }
CancellationCard >> applyEffectTo: aShip inGame: aGame [
    aGame removeActiveCard: cardToCancel
]

{ #category : 'playing' }
CancellationCard >> playOn: aShip inGame: aGame [
    aGame activeCards isEmpty ifTrue: [ self error: 'No active cards to cancel' ].
    super playOn: aShip inGame: aGame
]

{ #category : 'initialization' }
CancellationCard >> initializeCancelling: aCard [
    cardToCancel := aCard.
    ^ self
]

{ #category : 'accessing' }
CancellationCard >> cardToCancel [
    ^ cardToCancel
]
