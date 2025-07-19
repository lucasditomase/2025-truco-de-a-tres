Class {
    #name : 'ReversedWormhole',
    #superclass : 'Wormhole',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'validation' }
ReversedWormhole >> hasEntryAt: aPosition [
    ^ (super hasEntryAt: aPosition) or: [ self exit = aPosition ]
]

{ #category : 'validation' }
ReversedWormhole >> exitFrom: aPosition [
    aPosition = self entry ifTrue: [ ^ self exit ].
    aPosition = self exit ifTrue: [ ^ self entry ].
    self error: 'Invalid entry'
]

{ #category : 'operations' }
ReversedWormhole >> exitFrom: aPosition inBoard: aBoard [
    aPosition = self entry ifTrue: [
        ^ (self exit - aBoard cellCount)
    ].
    aPosition = self exit ifTrue: [
        ^ self entry + aBoard cellCount
    ].
    self error: 'Invalid entry'
]
