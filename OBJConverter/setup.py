
from setuptools import setup, find_packages

# http://docs.python.org/distutils/setupscript.html#additional-meta-data

setup(
	name = 'OBJConverter',
	version = '0.1.0dev',

	install_requires = ['argparse >= 1.1', 'numpy'],
	packages = find_packages(exclude = [ 'ez_setup', 'Input' ]),
	include_package_data = True,
	scripts = ['scripts/OBJConverter'],
	zip_safe = False,
	author = 'Jonathan Wight',
	author_email = 'jwight@mac.com',
	classifiers = [
		'Development Status :: 3 - Alpha',
		'Intended Audience :: Developers',
		'License :: OSI Approved :: BSD License',
		],
	description = 'TODO',
	license = 'BSD License',
	long_description = file('README.markdown').read(),
	url = 'http://github.com/TODO/TODO',
	)

