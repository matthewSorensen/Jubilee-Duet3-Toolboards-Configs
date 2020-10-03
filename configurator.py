import os.path
import json
from copy import deepcopy
from jinja2 import Environment, FileSystemLoader
import sys
from collections import defaultdict
from functools import reduce

def dictmerge(a,b):
    """ Recursive dictionary merge, giving precedence to the second argument """
    ret = {}
    for k,v in a.items():
        if not k in b:
            ret[k] = deepcopy(v)
        else:
            # Now we have a key in a and b...time for a battle royale!
            adict, bdict = isinstance(v,dict),isinstance(b[k],dict)
            if adict and bdict:
                ret[k] = dictmerge(v,b[k])
            elif isinstance(v,list) and isinstance(b[k],list):
                ret[k] = deepcopy(v) + deepcopy(b[k])
            else:   
                ret[k] = deepcopy(b[k])
    for k,v in b.items():
        if k not in ret:
            ret[k] = deepcopy(v)
        # Otherwise, it we already merged it
    return ret


def transpose_lists(lists):

    for i in range(len(lists[0])):
        for j in lists:
            yield j[i]


def collate_axes(blob):

    axes = defaultdict(lambda: ({},[]))
    have_axis = set()
    
    for axis in blob['axes']:
        name = axis['name']
        have_axis.add(name)
        prev, rest = axes[name]
        merged = None
        if 'merge' in axis:
            merged = {}
            for ax in axis['merge']:
                if not ax in have_axis:
                    print(f"""Axis '{ax}' undefined in declaration of '{name}'""")
                    return
                merged = dictmerge(merged, axes[ax][0])
            merged = dictmerge(merged,axis)
        else:
            merged = dictmerge(prev, axis)
        axes[name] = merged, rest + [merged]

    ret = dict()
    for k,(_,v) in axes.items():
        ret[k] = v

    return ret

# we should also normalize and check for collisions among drivers
def generate_gcodes(name,axis):

    def values(key):
        values = list(str(x[key]) for x in axis)

        if name == 'E' or key == 'driver':
            return ':'.join(values)
        
        if any(x != values[0] for x in values):
           print(f"""RRF doesn't support multiple values for {key} on axis {name}""")
           exit()

        return values[0]

    def mcode(number,key):
        return f"M{number} {name}{values(key)}"

    def drivermode(driver):
        chop, invert = "", "S0"
        if 'chopmode' in driver:
            chop = 'D' + str(driver['chopmode'])
        if 'invert' in driver and driver['invert']:
            invert = 'S1'
        
        return f"M569 {chop} {invert}"
    
    
    return {'driver_declarations' : [[mcode(584, "driver"),'\n'.join(drivermode(d) for d in axis)]],
            'axis_configurations' : [[mcode(350, "microsteps") + ' I1',mcode(906, "current"),mcode(201, 'acceleration'),
                                  mcode(203, "velocity"), mcode(566,"jerk"), mcode(92, "steps/mm")]]}
    

def comments():
    return {'driver_declarations' : [["; Assign drivers to axes", "; Configure direction (S0/1) and chopping mode (Dn)"]],
            'axis_configurations' : [["; Set driver microstepping and interpolation", "; Set current limits",
                                    "; Set acceleration limits","; Set velocity limits", "; Set jerk limits", "; Set steps/mm"]]}

if __name__ == "__main__":


    blobs = {}

    for x in sys.argv[1:]:
        with open(x) as f:
            blobs = dictmerge(blobs, json.load(f))

    axes = reduce(dictmerge,(generate_gcodes(k,v) for k,v in collate_axes(blobs).items()), comments())
    env = Environment(loader= FileSystemLoader("templates"))

    values = {k : '\n'.join(transpose_lists(v)) for k,v in axes.items()}

    print(env.get_template("config.g").render(**values))
    
