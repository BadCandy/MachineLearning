%% classifyFeatureVector
% Input :
%       featureVector : Ư¡ ����.
%       dataMap : getEstimateIrisParam �Լ��� ��ȯ �� ���.
% output :
%       px : Ư¡ ���Ͱ� �� �η��� ���� �ִ� Ȯ��.
%       class : �η� �̸�.
function [px,class] = classifyFeatureVector(featureVector, dataMap)
    
    pxMax = 0;
    xf = featureVector';
    [n,t] = size(xf);
    
    % parameters
    prior = 0;
    evidence = 0;
    pdf = [];
    % foreach class via key list of objMap
    for k = keys(dataMap)
               
        % compute likelihood
        % get mean and cov from objMap
        ivalue = cell2mat(values(dataMap,k));
        imean = ivalue(:,1);
        icov = ivalue(:,2:n+1);                                            
        ipdf = 1/(power(2*pi,n/2)*power(det(icov),0.5))*exp((-0.5)*((xf-imean)'*inv(icov)*(xf-imean)));
        % prior
        iprior = double(ivalue(1,n+2));
        class = double(cell2mat(k));
        pdf = [pdf ;class ipdf iprior];
        % computre evidence
        evidence = evidence+ipdf*iprior;
        
    end
    
    for k = keys(dataMap)
        ipx = 0;
        % compute probabilty of xfeature belong to class k: posterior
        i = find(pdf(:,1)==double(cell2mat(k)));
        ipx = pdf(i,2)*pdf(i,3)/evidence;
        
        if(ipx > pxMax)
            class = cell2mat(k);
            pxMax = ipx;
            prior = iprior;
        end
    end
    px = pxMax;
end
