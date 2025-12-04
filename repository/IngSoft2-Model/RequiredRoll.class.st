Class {
    #name : 'RequiredRoll',
    #superclass : 'Object',
    #instVars : [ 'value' ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
RequiredRoll class >> withValue: aNumber [
    ^ self new initializeWith: aNumber
]

{ #category : 'initialization' }
RequiredRoll >> initializeWith: aNumber [
    value := aNumber.
    ^ self
]

{ #category : 'accessing' }
RequiredRoll >> value [
    ^ value
]

{ #category : 'testing' }
RequiredRoll >> isNullRequired [
    ^ false
]