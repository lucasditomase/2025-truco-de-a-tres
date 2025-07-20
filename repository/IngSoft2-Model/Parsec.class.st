Class {
    #name : 'Parsec',
    #superclass : 'DistanceUnit',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'constants' }
Parsec class >> lightYearsPerParsec [
    ^ 3
]

{ #category : 'converting' }
Parsec >> asLightYears: aNumber [
    ^ aNumber * self class lightYearsPerParsec
]

{ #category : 'converting' }
Parsec >> asParsecs: aNumber [
    ^ aNumber
]
