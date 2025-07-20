Class {
    #name : 'LightYear',
    #superclass : 'DistanceUnit',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'converting' }
LightYear >> asLightYears: aNumber [
    ^ aNumber
]

{ #category : 'converting' }
LightYear >> asParsecs: aNumber [
    ^ aNumber / Parsec lightYearsPerParsec
]
