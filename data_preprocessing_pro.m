%% 数据预处理
% @author tianhs6523
% @date Jan 10th, 2025
% 概述，这份代码我给注释掉了很多代码，比赛时根据需要酌情使用:)
%data = xlsread(filename);
%[t,x] = data;
%下面的x只是测试数据，比赛时请换成上面这两条
% 数据
x = [48 51 57 57 49 86 48 53 59 50 48 47 53 56 60];
t = 1:size(x);

% 计算四分位数、四分位距及上下界
Q1 = prctile(x, 25); % 下四分位数
Q3 = prctile(x, 75); % 上四分位数
IQR = Q3 - Q1; % 四分位距
lb = Q1 - 1.5 * IQR; % 下界
ub = Q3 + 1.5 * IQR; % 上界
median_val = median(x); % 中位数

% 找出异常值
temp = (x < lb) | (x > ub);
ind = find(temp);

% 绘制箱线图
figure;

% 设置背景颜色，确保覆盖整个图像
hold on;
x_range = [min(x) - 5, max(x) + 5]; % 横轴范围
y_range = [-5, 5]; % 垂直范围 (适当增加以覆盖整个图像)
patch([x_range(1), x_range(2), x_range(2), x_range(1)], [y_range(1), y_range(1), y_range(2), y_range(2)], ...
      [253/255, 118/255, 63/255], 'EdgeColor', 'none', 'FaceAlpha', 0.3); % 红色背景

% 绘制箱线图
box = boxplot(x, 'orientation', 'horizontal', 'Colors', 'k', 'Widths', 0.7);

% 获取箱体对象并自定义填充颜色
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
    patch(get(h(j), 'XData'), get(h(j), 'YData'), [35/255, 186/255, 197/255], 'EdgeColor', 'k', 'LineWidth', 1.5,'FaceAlpha', 0.3); % 蓝色箱子填充
end

% 加粗须线、边界线和中位数线
set(findobj(gca, 'Tag', 'Whisker'), 'LineWidth', 1.5); % 须线加粗
set(findobj(gca, 'Tag', 'Median'), 'LineWidth', 2); % 中位数线加粗
set(findobj(gca, 'Tag', 'Outliers'), 'MarkerSize', 5); % 异常值点加大

% 标记异常值
scatter(x(ind), ones(size(ind)), 100, [35/255, 186/255, 197/255], 'x', 'MarkerEdgeColor', 'k');

% 添加中轴线
% plot([median_val, median_val], [-0.5, 1.5], '--k', 'LineWidth', 1.5); % 中轴线（中位数）

% 在图中标注重要数据
% text(lb - 5, 1.2, sprintf('LB: %.2f', lb), 'FontName', 'SimHei', 'FontSize', 10, 'Color', 'k');
% text(ub + 5, 1.2, sprintf('UB: %.2f', ub), 'FontName', 'SimHei', 'FontSize', 10, 'Color', 'k');
% text(Q1 - 5, 1.1, sprintf('Q1: %.2f', Q1), 'FontName', 'SimHei', 'FontSize', 10, 'Color', 'k');
% text(Q3 + 5, 1.1, sprintf('Q3: %.2f', Q3), 'FontName', 'SimHei', 'FontSize', 10, 'Color', 'k');
% text(median_val, -0.1, sprintf('Median: %.2f', median_val), 'FontName', 'SimHei', 'FontSize', 10, 'Color', 'k', 'HorizontalAlignment', 'center');
% plot(x_range-10, [0, 0], '--k', 'LineWidth', 1.5); % 横向中轴线
% 调整图形设置
title('Boxplot', 'FontName', 'SimHei', 'FontSize', 12);
xlabel('Value', 'FontName', 'SimHei', 'FontSize', 10);

% 调整横轴范围
xlim(x_range);
ylim([-1.5, 1.5]); % 确保背景完全覆盖
set(gca, 'YTick', [], 'Box', 'off', 'Layer', 'top');
hold off;
%% 剔除异常值
% 思路：本插值没有使用拉格朗日插值，而是使用拟合，然后在拟合后的函数上取点。
% 后面的插值所使用的函数纯属随便写的，真正比赛的时候要换，并且比较R值，并且还要注意，
% 不要使方程进入病态，产生龙格现象。如果出现这种（龙格）情况，可以写上为什么不选这个函数，
% 然后水一水字数（doge）。要比较不同拟合函数的差异，用subplot，我在这里只写了个2x1的，到
% 时候根据实际需求改，预计可能会上传一个单独的拟合的示例代码。
x(ind) = (x(ind-1)+x(ind+1))./2;
[xData, yData] = prepareCurveData( [], x );
ft1 = fittype( 'poly7' );
ft2 = fittype('exp2');
[fitresult1, gof] = fit( xData, yData, ft1 );
[fitresult2, gof] = fit( xData, yData, ft2 );
% 绘制数据拟合图。
figure( 'Name', 'interpolation' );

h = subplot(2,1,1); plot( fitresult1, xData, yData );
subplot(2,1,2); plot(fitresult2,xData,yData)
legend( h, 'x', 'interpolation', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
ylabel( 'x', 'Interpreter', 'none' );
grid on
x(ind) = fitresult1(ind);
%% 标准化
x = zscore(x);
% 这个标准化是我随便写的，我把所有标准化的指令及各自的特点都放在这里了
% 1.Z-score标准化（标准化到均值为0，方差为1）
% z = zscore(x)
% 2.Min-Max标准化（归一化到指定范围，通常是 [0, 1]）
% Min-Max标准化将数据按比例缩放到一个预定的区间，
% 通常是 [0, 1]。这种方法常用于神经网络等需要数据在特定范围内的场景。
% x_norm = mat2gray(x);
% 3.MaxAbs标准化（按最大绝对值进行缩放）
% MaxAbs标准化方法将数据按每个特征的最大绝对值缩放，确保数据的范围在 [-1, 1] 之间。这种方法对稀疏矩阵特别有用。
% x = [48, 51, 57, 57, 49, 86, 48, 53, 59, 50, 48, 47, 53, 56, 60];
% x_maxabs = max(abs(x));
% x_maxabs_norm = x / x_maxabs;  % MaxAbs标准化
% 4.Log标准化（对数标准化）
% 对数标准化将数据进行对数转换，常用于处理偏态分布或需要降低数据的尺度的情况。对数标准化的结果通常会减少数据的差异。​
% x = [48, 51, 57, 57, 49, 86, 48, 53, 59, 50, 48, 47, 53, 56, 60];
% x_log = log(x);  % 对数标准化（通常适用于正数数据）
% 5.Robust标准化（去除异常值的标准化）***这个比赛可以简单用一下其实***
% Robust标准化是一种使用数据的中位数和四分位数来标准化数据的方法。这种方法对异常值不敏感，常用于具有异常值的数据集。
% x_robust = robustscale(x); 