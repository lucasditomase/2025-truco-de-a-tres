Class {
    #name : 'DiceCup',
    #superclass : 'Object',
    #instVars : [
        'diceCollection'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'validation' }
DiceCup class >> validateMinimumDice: someDice [
    (someDice isCollection and: [
        someDice isString not and: someDice notEmpty ]) ifFalse: [
        self error: 'At least one die is required to initialize the game' ]
]

{ #category : 'validation' }
DiceCup class >> ensureDiceCollectionFrom: someDice [
    self validateMinimumDice: someDice.
    someDice do: [ :each |
        ((each respondsTo: #roll) and: [ each respondsTo: #sides ]) ifFalse: [
            self error: 'Dice must understand #roll and #sides' ] ].
    ^ someDice asOrderedCollection
]

{ #category : 'instance creation' }
DiceCup class >> with: someDice [
    ^ self new initializeWith: (self ensureDiceCollectionFrom: someDice)
]

{ #category : 'initialize' }
DiceCup >> initializeWith: someDice [
    diceCollection := someDice
]

{ #category : 'process actions' }
DiceCup >> maxRoll [
    ^ diceCollection sum: [ :die | die sides ]
]

{ #category : 'process actions' }
DiceCup >> roll [
    ^ diceCollection sum: [ :die | die roll ]
]
