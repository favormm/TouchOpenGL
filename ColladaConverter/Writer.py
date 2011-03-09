#!/usr/bin/python

import json

import Collada
import geometries

class MyJSONEncoder(json.JSONEncoder):
	def default(self, o):
		d = {}
		if isinstance(o, Collada.ColladaObject):
			d = { 'type':o.__class__.__name__ }

			if isinstance(o, Collada.VisualScene):
				d['type'] = 'Scene'

			if isinstance(o, Collada.Matrix):
				d['v'] = o.v
			elif isinstance(o, Collada.Instance):
				d['url'] = o.url
			elif isinstance(o, Collada.Source):
				d['href'] = '%s.vbo' % (o.positions.signature.hexdigest())
			elif o.children != None and len(o.children) > 0:
				d['children'] = o.children
		else:
			return super(MyJSONEncoder, self).default(o)

		if d and hasattr(o, 'id') and o.id:
			d['id'] = o.id

		return d
