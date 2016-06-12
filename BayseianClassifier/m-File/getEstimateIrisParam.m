%% getEstimateIrisParam
% �Ʒ��� ���� iris_training.data�� ����Ѵ�.
% Input : void
% Output :
%        dataMap : �η��� �̸��� Key��, 
%                  ���, ���л�, ����Ȯ���� ���� �迭�� Value�� 
%                  ���ǵ� �����̳� Map.

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
