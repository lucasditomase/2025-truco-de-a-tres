Extension {
    #name : 'Number'
}

{ #category : '*IngSoft2-Model' }
Number >> asBoardDistance [
    (self > 0) ifFalse: [
        self error: Board invalidDistanceMessage
    ].
    ^ Distance parsecs: self
]
