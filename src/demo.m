
% Copyright 2025 Netabolics SRL | Mauro DiNuzzo <mauro@netabolics.ai>


%% Initialization

% Move to the toolbox folder (we assume it is not on the MATLAB path)
ToolboxPath = "/home/mauro/Netabolics/toolbox/matlab";
cd(ToolboxPath);

init__();

% Move back to the demo folder
DemoPath = "/home/mauro/Netabolics/demo";
cd(DemoPath);

% Add the Netabolics namespace to the current import list
import Netabolics.*


%% Preparation

% Load human cell template model
Filename = "../datasets/Cell.mat";
if exist(Filename,"file")
    Cell = Biology.Model(Filename);
else
    Cell = Biology.Template.Model("generic-10.22.89");
    Cell.saveMat(Filename);
end

% Define healthy phenotype
Filename = "../datasets/Healthy.mat";
if exist(Filename,"file")
    Healthy = Biology.Phenotype(Cell,Filename);
else
    Healthy = Biology.Template.Phenotype(Cell,"Tissue/OncoDB/DGE/COAD/normal");
    Healthy.saveMat(Filename);
end

% Define diseased phenotype    
Filename = "../datasets/Diseased.mat";
if exist(Filename,"file")
    Diseased = Biology.Phenotype(Cell,Filename);
else
    Diseased = Biology.Template.Phenotype(Cell,"Tissue/OncoDB/DGE/COAD/cancer");
    Diseased.saveMat(Filename);
end

% Define therapy and treated phenotype
Filename = "../datasets/Treated.mat";
if exist(Filename,"file")
    Treated = Biology.Phenotype(Cell,Filename);
else
    Therapy = Biology.Template.Drug(["aspirin","genistein"]);
    Treated = Therapy.phenotype(Cell,"../datasets/TreatedSample.dat");
    Treated.saveMat(Filename);
end


%% Plot model

Cell.plot(EdgeAlpha=0.2,Layout="force",UseGravity=true);


%% Simulation

Scenario = Biology.Simulation(Cell,[Healthy,Diseased,Treated]);
Scenario.solve();

data = array2table(Scenario.Solution.species(:,[1,end]), ...
    VariableNames=["Healthy","Diseased"]);
writetable(data,'../results/species.csv','WriteVariableNames',true);


%% Plot time-courses

figure(Color="w");
count = 0;
for i = 1:40 % Selected
    count = count+1;
    subplot(4,10,count);
    Scenario.plot(i);
    if (i>1)
        legend off
    end
end


%% Info

struct2table(Scenario.Statistics.process(1:10))

Table = splitvars(struct2table(Scenario.Statistics.process));
Table.Change = Table.Mean_2-Table.Mean_1;

sortrows(Table,"Change","descend")


%% Heuristic search 

Drugs = Biology.Template.Drug( ...
    [   "aspirin", ...      % rxcui:1191
        "genistein", ...    % rxcui:25696
        "vemurafenib", ...  % rxcui:1147220
        "paclitaxel", ...   % rxcui:56946
        "erlotinib", ...    % rxcui:337525
        "azacitidine", ...  % rxcui:1251
        "disulfiram", ...   % rxcui:3554
        "cytaribine" ...    % rxcui:3041
    ]);

Task = AI.Agent(Diseased,Healthy,Drugs);
searchInfo = Task.search();

for i = 1:numel(searchInfo)
    Table = table(searchInfo(i).Sequences',searchInfo(i).Rewards', ...
        VariableNames=["Drug","Reward"]);
    Table.Drug = cell2mat(Table.Drug);
    writetable(Table,sprintf('../results/search/sequence_%d.txt',i),'WriteRowNames',true);
end
