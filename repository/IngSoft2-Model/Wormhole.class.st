Class {
    #name : 'Wormhole',
    #superclass : 'Object',
    #instVars : [
        'entry',
        'exit'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'asserting' }
Wormhole class >> assertValidStateFrom: entry to: exit [
    self
        ensureEntry: entry
        exit: exit
        samePositionMessage: 'Wormhole cannot go to itself'.
]

{ #category : 'initialize' }
Wormhole class >> connecting: aPosition and: anotherPosition [
    | endpoints |

    endpoints := self
        ensureEntry: aPosition
        exit: anotherPosition
        samePositionMessage: 'Wormhole positions must be distinct'.
    ^ self basicNew initializeConnecting: endpoints first and: endpoints second.
]

{ #category : 'initialize' }
Wormhole class >> from: entryPosition to: exitPosition [
    | endpoints |

    endpoints := self
        ensureEntry: entryPosition
        exit: exitPosition
        samePositionMessage: 'Wormhole cannot go to itself'.
    ^ self basicNew initializeFrom: endpoints first to: endpoints second.
]

{ #category : 'instance creation' }
Wormhole class >> new [
    self error: 'Use Wormhole from:to: instead.'.
]

{ #category : 'validation' }
Wormhole class >> ensureEntry: entryPosition exit: exitPosition samePositionMessage: samePositionMessage [
    (entryPosition isInteger and: [ exitPosition isInteger ]) ifFalse: [
        self error: 'Entry and exit must be integers'
    ].

    (entryPosition > 0 and: [ exitPosition > 0 ]) ifFalse: [
        self error: 'Entry and exit must be positive'
    ].

    entryPosition = exitPosition ifTrue: [
        self error: samePositionMessage
    ].

    ^ Array with: entryPosition with: exitPosition
]

{ #category : 'validation' }
Wormhole >> entry [
    ^ entry.
]

{ #category : 'validation' }
Wormhole >> exit [
    ^ exit
]

{ #category : 'validation' }
Wormhole >> hasEntryAt: aPosition [
    ^ entry = aPosition
]

{ #category : 'initialize' }
Wormhole >> initializeConnecting: aPosition and: anotherPosition [
    entry := aPosition.
    exit := anotherPosition
]

{ #category : 'validation' }
Wormhole >> initializeFrom: entryPosition to: exitPosition [
    entry := entryPosition.
    exit := exitPosition
]

{ #category : 'validation' }
Wormhole >> isValid [
    ^ [
        self class assertValidStateFrom: entry to: exit.
        true ]
        on: Error
        do: [ false ]
]

{ #category : 'operations' }
Wormhole >> exitFrom: aPosition [
    ^ self exit
]

{ #category : 'operations' }
Wormhole >> exitFrom: aPosition inBoard: aBoard [
    ^ self exitFrom: aPosition
]

{ #category : 'operations' }
Wormhole >> reversed [
    ^ ReversedWormhole from: self entry to: self exit
]

{ #category : 'operations' }
Wormhole >> reverseOnBoard: aBoard at: aPosition [
    aBoard removeWormhole: self.
    aBoard addWormhole: self reversed.
]

