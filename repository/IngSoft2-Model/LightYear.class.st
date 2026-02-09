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
    ^ aNumber / Parsec lightYearsInOne
]

{ #category : 'comparing' }
LightYear >> = anObject [
    ^ self class = anObject class
]

{ #category : 'comparing' }
LightYear >> hash [
    ^ self class hash
]
