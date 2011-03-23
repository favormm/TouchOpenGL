#!/usr/bin/env python

import argparse # argparse was added in Python 3.2 - for earlier Pythons just install it manually (easy_install argparse)
import collections
import geometries
import glob
import logging
import numpy
import os
import plistlib
import pprint
import re
import shlex
import sys
import types

from itertools import izip_longest

logging.basicConfig(level = logging.DEBUG, format = '%(message)s', stream = sys.stderr)
logger = logging.getLogger()

########################################################################

def grouper(n, iterable, padvalue=None):
    "grouper(3, 'abcdefg', 'x') --> ('a','b','c'), ('d','e','f'), ('g','x','x')"
    return izip_longest(*[iter(iterable)]*n, fillvalue=padvalue)

def grouper_nopad(n, iterable):
    "grouper(3, 'abcdefg', 'x') --> ('a','b','c'), ('d','e','f'), ('g','x','x')"
    return izip_longest(*[iter(iterable)]*n)

def iter_flatten(iterable):
	it = iter(iterable)
	for e in it:
		if isinstance(e, (list, tuple)):
			for f in iter_flatten(e):
				yield f
		else:
			yield e

########################################################################

class Material(object):
	def __init__(self, name = None):
		self.name = name
		self.ambientColor = None #(0.2, 0.2, 0.2)
		self.diffuseColor = None # (0.8, 0.8, 0.8)
		self.specularColor = None #(1.0, 1.0, 1.0)
		self.d = 1.0
		self.Ns = 0.0
		self.illum = 2
		self.map_Ka = None
		self.map_Kd = None

	def __repr__(self):
		return('Material (%s)' % (self.name))

########################################################################

class Polygon(object):
	def __init__(self):
		self.material = None
		self.vertexIndices = [None, None, None]
		self.normalIndices = [None, None, None]
		self.texCoordIndices = [None, None]

	def __repr__(self):
		return('Polygon (%s, %s, %s, %s)' % (self.material, self.vertexIndices, self.normalIndices, self.texCoordIndices))

########################################################################

class MTLParser(object):
	def __init__(self, fp):
		theLines = fp.readlines()
		theLines = [theLine for theLine in theLines]
		theLines = [theLine.strip() for theLine in theLines]
		theLines = [theLine for theLine in theLines if len(theLine) > 0]
		theLines = [theLine for theLine in theLines if not re.match('^#.*$', theLine)]

		theCurrentMaterial = Material('default')

		theMaterials = dict()

		for theLine in theLines:
			theMatch = re.match('^([A-Za-z_]+)( +(.*))? *$', theLine)
			if not theMatch:
				print theLine
				raise Exception('Parse error')
			theVerb, theParameters = theMatch.groups()[0], theMatch.groups()[2]
			if theVerb == 'newmtl':
				theCurrentMaterial = Material(theParameters)
				theMaterials[theCurrentMaterial.name] = theCurrentMaterial
			elif theVerb == 'Ka':
				theCurrentMaterial.ambientColor = [float(x) for x in re.split(' +', theParameters)]
			elif theVerb == 'Kd':
				theCurrentMaterial.diffuseColor = [float(x) for x in re.split(' +', theParameters)]
			elif theVerb == 'Ks':
				theCurrentMaterial.specularColor = [float(x) for x in re.split(' +', theParameters)]
			elif theVerb == 'd':
				theCurrentMaterial.d = float(theParameters)
			elif theVerb == 'Ns':
				theCurrentMaterial.d = float(theParameters)
			elif theVerb == 'illum':
				theCurrentMaterial.d = int(theParameters)
			elif theVerb == 'map_Ka':
				theCurrentMaterial.map_Ka = theParameters
			elif theVerb == 'map_Kd':
				theCurrentMaterial.map_Kd = theParameters
			else:
				print 'Unknown verb: %s' % theVerb

		self.materials = theMaterials

########################################################################

class OBJParser(object):

	def __init__(self, inputFile):
		self.inputFile = inputFile

	def main(self):

		theCurrentMaterialLibrary = None
		theCurrentGroups = None
		theCurrentMaterial = None

		self.positions = []
		self.texCoords = []
		self.normals = []

		thePolygons = []

		theLines = [theLine for theLine in self.inputFile.readlines()]
		theLines = [theLine.strip() for theLine in theLines]
		theLines = [theLine for theLine in theLines if len(theLine) > 0]

		for theLine in theLines:
			theMatch = re.match('^#.*$', theLine)
			if theMatch:
				continue

			theMatch = re.match('^([a-z_]+) +(.*)$', theLine)
			if not theMatch:
				print theLine
				raise Exception('Parse error')
			theVerb, theParameters = theMatch.groups()

			try:
				if theVerb == 'mtllib':
					theMaterialFile = file(os.path.join(os.path.split(self.inputFile.name)[0], theParameters))
					theParser = MTLParser(theMaterialFile)
					theCurrentMaterialLibrary = theParser.materials
				elif theVerb == 'g':
					theCurrentGroups = theParameters.split(' ')
				elif theVerb == 'usemtl':
					theCurrentMaterial = theCurrentMaterialLibrary[theParameters]
				elif theVerb == 'v':
					self.positions.append(tuple([float(x) for x in re.split(' +', theParameters)]))
				elif theVerb == 'vt':
					self.texCoords.append(tuple([float(x) for x in re.split(' +', theParameters)]))
				elif theVerb == 'vn':
					self.normals.append(tuple([float(x) for x in re.split(' +', theParameters)]))
				elif theVerb == 'f':
					theVertices = []
					for theVertex in re.split(' +', theParameters):
						theIndices = theVertex.split('/')
						theIndices = [int(theIndex) - 1 for theIndex in theIndices]
						if len(theIndices) == 1:
							theIndices += [None, None]
						elif len(theIndices) == 2:
							theIndices += [None]

						theVertices.append(theIndices)

#					assert(len(theVertices) == 3)

					thePolygon = Polygon()
					thePolygon.material = theCurrentMaterial
					thePolygon.vertexIndices = [x[0] for x in theVertices]
					thePolygon.texCoordIndices = [x[1] for x in theVertices]
					thePolygon.normalIndices = [x[2] for x in theVertices]

					thePolygon.positions = [self.positions[i] for i in thePolygon.vertexIndices]
					thePolygon.texCoords = [self.texCoords[i] for i in thePolygon.texCoordIndices if i]
					thePolygon.normals = [self.normals[i] for i in thePolygon.normalIndices if i]


					thePolygons.append(thePolygon)
				else:
					print 'Unknown verb: ', theVerb
			except:
				print 'Failed on line:'
				print theLine
				raise

		self.polygons = thePolygons

########################################################################

class Tool(object):
	@property
	def argparser(self):
		if not hasattr(self, '_argparser'):
			argparser = argparse.ArgumentParser()
			argparser.add_argument('-i', '--input', action='store', dest='input', type=argparse.FileType(), default = None, metavar='INPUT',
				help='The input file (type is inferred by file extension).')
			argparser.add_argument('--input-type', action='store', dest='input_type', type=str, metavar='INPUT_TYPE',
				help='The input file type (overides file extension if any).')
			argparser.add_argument('-o', '--output', action='store', dest='output', type=argparse.FileType('w'), default = None, metavar='OUTPUT',
				help='Output directory for generated files.')
			argparser.add_argument('--output-type', action='store', dest='output_type', type=str, metavar='INPUT_TYPE',
				help='The output file type (overides file extension if any).')
			argparser.add_argument('--pretty', action='store_const', const=True, default=False, metavar='PRETTY',
				help='Prettify the output (where possible).')

			argparser.add_argument('-v', '--verbose', action='store_const', dest='loglevel', const=logging.INFO, default=logging.WARNING,
				help='set the log level to INFO')
			argparser.add_argument('--loglevel', action='store', dest='loglevel', type=int,
				help='set the log level, 0 = no log, 10+ = level of logging')
			argparser.add_argument('--logfile', dest='logstream', type = argparse.FileType('w'), default = sys.stderr, action="store", metavar='LOG_FILE',
				help='File to log messages to. If - or not provided then stdout is used.')

			argparser.add_argument('args', nargs='*')
			self._argparser = argparser
		return self._argparser

	def parse(self):
		pass

	def main(self, args):

		self.options = self.argparser.parse_args(args = args)

		for theHandler in logger.handlers:
			logger.removeHandler(theHandler)

	#	logger.setLevel(self.options.loglevel)
		logger.setLevel(logging.DEBUG)

		theHandler = logging.StreamHandler(self.options.logstream)
		logger.addHandler(theHandler)

		# TODO this is to get around a strange argparse issue if we have no args.
# 		if self.options.args == list('transmogrifier'):
# 			self.options.args = []

		theParser = OBJParser(self.options.input)
		theParser.main()

		#### Produce min/max vertices and center vertex
		theMax = [0, 0, 0]
		theMin = [0, 0, 0]
		for p in theParser.polygons:
			for v in p.positions:
				for n in xrange(0,3):
					theMin[n] = min(theMin[n], v[n])
					theMax[n] = max(theMax[n], v[n])
		theCenter = [(theMin[N] + theMax[N]) * 0.5 for N in xrange(0, 3)]

		####

		d = {
			'buffers': {},
			'geometries': [],
			'materials': {},
			'center': theCenter,
			'boundingbox': [theMin, theMax],
			}

		theParser.polygons.sort(key = lambda X:X.material)

		thePolygonsByMaterial = collections.defaultdict(list)

		for p in theParser.polygons:
			thePolygonsByMaterial[p.material].append(p)

		#### Process materials
		for theMaterial in thePolygonsByMaterial:
			m = dict()
			if theMaterial:
				if theMaterial.ambientColor:
					m['ambientColor'] = theMaterial.ambientColor
				if theMaterial.diffuseColor:
					m['diffuseColor'] = theMaterial.diffuseColor
				if theMaterial.specularColor:
					m['specularColor'] = theMaterial.specularColor
				if theMaterial.d or theMaterial.Tr:
					m['alpha'] = theMaterial.d if theMaterial.d else theMaterial.Tr
				if theMaterial.map_Kd:
					m['texture'] = os.path.split(theMaterial.map_Kd)[1]
				d['materials'][theMaterial.name] = m

		#### Process meshes
		for theMaterial in thePolygonsByMaterial:

			thePolygons = thePolygonsByMaterial[theMaterial]

			for theSubpolygons in grouper(10000, thePolygons):
				theBuffer = []

				for thePolygon in theSubpolygons:
					if thePolygon:
						# TODO assumes triangles`
						for N in xrange(0, 3):
							theVertexBuffer = []
							theVertexBuffer.append(list(thePolygon.positions[N]))
							theVertexBuffer.append(list(thePolygon.texCoords[N] if N < len(thePolygon.texCoords) else (0.0,0.0)))
							theVertexBuffer.append(list(thePolygon.normals[N] if N < len(thePolygon.normals) else (0.0, 0.0, 0.0)))
							theBuffer.append(theVertexBuffer)

				theBuffer = list(iter_flatten(theBuffer))

				theBuffer = numpy.array(theBuffer, dtype=numpy.float32)
				theBuffer = geometries.VBO(theBuffer)
				theBuffer.write(os.path.split(self.options.output.name)[0])

				d['buffers'][theBuffer.signature.hexdigest()] = dict(target = 'GL_ARRAY_BUFFER', usage = 'GL_STATIC_DRAW', href = '%s.vbo' % (theBuffer.signature.hexdigest()))

				thePositions = dict(
					buffer = theBuffer.signature.hexdigest(),
					size = 3,
					type = 'GL_FLOAT',
					normalized = False,
					offset = 0,
					stride = 8 * 4, # TODO hack
					)
				theTexCoords = dict(
					buffer = theBuffer.signature.hexdigest(),
					size = 3,
					type = 'GL_FLOAT',
					normalized = False,
					offset = 3 * 4, # TODO hack
					stride = 8 * 4, # TODO hack
					)
				theNormals = dict(
					buffer = theBuffer.signature.hexdigest(),
					size = 2,
					type = 'GL_FLOAT',
					normalized = False,
					offset = 6 * 4, # TODO hack
					stride = 8 * 4, # TODO hack
					)

				theGeometry = dict(
					positions = thePositions,
					texCoords = theTexCoords,
					normals = theNormals,
					)

				d['geometries'].append(theGeometry)


# 			if theMaterial:
# 				theMesh['material'] = theMaterial.name

		plistlib.writePlist(d, self.options.output)

		########################################################################

if __name__ == '__main__':

	theRootDir = os.path.split(sys.argv[0])[0]
	if theRootDir:
		os.chdir(theRootDir)

#	Tool().main(shlex.split('tool --input Input/Skull.obj --output Output/Skull.model.plist'))
	Tool().main(shlex.split('tool --input Input/Skull2/Skull2.obj --output Output/Skull2.model.plist'))
