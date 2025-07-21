Class {
    #name : 'Parsec',
    #superclass : 'DistanceUnit',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'constants' }
Parsec class >> lightYearsInOne [
    ^ 3
]

{ #category : 'converting' }
Parsec >> asLightYears: aNumber [
    ^ aNumber * self class lightYearsInOne
]

{ #category : 'converting' }
Parsec >> asParsecs: aNumber [
    ^ aNumber
]
