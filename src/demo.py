
# Copyright 2020-2025 Netabolics SRL | Mauro DiNuzzo <mauro@netabolics.ai>


# This script tests calling Netabolics MATLAB toolbox from Python.
# Requirements: Python3.12 and MATLAB2025a
#
# Install matlabengine==25.1 
#   $ cd /usr/local/MATLAB/R2025a/extern/engines/python
#   $ sudo python3 setup.py install
#
# Launch
#   $ cd /path-to/demo
#   $ python3 -i demo.py


import matlab.engine

MATLAB = matlab.engine.start_matlab()

# Move to the toolbox folder
ToolboxPath = "/home/mauro/Netabolics/toolbox/matlab"
MATLAB.cd(ToolboxPath,nargout=0)

MATLAB.eval("init__()",nargout=0)

# Move back to the demo folder
DemoPath = "/home/mauro/Netabolics/demo"
MATLAB.cd(DemoPath,nargout=0)

# Loading model
cell = MATLAB.Netabolics.Biology.Model("datasets/Cell.mat")

# Display Python variable
print(cell) 
# <matlab.object object at 0x790f9684fef0> 

# Copy object into MATLAB workspace
MATLAB.workspace["Cell"] = cell 

# Display Matlab variable
MATLAB.eval("disp(Cell)",nargout=0)

# Display the SBML property 
MATLAB.eval("disp(Cell.SBML)",nargout=0)
# This should output something like: 
#              typecode: 'SBML_MODEL'
#                metaid: '_NTBL_R20250303190144'
#                 notes: ''
#            annotation: ''
#            SBML_level: 3
#          SBML_version: 1
#                  name: 'Human Genome-Scale Generic Biological Network'
#                    id: 'NTBL_R20250303190144'
#               sboTerm: -1
#    functionDefinition: [1×0 struct]
#        unitDefinition: [1×0 struct]
#           compartment: [1×1 struct]
#               species: [1×21754 struct]
#             parameter: [1×0 struct]
#     initialAssignment: [1×0 struct]
#                  rule: [1×0 struct]
#            constraint: [1×0 struct]
#              reaction: [1×88643 struct]
#                 event: [1×0 struct]
#            namespaces: [1×0 struct]
#                     S: [21754×88643 double]
#               cvterms: [1×2 struct]
#            identifier: [1×1 struct]

