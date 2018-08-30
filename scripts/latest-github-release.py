# Will take some JSON data from stdin representing the latest
# release info from the github API and will search through the
# "assets" until the first one if found with a name that matches
# the regex given as the first argument (which must match the
# entire asset name).  Upon finding such a name it will print it
# stdout then exit; otherwise, raises an exception.
import json, fileinput, re, sys

regex = '^%s$' % sys.argv[1]
sys.argv = [] # in order to get fileinput to read from stdin.

body = '\n'.join( line for line in fileinput.input() )

obj = json.loads( body )

for asset in obj['assets']:
    if re.match( regex, asset['name'] ):
        print asset['browser_download_url']
        exit( 0 )

raise Exception( 'failed to find asset name that matches regex: %s' % regex )
