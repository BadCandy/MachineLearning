%% getMatchClassName
% Input : 
%       text : ���ǻ� �η��� ���ڷ� �ٲ� ���� ��.(1~3)
% Output :
%       className : 1~3�� ���εǴ� �η��� �̸�.
%       1 -> 'Iris-setosa'
%       2 -> 'Iris-versicolor'
%       3 -> 'Iris-virginica'
function [ className ] = getMatchClassName( text )
outputClass = '';
        if (text == '1')
            outputClass = 'Iris-setosa';
        elseif (text == '2')
            outputClass = 'Iris-versicolor';
        else
            outputClass = 'Iris-virginica'; 
        end
className = outputClass;

end

%%