Class {
    #name : 'HyperJumpEffect',
    #superclass : 'EffectDecorator',
    #instVars : [
        'jumpValues',
        'currentIndex'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
HyperJumpEffect class >> withLightYearValues: aCollection [
    ^ self new
        initializeWith:
            (aCollection collect: [ :each | Distance lightYears: each ]);
        yourself
]

{ #category : 'initialization' }
HyperJumpEffect class >> withValues: aCollection [
    ^ self new
        initializeWith: aCollection;
        yourself
]

{ #category : 'operations' }
HyperJumpEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    | parsecs steps |
    aBoard withMovementTrackingDuring: [
        parsecs := self nextJumpValue.
        steps := (parsecs / aBoard totalLengthInParsecs * aBoard cellCount)
            rounded.
        aBoard moveShip: aSpaceship forward: steps
    ]
]

{ #category : 'operations' }
HyperJumpEffect >> reversedVersion [
    ^ BlockEffect on: [ :ship :board |
        | parsecs steps |
        board withMovementTrackingDuring: [
            board moveShip: ship to: ship position.
            parsecs := self nextJumpValue.
            steps := (parsecs / board totalLengthInParsecs * board cellCount) rounded.
            board moveShip: ship backward: steps
        ]
    ]
]

{ #category : 'instance creation' }
HyperJumpEffect >> applyTo: aSpaceship [
    self error: 'Use applyTo:inBoard: instead.'
]

{ #category : 'instance creation' }
HyperJumpEffect >> applyTo: aSpaceship inBoard: aBoard [
    self applyEffectTo: aSpaceship inBoard: aBoard.
]

{ #category : 'private' }
HyperJumpEffect >> convertAndSortValues: aCollection [
    | convertedValues |

    convertedValues := aCollection collect: [ :each |
        Distance parsecValueOf: each
    ].

    ^ self sortDescendingPreservingOrder: convertedValues
]

{ #category : 'operations' }
HyperJumpEffect >> initializeWith: aCollection [
    jumpValues := self convertAndSortValues: aCollection.
    currentIndex := 1
]

{ #category : 'operations' }
HyperJumpEffect >> nextJumpValue [
    | value |
    value := jumpValues at: currentIndex.

    currentIndex := currentIndex + 1.

    currentIndex > jumpValues size ifTrue: [ currentIndex := 1 ].

    ^ value
]

{ #category : 'operations' }
HyperJumpEffect >> peekJumpValue [
    ^ jumpValues at: currentIndex.
]

{ #category : 'operations' }
HyperJumpEffect >> resetJumpIndex [
    currentIndex := 1.
    jumpValues := self sortDescendingPreservingOrder: jumpValues
]

{ #category : 'private' }
HyperJumpEffect >> sortDescendingPreservingOrder: aCollection [
    ^ aCollection sort: [ :a :b | a > b ]
]

{ #category : 'operations' }
HyperJumpEffect >> values [
    ^ jumpValues
]

{ #category : 'operations' }
HyperJumpEffect >> currentIndex [
    ^ currentIndex
]
