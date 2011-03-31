#!/usr/bin/python

import hashlib
import plistlib
import numpy
import os

class VBO(object):
	def __init__(self, array):
		self.array = array
		self._buffer = None
		self._signature = None

	@property
	def buffer(self):
		if not self._buffer:
			self._buffer = numpy.getbuffer(self.array)
		return self._buffer

	@property
	def signature(self):
		if not self._signature:
			self._signature = hashlib.md5(self.buffer)
		return self._signature

	def write(self, path):
		f = file(os.path.join(path, '%s.vbo' % self.signature.hexdigest()), 'w')
		f.write(self.buffer)
