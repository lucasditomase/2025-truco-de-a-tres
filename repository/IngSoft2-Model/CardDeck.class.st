Class {
    #name : 'CardDeck',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'deck' }
CardDeck class >> availableCards [
    
    
    ^ Card allCardTypes
]

{ #category : 'deck' }
CardDeck class >> randomCard [
    ^ (self availableCards atRandom) new
]

{ #category : 'deck' }
CardDeck class >> cyclingThrough: cardClasses [
    | collection index |
    collection := cardClasses asOrderedCollection.
    (collection isEmpty or: [
        (collection allSatisfy: [ :each | each isBehavior and: [ each inheritsFrom: Card ]]) not ]) ifTrue: [
        self error: 'Card deck must cycle through Card subclasses'.
    ].
    index := 0.
    ^ [
        index := (index \\ collection size) + 1.
        (collection at: index) new
    ]
]
