Class {
    #name : 'DistanceUnit',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'converting' }
DistanceUnit >> asLightYears: aNumber [
    self subclassResponsibility
]

{ #category : 'converting' }
DistanceUnit >> asParsecs: aNumber [
    self subclassResponsibility
]
