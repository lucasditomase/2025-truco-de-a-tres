Extension {
    #name : 'Collection'
}

{ #category : '*IngSoft2-Model' }
Collection >> asSpaceshipCollection [
    self do: [ :each |
        Spaceship ensureSpaceship: each errorMessage: Spaceship invalidCollectionMessage
    ].
    ^ self
]
