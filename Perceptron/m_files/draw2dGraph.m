%% draw2dGraph 함수
% 내용 : 그래프를 그리는 함수
% Input :
%     w1 : 첫 번째 특징의 값
%     w2 : 두 번째 특징의 값
%     b : Bias
%     classes : 부류의 값, 여기서는 +1 또는 -1
%     location : subplot의 위치
% Output : NULL
function [] = draw2dGraph(w1, w2, b, classes, location)
    subplot(3, 3, location+1);
    str = num2str(location + 1);
    title(strcat(str, '번째 학습'));
    xlabel('x1');
    ylabel('x2');
    hold on
    grad = num2str(-1 * w1/w2);
    temp = '*x+';
    y_value = num2str(-1 * b/w2);
    exp = strcat(grad, temp, y_value);
    fplot(exp, [-2 2 -2 2]);  
    for i = 1:8
        c_temp = classes(i,:);
        if c_temp(3) == 1
            plot(c_temp(1), c_temp(2), 'marker', 'o', 'markersize', 5, 'markeredgecolor', 'm', 'markerfacecolor', 'm');
        elseif c_temp(3) == -1
            plot(c_temp(1), c_temp(2), 'marker', '^', 'markersize', 5, 'markeredgecolor', 'b', 'markerfacecolor', 'b');
        end
    end
    grid on;
    hold off;
end

