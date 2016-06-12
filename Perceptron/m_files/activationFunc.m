%% activationFunc 함수
% 내용 : 활성화 함수를 구현
% Input :
%    value : 인자 값
% Output :
%    result : value를 인자로 하는 활성화 함수 결과 값
function[result] = activationFunc(value)
	if value >= 0
        result = +1;
    else
        result = -1;
    end 
end
