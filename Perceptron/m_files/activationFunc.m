%% activationFunc �Լ�
% ���� : Ȱ��ȭ �Լ��� ����
% Input :
%    value : ���� ��
% Output :
%    result : value�� ���ڷ� �ϴ� Ȱ��ȭ �Լ� ��� ��
function[result] = activationFunc(value)
	if value >= 0
        result = +1;
    else
        result = -1;
    end 
end
