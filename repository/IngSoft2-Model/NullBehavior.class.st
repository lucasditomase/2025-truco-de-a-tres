Class {
    #name : 'NullBehavior',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'helpers' }
NullBehavior class >> alwaysTrue [
    ^ true
]

{ #category : 'helpers' }
NullBehavior class >> doNothing [
]

{ #category : 'helpers' }
NullBehavior class >> passThrough: anObject [
    ^ anObject
]
