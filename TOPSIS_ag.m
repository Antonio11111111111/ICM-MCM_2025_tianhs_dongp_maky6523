% @author: tianhs6523
% @date: Jan 11th, 2025
% 这个文件提供了TOPSIS的基本算法还有一些可选择的可视化表达，
% 包含条形图（个人认为不太好看），散点图，雷达图。
%% TOPSIS
data = [2 1 3 2;
        4 3 2 5;
        3 2 4 2;
        1 4 5 8];

% 每个属性的权重
weights = [0.1, 0.3, 0.2, 0.4]; % 这个根据比赛需要调整

% 正向化处理
data_positive = positivization(data, 'reversing', [1 2], 'centering', [3 4]);
%这个函数调用方法如下：
% 如果是反向化，则reversing，后面用一个向量指定相应的列，中间化指标centering,同理，但是，
% 如果中间指标最好的不是平均值，则需要自己进行处理，相应的函数为Min2Max(x,best)
% 标准化处理
data_normalized = data_positive ./ sqrt(sum(data_positive.^2, 1));

% 应用权重
data_weighted = bsxfun(@times, data_normalized, weights)

% 初始化最大值列向量和最小值列向量
maxcol = max(data_weighted, [], 1); % 每个指标的最大值构成的行向量
mincol = min(data_weighted, [], 1); % 每个指标的最小值构成的行向量

% 计算每个备选方案与最大值列向量的欧氏距离
dict_max = sqrt(sum((data_weighted - maxcol).^2, 2));

% 计算每个备选方案与最小值列向量的欧氏距离
dict_min = sqrt(sum((data_weighted - mincol).^2, 2));

% 构建 MaxMinMatrix
MaxMinMatrix = [dict_max, dict_min];

% 计算得分
score = MaxMinMatrix(:,2) ./ (MaxMinMatrix(:,1) + MaxMinMatrix(:,2))

% 可视化部分
%% 条形图
figure;
hBar = bar(score, 'FaceColor', 'flat', 'EdgeColor', 'k');
set(gca, 'XTickLabel', {'plan1', 'plan2', 'plan3', 'plan4'});
xlabel('plans');
ylabel('score');
title('TOPSIS scores');
grid on;

% 设置条形的颜色
colormap('spring'); % 使用jet颜色映射
for i = 1:length(hBar)
    set(hBar(i), 'CData', i); % 设置每个条形的颜色
end
%% 散点图
figure;
scatter(dict_max, dict_min, 100, score, 'filled');
colorbar;
xlabel('distance to ideal solution');
ylabel('distance to non-ideal solution');
title('TOPSIS scores');
grid on;

% 添加数据标签
for i = 1:length(score)
    text(dict_max(i), dict_min(i), sprintf('plan%d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

%% 雷达图
figure;
theta = linspace(0, 2*pi, size(data, 2) + 1);
labels = {'plan1', 'plan2', 'plan3', 'plan4'};
normalized_data = (data_weighted - min(data_weighted, [], 1)) ./ (max(data_weighted, [], 1) - min(data_weighted, [], 1)); % 归一化数据
normalized_data = [normalized_data, normalized_data(:,1)]; % 闭合图形

% 绘制每个备选方案
for i = 1:size(normalized_data, 1)
    polarplot(theta, normalized_data(i,:), 'LineWidth', 2);
    hold on;
end

% 绘制理想解和负理想解
polarplot(theta, [1, 1, 1, 1, 1], 'r--', 'LineWidth', 1.5); % 理想解
polarplot(theta, [0, 0, 0, 0, 0], 'k--', 'LineWidth', 1.5); % 负理想解

% 添加图例
legend('plan1', 'plan2', 'plan3', 'plan4', 'ideal', 'non-ideal');
title('TOPSIS Radar');

% 添加指标标签
for i = 1:length(labels)
    text(theta(i), 1.1, labels{i}, 'HorizontalAlignment', 'center', 'FontSize', 10);
end

% 正向化函数（目前仅支持反向型和中间型指标）
function data_positive = positivization(data, varargin)
    % 初始化正向化后的数据矩阵
    data_positive = data;
    
    % 处理可选参数
    for i = 1:2:length(varargin)
        if i+1 > length(varargin)
            disp(['Optional Argument ', num2str(i/2+1), ' is missing its value.']);
        else
            key = varargin{i};
            value = varargin{i+1};
            switch key
                case 'reversing'
                    for col = value
                        max_data = max(data(:, col));
                        min_data = min(data(:, col));
                        % 反向指标正向化处理
                        data_positive(:, col) = max_data + min_data - data(:, col);
                    end
                case 'centering'
                    for col = value
                        data_positive(:, col) = Mid2Max(data(:, col), mean(data(:, col)));
                    end
            end
        end
    end
end

% 中间型指标正向化函数
function [posit_x] = Mid2Max(x, best)
    % 计算最大差值
    M = max(abs(x - best));
    
    % 计算正向化值
    posit_x = 1 - abs(x - best) / M;
end