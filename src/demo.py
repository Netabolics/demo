
# Python3.9 (Python3.12 is required for MATLAB2025a)
# $ export LD_LIBRARY_PATH=/usr/local/MATLAB/R2024b/bin/glnxa64/
# $ python3 -m pip install matlabengine==24.2

import matlab.engine

eng = matlab.engine.start_matlab()

# Move to the toolbox folder
ToolboxPath = "/home/mauro/Netabolics/toolbox/matlab"
eng.cd(ToolboxPath,nargout=0)

eng.init__()

# Move back to the demo folder
DemoPath = "/home/mauro/Netabolics/demo"
end.cd(DemoPath,nargout=0)

# Test loading model
eng.eval("Cell = Netabolics.Biology.Model('../datasets/Cell.mat')",nargout=0)
eng.eval("disp(Cell)",nargout=0)

# Test passing object
cell = eng.workspace["Cell"]
