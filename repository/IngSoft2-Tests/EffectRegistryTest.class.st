Class {
	#name : 'EffectRegistryTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
EffectRegistryTest >> testAllEffectTypesReturnsCollectionOfEffectClasses [
	| effectTypes |
	effectTypes := EffectRegistry allEffectTypes.
	
	self assert: effectTypes isCollection.
	self assert: effectTypes notEmpty.
	self assert: (effectTypes includes: NoEffect).
	self assert: (effectTypes includes: CardEffect).
	self assert: (effectTypes includes: BlackHoleEffect).
	self assert: (effectTypes includes: HyperGravityEffect).
	self assert: (effectTypes includes: MoonWalkEffect).
	self assert: (effectTypes includes: HyperJumpEffect).
	self assert: (effectTypes includes: AtomicBombEffect).
]

{ #category : 'tests' }
EffectRegistryTest >> testEffectCountReturnsCorrectNumber [
	| count allEffects |
	allEffects := EffectRegistry allEffectTypes.
	count := EffectRegistry effectCount.
	
	self assert: count equals: allEffects size.
	self assert: count > 0.
]

{ #category : 'tests' }
EffectRegistryTest >> testHasEffectTypeReturnsTrueForExistingEffect [
	self assert: (EffectRegistry hasEffectType: NoEffect).
	self assert: (EffectRegistry hasEffectType: CardEffect).
	self assert: (EffectRegistry hasEffectType: BlackHoleEffect).
	self assert: (EffectRegistry hasEffectType: HyperGravityEffect).
]

{ #category : 'tests' }
EffectRegistryTest >> testHasEffectTypeReturnsFalseForNonExistingEffect [
	self deny: (EffectRegistry hasEffectType: NullEffect).
]

{ #category : 'tests' }
EffectRegistryTest >> testTotalWeightReturnsPositiveNumber [
	| totalWeight |
	totalWeight := EffectRegistry totalWeight.
	
	self assert: totalWeight > 0.
]

{ #category : 'tests' }
EffectRegistryTest >> testTotalWeightMatchesSumOfEffectDistribution [
	| distribution calculatedTotal registryTotal |
	distribution := EffectRegistry effectDistribution.
	calculatedTotal := distribution inject: 0 into: [ :sum :assoc | sum + assoc value ].
	registryTotal := EffectRegistry totalWeight.
	
	self assert: registryTotal equals: calculatedTotal.
]
