Extension {
    #name : 'BlockClosure'
}

{ #category : '*IngSoft2-Model' }
BlockClosure >> asBlockEffectAction [
    (self numArgs = 2) ifFalse: [
        self error: BlockEffect invalidActionMessage
    ].
    ^ self
]

{ #category : '*IngSoft2-Model' }
BlockClosure >> asFuelRestorer [
    ^ self
]
