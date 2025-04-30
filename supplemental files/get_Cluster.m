function clusterNumbers = get_Cluster(varargin)
% Create a dictionary-like structure to store predefined cluster numbers
clusterDict = struct();

clusterDict.t7t8 = {'E40', 'E45', 'E46', 'E102', 'E108', 'E109'};
clusterDict.oz = {'E75', 'E70', 'E83'};
clusterDict.fcz =  {'E5', 'E6', 'E7', 'E12', 'E13', 'E106', 'E112'};
clusterDict.p8 = {'E90', 'E91', 'E95', 'E96'};
clusterDict.f7f8 =  {'E33', 'E34', 'E116', 'E122'};
clusterDict.p7 = {'E58', 'E59', 'E64', 'E65'};


% % Initialize an empty array to store the result
clusterNumbers = {};

for i = 1:length(varargin)
    cluster = varargin{i};

    % Check if the cluster exists in the dictionary and append the values
    if isfield(clusterDict, cluster)
        clusterNumbers = [clusterNumbers, clusterDict.(cluster)];  % Append the text characters individually
    else
        warning(['Cluster ', cluster, ' not recognized.']);
    end
end
end