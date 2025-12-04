Class {
    #name : 'Card',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'catalog' }
Card class >> allCardTypes [
    
    
    
    
    ^ {
        CancellationCard.
        RepeatCard.
        AdvanceCard.
        TimeMachineCard.
        
        AccelerationCard.
        OverloadCard.
        AllyCard.
        ReversalCard.
        ShieldCard.
        
        RedoCard
    }
]

{ #category : 'catalog' }
Card class >> instantCardTypes [
    
    ^ self allCardTypes select: [ :cardClass | 
        cardClass inheritsFrom: InstantCard ]
]

{ #category : 'catalog' }
Card class >> permanentCardTypes [
    
    ^ self allCardTypes select: [ :cardClass | 
        cardClass inheritsFrom: PermanentCard ]
]

{ #category : 'catalog' }
Card class >> randomCard [
    
    | types |
    types := self allCardTypes.
    ^ (types atRandom) new
]

{ #category : 'effects' }
Card >> modifyRoll: aNumber forShip: aShip inGame: aGame [
    ^ aNumber
]

{ #category : 'playing' }
Card >> playOn: aShip inGame: aGame [
    self subclassResponsibility
]

{ #category : 'ally' }
Card >> allyFor: aShip [
    ^ NullSpaceship new
]

{ #category : 'querying' }
Card >> recordsLastEffect [
    ^ true
]

{ #category : 'querying' }
Card >> requiresTurnToActivate [
    ^ false
]

{ #category : 'querying' }
Card >> isNull [
    ^ false
]
