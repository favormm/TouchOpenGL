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
			elif isinstance(o, Collada.Mesh):
				d['type'] = o.type
				if o.indices:
					d['indices'] = '%s.vbo' % (o.indices.signature.hexdigest())
				if o.positions:
					d['positions'] = '%s.vbo' % (o.positions.vbo.signature.hexdigest())
				if o.normals:
					d['normals'] = '%s.vbo' % (o.normals.vbo.signature.hexdigest())
			elif isinstance(o, Collada.Instance):
				d['url'] = o.url
			elif o.children != None and len(o.children) > 0:
				d['children'] = o.children
		else:
			return super(MyJSONEncoder, self).default(o)

		if d and hasattr(o, 'id') and o.id:
			d['id'] = o.id

		return d
