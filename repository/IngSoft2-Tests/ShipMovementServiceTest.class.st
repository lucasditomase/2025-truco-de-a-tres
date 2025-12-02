Class {
    #name : 'ShipMovementServiceTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'helpers' }
ShipMovementServiceTest >> buildServiceStartingAt: startPosition cellCount: count [
    | ship manager service |
    ship := Spaceship withName: 'Mover'.
    ship moveTo: startPosition.
    manager := PositionManager forShips: { ship }.
    service := ShipMovementService
        withPositionManager: manager
        cellCount: count
        lastMoves: Dictionary new.
    ^ { service. ship. manager }
]

{ #category : 'tests' }
ShipMovementServiceTest >> testMoveShipForwardUpdatesPositionAndLastMove [
    | tuple service ship manager |
    tuple := self buildServiceStartingAt: 0 cellCount: 10.
    service := tuple first.
    ship := tuple second.
    manager := tuple third.

    service moveShip: ship forward: 3.

    self assert: (manager positionOf: ship) equals: 3.
    self assert: (service lastMoveFor: ship) equals: 3.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testMoveShipBackwardWrapsAndRecordsNegativeDelta [
    | tuple service ship manager |
    tuple := self buildServiceStartingAt: 1 cellCount: 5.
    service := tuple first.
    ship := tuple second.
    manager := tuple third.

    service moveShip: ship backward: 3.

    self assert: (manager positionOf: ship) equals: 3.
    self assert: (service lastMoveFor: ship) equals: -3.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testMoveShipToUsesAbsoluteDestination [
    | tuple service ship manager |
    tuple := self buildServiceStartingAt: 2 cellCount: 10.
    service := tuple first.
    ship := tuple second.
    manager := tuple third.

    service moveShip: ship to: 7.

    self assert: (manager positionOf: ship) equals: 7.
    self assert: (service lastMoveFor: ship) equals: 5.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testClearLastMovesResetsHistory [
    | tuple service ship |
    tuple := self buildServiceStartingAt: 0 cellCount: 10.
    service := tuple first.
    ship := tuple second.

    service moveShip: ship forward: 4.
    service clearLastMoves.

    self assert: (service lastMoveFor: ship) equals: 0.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testRecentMovesDuringCapturesAggregatedReport [
    | tuple service ship report captured |
    tuple := self buildServiceStartingAt: 0 cellCount: 8.
    service := tuple first.
    ship := tuple second.

    captured := service recentMovesDuring: [
        service moveShip: ship forward: 7.
        service moveShip: ship backward: 2
    ].
    report := captured at: ship ifAbsent: [ self fail: 'Missing report' ].

    self assert: report startPosition equals: 0.
    self assert: report delta equals: 5.

    service moveShip: ship forward: 1.
    self assert: report delta equals: 5.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testIsRecordingMovesOnlyDuringCapture [
    | tuple service flag |
    tuple := self buildServiceStartingAt: 0 cellCount: 3.
    service := tuple first.
    flag := false.

    service recentMovesDuring: [ flag := service isRecordingMoves ].

    self assert: flag.
    self deny: service isRecordingMoves.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testMoveShipWithZeroCellsDoesNothing [
    | tuple service ship manager result |
    tuple := self buildServiceStartingAt: 2 cellCount: 0.
    service := tuple first.
    ship := tuple second.
    manager := tuple third.

    result := service moveShip: ship forward: 5.

    self assert: result equals: 0.
    self assert: (manager positionOf: ship) equals: 2.
    self assert: (service lastMoveFor: ship) equals: 0.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testConfigurationSettersRewireService [
    | tuple service ship newManager newLastMoves |
    tuple := self buildServiceStartingAt: 0 cellCount: 4.
    service := tuple first.
    ship := tuple second.
    ship moveTo: 5.
    newManager := PositionManager forShips: { ship }.
    newLastMoves := Dictionary new.

    service positionManager: newManager.
    service cellCount: 6.
    service lastMoves: newLastMoves.

    service moveShip: ship backward: 2.

    self assert: (newManager positionOf: ship) equals: 3.
    self assert: (service lastMoveFor: ship) equals: -2.
    self assert: (newLastMoves at: ship) equals: -2.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testWithPositionManagerRequiresPositionManagerInstance [
    self
        should: [
            ShipMovementService
                withPositionManager: 'not a manager'
                cellCount: 5
                lastMoves: Dictionary new ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Position manager must be an instance of PositionManager' ].
]

{ #category : 'tests' }
ShipMovementServiceTest >> testWithPositionManagerRequiresNonNegativeCellCount [
    | manager |
    manager := PositionManager forShips: { Spaceship withName: 'Mover' }.
    self
        should: [
            ShipMovementService
                withPositionManager: manager
                cellCount: -1
                lastMoves: Dictionary new ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Cell count must be a non-negative integer' ].
]

{ #category : 'tests' }
ShipMovementServiceTest >> testWithPositionManagerRequiresDictionaryForLastMoves [
    | manager |
    manager := PositionManager forShips: { Spaceship withName: 'Mover' }.
    self
        should: [
            ShipMovementService
                withPositionManager: manager
                cellCount: 1
                lastMoves: OrderedCollection new ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Last moves must be stored in a Dictionary' ].
]
