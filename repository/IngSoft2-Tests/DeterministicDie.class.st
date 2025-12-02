Class {
    #name : 'DeterministicDie',
    #superclass : 'Die',
    #instVars : [
        'rollValues',
        'nextIndex'
    ],
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'instance creation' }
DeterministicDie class >> withValues: aCollection [
    (aCollection isCollection and: [ aCollection notEmpty ]) ifFalse: [
        self error: 'DeterministicDie requires at least one value'
    ].
    ^ self new initializeWithValues: aCollection
]

{ #category : 'instance creation' }
DeterministicDie class >> withValues: aCollection sides: aMaxSide [
    ^ (self withValues: aCollection) sides: aMaxSide
]

{ #category : 'initialization' }
DeterministicDie >> initializeWithValues: aCollection [
    rollValues := aCollection asOrderedCollection.
    nextIndex := 1.
    sides := rollValues max.
    ^ self
]

{ #category : 'configuration' }
DeterministicDie >> sides: aNumber [
    sides := aNumber.
    ^ self
]

{ #category : 'rolling' }
DeterministicDie >> roll [
    | value |
    value := rollValues at: nextIndex.
    nextIndex := nextIndex + 1.
    nextIndex > rollValues size ifTrue: [ nextIndex := 1 ].
    ^ value
]
