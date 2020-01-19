#
# Some utility functions for the pipelines 
# Author: cdeck3r
#

import os
import collections

# src: https://stackoverflow.com/a/2158532
def flatten(l):
    for el in l:
        if isinstance(el, collections.Iterable) and not isinstance(el, (str, bytes)):
            yield from flatten(el)
        else:
            yield el

def flatten_list(l):
    return list(flatten(l))

# Creates the os path
# from concatenated YAML sequences
def os_path(p):
    return os.path.join(*flatten_list(p))
