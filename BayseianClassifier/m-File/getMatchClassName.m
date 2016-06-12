%% getMatchClassName
% Input : 
%       text : 편의상 부류를 숫자로 바꿔 놓은 값.(1~3)
% Output :
%       className : 1~3에 매핑되는 부류의 이름.
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