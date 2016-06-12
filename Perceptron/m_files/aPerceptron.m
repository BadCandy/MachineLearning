%% Pattern Recognition Subject #03
% Write by 115881_����ö

%% aPerceptron �Լ�
% ���� : ���� �ۼ�Ʈ�� �н��� �����ϴ� ���� �Լ�
function aPerceptron
disp('----���� �ۼ�Ʈ�� �н� ����----');

classes = [0, 0, 1; 0.5, 0.5, 1; 1, 0, 1; 1, 1, 1;
    -1, 1, -1; 0, 1, -1; -1, 0, -1; -0.5, 0.5, -1];
count = 0;

% ���� �ð��� �����Ѵ�.
tic

% �н����� �����Ѵ�.
ro = 0.4;
% w1, w2�� b�� �ʱ�ȭ�Ѵ�.
w1 = 3 * rand() - 2;
w2 = 3 * rand() - 2;
b = 3 * rand() - 2;

flag = true;
while flag
    
    % Ʋ�� ������ ����
    Y = [];
    
    % �з��� �����Ѵ�. 
    for i = 1:8
        temp = classes(i, :);
        
        % ���� �������� ���� Ȱ��ȭ �Լ��� ���ڰ����� �����Ѵ�.
        y = activationFunc(w1 * temp(1) + w2 * temp(2) + b);    
        
        if (y ~= temp(3))   
            Y = [Y; temp];  %���з��� ������ �����Ѵ�.
        end
    end
    
    % ����� �׷����� ����Ѵ�.
    draw2dGraph(w1, w2, b, classes, count);
    
    tCount = 1;
    if (~isempty(Y))
        while tCount <= length(Y(:,1))
            temp = Y(tCount, :);
            w1 = w1 + ro * temp(1) * temp(3);   % ����ġ�� �����Ѵ�.
            w2 = w2 + ro * temp(2) * temp(3);
            b = b + ro * temp(3);
            tCount = tCount + 1;
        end
    end
    count = count +1;
    
    if (isempty(Y))
        flag = false;
    end
end

% ���� �ð��� �����Ѵ�.
toc

disp('�н��� : ');
disp(ro);
disp('�н� Ƚ�� : ');
disp(count);
disp('���� w1, w2, b : ');
disp([w1 w2 b]);
end