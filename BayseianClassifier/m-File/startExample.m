% id : 115881
% Fullname: 정 윤 철
% PR Homework #2: Bayesian Decision Making 
% Using UCI data
%% startExample
% 1. 모수들을 추정한다.
% 2. 특징 벡터들을 분류한다.
% 3. 분류한 정보들을 출력한다.
function startExample

    tic % mark start time   
    disp('IRIS RECOGNITION USING BAYESIAN DECISION MAKING - TESTING WITH UCI DATA');

    % estimate parameter from trainning data
    [dataMap] = getEstimateIrisParam;

    % calling irisRecTest function to test for data in iris_testing.data
    [failedCount,accuracy] = irisRecTest(dataMap);
    
    % display information
    fprintf('Result:\n');
    fprintf('Failed: %d\n',failedCount);
    fprintf('Accuracy: %0.2f%%\n',accuracy);
    fprintf('Refer to ./result.txt and ./report.txt for more information\n');
 
    toc % show processing time

end

%% Iris RegTest
% Run test for data from iris_testing.data [75 records]
% Input: 
%    objMap: a map with keys as class name (ex:Iris-setosa, Iris-versicolor, Iris-virginica) and value as miu
%    and covariance
% Output:
%   failedCount: number of failed test-case
%   accuracy: accuracy rate of this test suite.
%   Output file:
%   - ./result.txt: result foreach test vectors on format 
%   'Index, ExpectedClass, OutputClass, Probability'
%   - ./report.txt: summarize accuracy rate for-each class on format
%   'Index, ClassName, NumOfInstance , Accuracy'
%   - ./resTable.txt: summarize number of passed and failed case for-each
%   class

function [failedCount,accuracy] = irisRecTest(dataMap)

    %%read test data
    f = fopen('iris_testing.data');
    
    classes = ['1','2','3'];
    nClass = size(classes,2);
    trainData = textscan(f,'%f %f %f %f %s', 'delimiter',',');
    fclose(f);
    failedCount = 0;

    data = cell2mat(trainData(:,1:4));
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
    
    [m,n] = size(data);
    nCountFailed = zeros(1,nClass);
    resTable = zeros(nClass);
    
    % print result of each record data to result.txt
    fo1 = fopen('result.txt','w');
    fprintf(fo1,'IRIS CLASSIFICATION RESULT\n');
    fprintf(fo1,'Format: Index, ExpectedClass, OutputClass, Probability\n');
    %% calculate probabilty of test data
    for i = 1:m
        tData = text(i);
        xf = data(i,:);
        % calling letter recognition function
        [px,class] = classifyFeatureVector(double(xf),dataMap);
        
        % find index of %class in %classes
        ind2 = find(classes(1,:)==class);
        index2 = ind2(1,1);
        index1 = index2;

        % print result to file
        expectedClass = getMatchClassName(tData);
        outputClass = getMatchClassName(class);
        fprintf(fo1,'\n%d ,%s , %s, 0.2%f', i, expectedClass, outputClass, px);
        
        % compare output and expected output
        if(strcmp(class,tData) == 0)
            failedCount = failedCount + 1;
            ind1 = find(classes(1,:)==tData);
            index1 = ind1(1,1);
            nCountFailed(1,index1) = nCountFailed(1,index1)+1;
            fprintf(fo1,', Failed');

        end
                    
        % update to resTable
        resTable(index1,index2) = resTable(index1,index2)+1;
    end
    fclose(fo1);
   
    %% print summary result to file
    fo2 = fopen('report.txt','w');
    fprintf(fo2,'IRIS CLASSIFICATION USING BAYESIAN DECISION MAKING REPORT\n');
    fprintf(fo2,'Data UCI\n');
    fprintf(fo1,'형식: Index, ClassName, NumOfInstance , Accuracy\n');
    for i=1:nClass
        numInstances = size(find(text(:,1)==classes(1,i)),1);
        expectedClass = getMatchClassName(classes(i));
        summary(1,i) = (numInstances-nCountFailed(1,i))*100/numInstances;
        fprintf(fo1,'%d, %s, %d, %0.2f%%\n',i,expectedClass,numInstances,summary(1,i));
    end
    fclose(fo2);
    accuracy = (m-failedCount)*100/m;   
%% print resTable to file
    fo3 = fopen('resTable.txt','w');
    fprintf(fo3,'%d\t%d\t%d\n',resTable');
    fclose(fo3);

end