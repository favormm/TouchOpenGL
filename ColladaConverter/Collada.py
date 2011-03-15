#!/usr/bin/python

import os

from lxml.etree import Element
from lxml import etree

import numpy
import StringIO
import urlparse
import re

import Writer

from geometries import *
from tools import *

def localname(s):
	theMatch = re.match(r'^{.+}(.+)$', s)
	if theMatch:
		return theMatch.groups()[0]
	else:
		raise Exception('No localname for %s' % s)

class RGBAColor(object):
	def __init__(self, colors = None):
		self.colors = colors

########################################################################

class ColladaObject(object):
	def __init__(self, parent = None, id = None):
		self.parent = parent
		self.id = id

	def __str__(self):
		return self.__class__.__name__

	@property
	def children(self):
		return []

	@property
	def document(self):
		return self.parent.document if self.parent else None

	@property
	def depth(self):
		o = self
		N = 0
		while o.parent != None:
			o = o.parent
			N += 1
		return N

	def dump(self, depth = 0):
		thePrefix = '  ' * depth
		print thePrefix + str(self)
		for child in self.children:
			if child:
				child.dump(depth + 1)

	def walk(self):
		yield self
		for child in self.children:
			if child:
				for n in child.walk():
					yield n

########################################################################

class Document(ColladaObject):
	namespace = 'http://www.collada.org/2005/11/COLLADASchema'
	NS = { 'NS': namespace }

	def __init__(self):
		super(Document, self).__init__()
		self.root = None
		self.scene = None
		self.library = None
		self.elementsByID = dict()
		self.objectsByID = dict()

	@property
	def children(self):
		return [self.scene] + self.libraries

	@property
	def document(self):
		return self

	def lookupElement(self, url, tag = None):
		theFragment = urlparse.urlparse(url).fragment
		theElement = self.elementsByID[theFragment]
		if tag:
			tag = '{%s}%s' % (self.namespace, tag)
			if theElement.tag != tag:
				raise Exception('Expected an element with a tag of %s, got %s instead' % (tag, theElement.tag))
		return theElement

	def lookupInstance(self, desiredTag, instanceTag, element):
		if element.tag == '{%s}%s' % (self.namespace, desiredTag):
			return element
		elif element.tag == '{%s}%s' % (self.namespace, instanceTag):
			element = self.lookupElement(element.attrib['url'], desiredTag)
			return element
		else:
			raise Exception('Could not find instance')

########################################################################

class Scene(ColladaObject):
	def __init__(self, parent, id):
		super(Scene, self).__init__(parent, id)
		self.visualScene = None

	@property
	def children(self):
		return [self.visualScene]

########################################################################

class Library(ColladaObject):
	def __init__(self, parent, id):
		super(Library, self).__init__(parent, id)
		self._children = []

	def __str__(self):
		return '%s (%s)' % (super(Library, self).__str__(), self.type)

	@property
	def children(self):
		return self._children

########################################################################

class Instance(ColladaObject):
	def __init__(self, parent, id):
		super(Instance, self).__init__(parent, id)
		self.type = None
		self.url = None

	def resolve(self):
		theFragment = urlparse.urlparse(self.url).fragment
		return self.document.objectsByID.get(theFragment)

	def __str__(self):
		return '%s (%s)' % (self.__class__.__name__, localname(self.document.lookupElement(self.url).tag))

########################################################################

class VisualScene(ColladaObject):
	def __init__(self, parent, id):
		super(VisualScene, self).__init__(parent, id)
		self.nodes = []

	@property
	def children(self):
		return self.nodes

########################################################################

class Node(ColladaObject):
	def __init__(self, parent, id):
		super(Node, self).__init__(parent, id)
		self.nodes = []
		self.transform = None
		self.geometries = []

	@property
	def children(self):
		return self.nodes + self.geometries

########################################################################

class Matrix(ColladaObject):
	def __init__(self, parent, id):
		super(Matrix, self).__init__(parent, id)
		self.v = [0] * 16

########################################################################

class Geometry(ColladaObject):
	def __init__(self, parent, id):
		super(Geometry, self).__init__(parent, id)
		self.mesh = None

	@property
	def children(self):
		return [self.mesh]

########################################################################

class Mesh(ColladaObject):
	def __init__(self, parent, id):
		super(Mesh, self).__init__(parent, id)
		self.type = None
		self.positions = None
		self.normals = None
		self.indices = None

	@property
	def children(self):
		return [self.positions, self.normals]

########################################################################

class Source(ColladaObject):
	def __init__(self, parent, id):
		super(Source, self).__init__(parent, id)

########################################################################

class Material(ColladaObject):
	pass

########################################################################

class Effect(ColladaObject):
	pass

class LambertEffect(Effect):
	def __init__(self, parent, id):
		super(Effect, self).__init__(parent, id)

		self.diffuseColor = None


########################################################################


class Parser(object):

	namespace = 'http://www.collada.org/2005/11/COLLADASchema'
	NS = { 'NS': namespace }

	def factory(x):
		def inner(self, document, parent, element):
			o = x(self, document, parent, element)
			id = element.attrib.get('id')
			if document and id:
				document.objectsByID[id] = o
			return o

		return inner

	@factory
	def ObjectFactory(self, document, parent, element):
		theFactoriesForTag = dict()
		theFactoriesForTag['{%s}%s' % (self.namespace, 'document')] = self.DocumentFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'scene')] = self.SceneFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'library')] = self.LibraryFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'visual_scene')] = self.VisualSceneFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'node')] = self.NodeFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'matrix')] = self.MatrixFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'geometry')] = self.GeometryFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'material')] = self.MaterialFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'effect')] = self.EffectFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'mesh')] = self.MeshFactory
		theFactoriesForTag['{%s}%s' % (self.namespace, 'source')] = self.SourceFactory

		if element.tag in theFactoriesForTag:
			theFactory = theFactoriesForTag[element.tag]
			theObject = theFactory(document, parent, element)
		else:
			raise Exception('Unknown tag: ', theElement.tag)

		return theObject

	@factory
	def DocumentFactory(self, document, parent, element):
		theDocument = Document()
		theDocument.elementsByID = dict((theElement.attrib['id'], theElement) for theElement in element.xpath("//NS:*[@id]", namespaces = self.NS))
		theRootElement = OneOrThrow(element.xpath("/NS:COLLADA", namespaces = self.NS))
		theElements = element.xpath("./NS:library_visual_scenes|./NS:library_geometries|./NS:library_materials|./NS:library_effects", namespaces = self.NS)
		theDocument.libraries = [self.LibraryFactory(theDocument, theDocument, theElement) for theElement in theElements]
		theSceneElement = OneOrThrow(element.xpath("/NS:COLLADA/NS:scene", namespaces = self.NS))
		theDocument.scene = self.SceneFactory(theDocument, theDocument, theSceneElement)
		return theDocument

	@factory
	def SceneFactory(self, document, parent, element):
		theScene = Scene(parent, element.attrib.get('id'))
		element = OneOrNone(element.xpath("./NS:instance_visual_scene", namespaces = self.NS))
		theScene.visualScene = self.InstanceFactory(document, theScene, element)
		return theScene

	@factory
	def LibraryFactory(self, document, parent, element):
		theLibrary = Library(parent, element.attrib.get('id'))
		theLibrary.type = localname(element.tag)
		theElements = element.xpath("./*", namespaces = self.NS)
		for theElement in theElements:
			theObject = self.ObjectFactory(document, theLibrary, theElement)
			theLibrary.children.append(theObject)
		return theLibrary

	@factory
	def InstanceFactory(self, document, parent, element):
		theInstance = Instance(parent, element.attrib.get('id'))
		theInstance.type = localname(element.tag)
		theInstance.url = element.attrib['url']
		return theInstance

	@factory
	def VisualSceneFactory(self, document, parent, element):
		theVisualScene = VisualScene(parent, element.attrib.get('id'))
		theElements = element.xpath('./NS:node|./NS:instance_node', namespaces = self.NS)
		theVisualScene.nodes = [self.NodeFactory(document, theVisualScene, element) for element in theElements]
		return theVisualScene

	@factory
	def NodeFactory(self, document, parent, element):
		theNode = Node(parent, element.attrib.get('id'))

		theMatrix = OneOrNone(element.xpath('./NS:matrix', namespaces = self.NS))
		if theMatrix is not None:
			theNode.transform = self.MatrixFactory(document, theNode, theMatrix)

		theElements = element.xpath('./NS:node|./NS:instance_node', namespaces = self.NS)
		theElements = [document.lookupInstance('node', 'instance_node', theElement) for theElement in theElements]

		theNode.nodes = [self.NodeFactory(document, theNode, theElement) for theElement in theElements]

		theElements = element.xpath('./NS:instance_geometry', namespaces = self.NS)
		theNode.geometries = [self.InstanceFactory(document, theNode, theElement) for theElement in theElements]

		return theNode

	@factory
	def MatrixFactory(self, document, parent, element):
		theMatrix = Matrix(parent, element.attrib.get('id'))
		theMatrix.v = [float(N) for N in element.text.split()]
		return theMatrix

	@factory
	def GeometryFactory(self, document, parent, element):
		theGeometry = Geometry(parent, element.attrib.get('id'))
		theGeometry.mesh = self.MeshFactory(document, parent, OneOrNone(element.xpath('./NS:mesh', namespaces = self.NS)))
		return theGeometry

	@factory
	def MeshFactory(self, document, parent, element):
		theObject = Mesh(parent, element.attrib.get('id'))

		thePrimitives = element.xpath('./NS:triangles|./NS:lines', namespaces = self.NS)
		for primitive in thePrimitives:

			theTypesByTag = {
				'{%s}triangles' % (self.namespace): 'triangles',
				'{%s}lines' % (self.namespace): 'lines',
				}
	#
			theObject.type = theTypesByTag[primitive.tag]
			theObject.indexCount = int(primitive.attrib['count'])
	#
			theIndices = OneOrThrow(primitive.xpath('./NS:p', namespaces = self.NS))
			theArray = numpy.lib.io.loadtxt(StringIO.StringIO(theIndices.text), dtype=numpy.int16)
			theObject.indices = VBO(theArray)
	#
			theURL = OneOrThrow(primitive.xpath('./NS:input[@semantic="VERTEX"]/@source', namespaces = self.NS))
			theVertices = document.lookupElement(theURL, 'vertices')
	#
			######
	#
			theURL = OneOrNone(theVertices.xpath('./NS:input[@semantic="POSITION"]/@source', namespaces = self.NS))
			if theURL:
				theSource = document.lookupElement(theURL, 'source')
				theObject.positions = self.SourceFactory(document, theObject, theSource)
	#
			######
	#
			theURL = OneOrNone(theVertices.xpath('./NS:input[@semantic="NORMAL"]/@source', namespaces = self.NS))
			if theURL:
				theSource = document.lookupElement(theURL, 'source')
				theObject.normals = self.SourceFactory(document, theObject, theSource)

		return theObject

	@factory
	def SourceFactory(self, document, parent, element):
		theObject = Source(parent, element.attrib.get('id'))
		theTechnique = OneOrThrow(element.xpath('./NS:technique_common', namespaces = self.NS))
		theAccessor = OneOrThrow(theTechnique.xpath('./NS:accessor', namespaces = self.NS))
		theURL = theAccessor.attrib['source']
		theFloatArray = document.lookupElement(theURL, 'float_array')
		theObject.count = int(theFloatArray.attrib['count'])
		theArray = numpy.lib.io.loadtxt(StringIO.StringIO(theFloatArray.text), dtype=numpy.float32)
		theObject.vbo = VBO(theArray)
		return theObject

	@factory
	def MaterialFactory(self, document, parent, element):
		theObject = Material(parent, element.attrib.get('id'))
		return theObject

	@factory
	def EffectFactory(self, document, parent, element):
		theObject = LambertEffect(parent, element.attrib.get('id'))

# 		theDiffuseColor = OneOrMoreOrThrow(element.xpath('./NS:profile_COMMON/NS:technique/NS:lambert/NS:diffuse/NS:color', namespaces = self.NS))
# 		theDiffuseColor =  [float(x) for x in theDiffuseColor.text.split(' ')]
# 		theObject.diffuseColor = RGBAColor(theDiffuseColor)

		return theObject

########################################################################
