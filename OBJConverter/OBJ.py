#!/usr/bin/python

import sys
import re
import os
import plistlib
import numpy
import geometries
import collections
import pprint

########################################################################

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
		self.Ka = None #(0.2, 0.2, 0.2)
		self.Kd = None # (0.8, 0.8, 0.8)
		self.Ks = None #(1.0, 1.0, 1.0)
		self.d = 1.0
		self.Ns = 0.0
		self.illum = 2
		self.map_Ka = None
		self.map_Kd = None

	def __repr__(self):
		return('Material (%s)' % (self.name))

class Polygon(object):
	def __init__(self):
		self.material = None
		self.vertexIndices = []
		self.normalIndices = []
		self.texCoordIndices = []

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

		theCurrentMaterial = None

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
				theCurrentMaterial.Ka = [float(x) for x in theParameters.split(' ')]
			elif theVerb == 'Kd':
				theCurrentMaterial.Kd = [float(x) for x in theParameters.split(' ')]
			elif theVerb == 'Ks':
				theCurrentMaterial.Ks = [float(x) for x in theParameters.split(' ')]
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

class OBJParser(object):

	def main(self):

		theCurrentMaterialLibrary = None
		theCurrentGroups = None
		theCurrentMaterial = None

		self.vertices = []
		self.texCoords = []
		self.normals = []

		thePolygons = []

		theInputFile = file(theInputFilePath)

		theLines = [theLine for theLine in theInputFile.readlines()]
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
			if theVerb == 'mtllib':
				theMaterialFile = file(os.path.join(os.path.split(theInputFilePath)[0], theParameters))
				theParser = MTLParser(theMaterialFile)
				theCurrentMaterialLibrary = theParser.materials
			elif theVerb == 'g':
				theCurrentGroups = theParameters.split(' ')
			elif theVerb == 'usemtl':
				theCurrentMaterial = theCurrentMaterialLibrary[theParameters]
			elif theVerb == 'v':
				self.vertices.append(tuple([float(x) for x in theParameters.split(' ')]))
			elif theVerb == 'vt':
				self.texCoords.append(tuple([float(x) for x in theParameters.split(' ')]))
			elif theVerb == 'vn':
				self.normals.append(tuple([float(x) for x in theParameters.split(' ')]))
			elif theVerb == 'f':
				theVertices = []
				for theVertex in theParameters.split(' '):
					theIndices = theVertex.split('/')
					theIndices = [int(theIndex) - 1 for theIndex in theIndices]
					theVertices.append(theIndices)

				thePolygon = Polygon()
				thePolygon.material = theCurrentMaterial
				thePolygon.vertexIndices = [x[0] for x in theVertices]
				thePolygon.texCoordIndices = [x[1] for x in theVertices]
				thePolygon.normalIndices = [x[2] for x in theVertices]

				thePolygon.vertices = [self.vertices[i] for i in thePolygon.vertexIndices]
				thePolygon.texCoords = [self.texCoords[i] for i in thePolygon.texCoordIndices]
				thePolygon.normals = [self.normals[i] for i in thePolygon.normalIndices]


				thePolygons.append(thePolygon)
			else:
				print 'Unknown verb: ', theVerb

		self.polygons = thePolygons

########################################################################

theRootDir = os.path.split(sys.argv[0])[0]

theInputDirectoryPath = os.path.join(theRootDir, 'Input')

theInputFilePath = os.path.join(theInputDirectoryPath, 'StarDestroyer/StarDestroyer.obj')

theModelName = os.path.splitext(os.path.split(theInputFilePath)[1])[0]

theParser = OBJParser()
theParser.main()

########################################################################

########################################################################

theOutputDirectoryPath = os.path.join(theRootDir, 'Output', theModelName)

if not os.path.exists(theOutputDirectoryPath):
	os.makedirs(theOutputDirectoryPath)


theMax = [0, 0, 0]
theMin = [0, 0, 0]

for p in theParser.polygons:
	for v in p.vertices:
		for n in xrange(0,3):
			theMin[n] = min(theMin[n], v[n])
			theMax[n] = max(theMax[n], v[n])

print theMax
print theMin
print [(theMin[N] + theMax[N] / 2) for N in xrange(0, 3)]

d = {
	'materials': {},
	'geometries': [],
	}

theParser.polygons.sort(key = lambda X:X.material)

thePolygonsByMaterial = collections.defaultdict(list)

for p in theParser.polygons:
	thePolygonsByMaterial[p.material].append(p)

for theMaterial in thePolygonsByMaterial:

	m = dict()
	if theMaterial.Ka:
		m['ambientColor'] = theMaterial.Ka
	if theMaterial.Kd:
		m['diffuseColor'] = theMaterial.Kd
	if theMaterial.Ks:
		m['specularColor'] = theMaterial.Ks
	if theMaterial.d or theMaterial.Tr:
		m['alpha'] = theMaterial.d if theMaterial.d else theMaterial.Tr
	if theMaterial.map_Kd:
		m['texture'] = os.path.split(theMaterial.map_Kd)[1]

	d['materials'][theMaterial.name] = m

	theBuffer = []

	thePolygons = thePolygonsByMaterial[theMaterial]
	for thePolygon in thePolygons:

		# TODO assumes triangles`


		for N in xrange(0, 3):

			theVertexBuffer = []
			theVertexBuffer.append(list(thePolygon.vertices[N]))
			theVertexBuffer.append(list(thePolygon.texCoords[N]))
			theVertexBuffer.append(list(thePolygon.normals[N]))

			theBuffer.append(theVertexBuffer)

	theBuffer = list(iter_flatten(theBuffer))

	theBuffer = numpy.array(theBuffer, dtype=numpy.float32)
	theBuffer = geometries.VBO(theBuffer)
	theBuffer.write(theOutputDirectoryPath)

	d['geometries'].append(dict(material = theMaterial.name, combined = theBuffer.signature.hexdigest()))

plistlib.writePlist(d, os.path.join(theOutputDirectoryPath, '%s.plist' % theModelName))

########################################################################


# v = numpy.array(v, dtype=numpy.float32)
# fp = numpy.array(fp, dtype=numpy.int16)
#
# print v
# print fp
#
# v = geometries.VBO(v)
# v.write(theOutputDirectoryPath)
#
#
# fp = geometries.VBO(fp)
# fp.write(theOutputDirectoryPath)
#
# d = dict(indices = '%s.vbo' % (fp.signature.hexdigest()), vertices = '%s.vbo' % (v.signature.hexdigest()))
#
#
# plistlib.writePlist(d, os.path.join(theOutputDirectoryPath, '%s.plist' % theModelName))
