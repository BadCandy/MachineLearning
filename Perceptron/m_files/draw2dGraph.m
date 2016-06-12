%% draw2dGraph �Լ�
% ���� : �׷����� �׸��� �Լ�
% Input :
%     w1 : ù ��° Ư¡�� ��
%     w2 : �� ��° Ư¡�� ��
%     b : Bias
%     classes : �η��� ��, ���⼭�� +1 �Ǵ� -1
%     location : subplot�� ��ġ
% Output : NULL
function [] = draw2dGraph(w1, w2, b, classes, location)
    subplot(3, 3, location+1);
    str = num2str(location + 1);
    title(strcat(str, '��° �н�'));
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

