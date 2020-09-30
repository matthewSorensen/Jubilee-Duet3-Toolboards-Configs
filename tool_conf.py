import os.path
import json
from copy import deepcopy
from jinja2 import Environment, FileSystemLoader



def dictmerge(a,b):
    """ Recursive dictionary merge, giving precedence to the second argument """
    ret = {}
    for k,v in a.items():
        if not k in b:
            ret[k] = v
        else:
            # Now we have a key in a and b...time for a battle royale!
            adict, bdict = isinstance(v,dict),isinstance(b[k],dict)
            if adict and bdict:
                ret[k] = dictmerge(v,b[k])
            else:
                ret[k] = deepcopy(b[k])
    for k,v in b.items():
        if k not in ret:
            ret[k] = deepcopy(v)
        # Otherwise, it we already merged it
    return ret


with open("tools.json", "r") as f:
    blob = json.load(f)
default = blob['defaults']

env = Environment(loader= FileSystemLoader("templates"))
templates = ["tpre.g","tfree.g", "tpost.g"]


for k, v in blob['tools'].items():
    values = dictmerge(default, v)
    values['number'] = int(k)


    for temp in templates:
        t, ext = os.path.splitext(temp)
        
        with open(os.path.join('sys', t + k + ext), 'w') as fp:
            fp.write(env.get_template(temp).render(**values))
