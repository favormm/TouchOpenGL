#!/usr/bin/python

def OneOrNone(sequence):
	N = len(sequence)
	if N > 1:
		raise Exception('More than one object!')
	return sequence[0] if N == 1 else None

def OneOrThrow(sequence):
	if len(sequence) != 1:
		raise Exception('Not one object!')
	return sequence[0]

def OneOrMoreOrThrow(sequence):
	if len(sequence) >= 1:
		raise Exception('Not one object! %d, %s' % (len(sequence), sequence))
	return sequence

