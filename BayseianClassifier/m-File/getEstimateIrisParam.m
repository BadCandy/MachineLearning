%% getEstimateIrisParam
% 훈련을 위해 iris_training.data를 사용한다.
% Input : void
% Output :
%        dataMap : 부류의 이름을 Key로, 
%                  평균, 공분산, 사전확률을 담은 배열이 Value로 
%                  정의된 컨테이너 Map.

function [ dataMap ] = getEstimateIrisParam

f = fopen('iris_training.data');
trainData = textscan(f,'%f %f %f %f %s', 'delimiter',',');

nf = 4;
data = cell2mat(trainData(:,1:4));
nData = size(data,1);
tData = trainData{:,5};
text=[];
for k=1:75
    if strcmp('Iris-setosa',tData(k,1))
        text=[text;'1'];
    elseif strcmp('Iris-versicolor',tData(k,1))
        text=[text;'2'];
    else
        text=[text;'3'];
    end
end
classes = ['1','2','3'];
[m,n] = size(classes);
dataMap = containers.Map;

for i = 1:n
    
    index = find(text(:,1)==classes(i));
    featureVectors = data(index,:);
    
    % computing mean and covariance foreach class
    imean = mean(featureVectors);
    icov = cov(featureVectors);
    ikey = classes(i);
    
    % compute prior
    nC = size(index,1);
    
    % prior container
    iprior = nC/nData;
    priorC = ones(nf,1);
    priorC(1,1) = iprior;
    
    ivalue = [imean' icov priorC];
    
    % put new value into objMap
    newMap = containers.Map(ikey,ivalue);
    dataMap = [dataMap; newMap];
    
end
end
%%
