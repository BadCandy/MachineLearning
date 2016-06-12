%% Pattern Recognition Subject #03
% Write by 115881_정윤철

%% aPerceptron 함수
% 내용 : 단일 퍼셉트론 학습을 시작하는 실행 함수
function aPerceptron
disp('----단일 퍼셉트론 학습 시작----');

classes = [0, 0, 1; 0.5, 0.5, 1; 1, 0, 1; 1, 1, 1;
    -1, 1, -1; 0, 1, -1; -1, 0, -1; -0.5, 0.5, -1];
count = 0;

% 시작 시간을 설정한다.
tic

% 학습률을 지정한다.
ro = 0.4;
% w1, w2와 b를 초기화한다.
w1 = 3 * rand() - 2;
w2 = 3 * rand() - 2;
b = 3 * rand() - 2;

flag = true;
while flag
    
    % 틀린 샘플의 집합
    Y = [];
    
    % 분류를 수행한다. 
    for i = 1:8
        temp = classes(i, :);
        
        % 구한 방정식의 값을 활성화 함수에 인자값으로 전달한다.
        y = activationFunc(w1 * temp(1) + w2 * temp(2) + b);    
        
        if (y ~= temp(3))   
            Y = [Y; temp];  %오분류된 샘플을 수집한다.
        end
    end
    
    % 선들과 그래프를 출력한다.
    draw2dGraph(w1, w2, b, classes, count);
    
    tCount = 1;
    if (~isempty(Y))
        while tCount <= length(Y(:,1))
            temp = Y(tCount, :);
            w1 = w1 + ro * temp(1) * temp(3);   % 가중치를 갱신한다.
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

% 끝난 시간을 지정한다.
toc

disp('학습률 : ');
disp(ro);
disp('학습 횟수 : ');
disp(count);
disp('최종 w1, w2, b : ');
disp([w1 w2 b]);
end