Class {
    #name : 'CardDeckTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CardDeckTest >> testCyclingThroughReturnsCardsInSequence [
    | dealer |
    dealer := CardDeck cyclingThrough: { AdvanceCard. ShieldCard }.

    self assert: dealer value class equals: AdvanceCard.
    self assert: dealer value class equals: ShieldCard.
    self assert: dealer value class equals: AdvanceCard.
]

{ #category : 'tests' }
CardDeckTest >> testCyclingThroughRequiresCardClasses [
    self
        should: [ CardDeck cyclingThrough: { Object } ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Card deck must cycle through Card subclasses'
        ].

    self
        should: [ CardDeck cyclingThrough: #() ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Card deck must cycle through Card subclasses'
        ].
]
