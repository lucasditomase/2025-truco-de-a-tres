Class {
    #name : 'NullWormhole',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'validation' }
NullWormhole >> hasEntryAt: aPosition [
    ^ false
]

{ #category : 'operations' }
NullWormhole >> exitFrom: aPosition [
    ^ NullBehavior passThrough: aPosition
]

{ #category : 'operations' }
NullWormhole >> exitFrom: aPosition inBoard: aBoard [
    ^ self exitFrom: aPosition
]

{ #category : 'operations' }
NullWormhole >> reverseOnBoard: aBoard at: aPosition [
    aBoard reverseEffectAt: aPosition
]

