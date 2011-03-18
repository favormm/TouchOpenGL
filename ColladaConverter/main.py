#!/usr/bin/python


from lxml.etree import Element
from lxml import etree

import os

import Collada
from tools import *

import Writer

def main():
	theInputPath = os.getcwd()
	theOutputPath = os.path.join(os.getcwd(), 'Output')

	if not os.path.exists(theOutputPath):
		os.makedirs(theOutputPath)

#	theDocumentPath = os.path.join(theInputPath, 'WallE.dae')
#	theDocumentPath = os.path.join(theInputPath, 'Samples/Cylinder.dae')
#	theDocumentPath = os.path.join(theInputPath, 'Samples/F1.dae')
	theDocumentPath = os.path.join(theInputPath, 'Samples/Cube2.dae')

	theTree = etree.parse(theDocumentPath)
	theRootElement = OneOrThrow(theTree.xpath("/NS:COLLADA", namespaces = Collada.Parser.NS))

	theParser = Collada.Parser()

	doc = theParser.DocumentFactory(None, None, theRootElement)
	doc.dump()

	for node in doc.walk():
		if isinstance(node, Collada.Source):
			print 'Source:', node.id, node.vbo.signature.hexdigest()
			node.vbo.write(theOutputPath)
		elif isinstance(node, Collada.Mesh):
			print 'Mesh:', node.id, node.indices.signature.hexdigest()
			if node.indices:
				node.indices.write(theOutputPath)

	theLibrary = []
	for l in doc.libraries:
		theLibrary.extend(l.children)

	theLibrary = [o for o in theLibrary if not isinstance(o, Collada.VisualScene)]
	theLibrary = [o for o in theLibrary if o.id is not None]


# 	d = {
# 		'root': doc.scene.visualScene.resolve(),
# 		'library': dict([(o.id, o) for o in theLibrary]),
# 		}
#
#
# 	s = Writer.MyJSONEncoder(indent = 2).encode(d)
# 	file(os.path.join(theOutputPath, 'Output.json'), 'w').write(s)
#

if __name__ == '__main__':
	main()
