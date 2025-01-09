%% 生成两个聚类的数据点
rng(123); % 设置随机数生成器的种子

% 生成第一个聚类的数据点
num_points_cluster1 = 50;  % 第一个聚类的点数
mean_cluster1 = [1, 2, 3];  % 第一个聚类的均值
cov_cluster1 = [0.5, 0, 0; 0, 0.5, 0; 0, 0, 0.5];  % 第一个聚类的协方差矩阵
cluster1 = mvnrnd(mean_cluster1, cov_cluster1, num_points_cluster1);

% 生成第二个聚类的数据点
num_points_cluster2 = 50;  % 第二个聚类的点数
mean_cluster2 = [5, 6, 7];  % 第二个聚类的均值
cov_cluster2 = [0.5, 0, 0; 0, 0.5, 0; 0, 0, 0.5];  % 第二个聚类的协方差矩阵
cluster2 = mvnrnd(mean_cluster2, cov_cluster2, num_points_cluster2);

% 合并数据
data = [cluster1; cluster2];
%% FCM聚类及可视化
% FCM 聚类参数
numClusters = 2; % 聚类数量
exponent = 2.0; % 模糊度参数
maxIter = 100; % 最大迭代次数
minImprove = 1e-5; % 最小改进阈值
distMetric = 'euclidean'; % 距离度量

% 创建 fcmOptions 对象
options = fcmOptions(...
    'NumClusters', numClusters, ...
    'Exponent', exponent, ...
    'MaxNumIteration', maxIter, ...
    'MinImprovement', minImprove, ...
    'DistanceMetric', distMetric, ...
    'Verbose', false);

% 执行 FCM 聚类
[centers, U, objFcn] = fcm(data, options);

% 可视化结果
figure;
scatter3(data(:, 1), data(:, 2), data(:, 3), 10, U(1, :), 'filled');
hold on;
scatter3(centers(:, 1), centers(:, 2), centers(:, 3), 100, 'kx', 'LineWidth', 2);
xlabel('X');
ylabel('Y');
zlabel('Z');
title('FCM Clustering Result in 3D');
legend('Cluster 1', 'Cluster 2', 'Centers');
grid on;
hold off;
%% 算法说明：不要求详细掌握
%模糊均值聚类（FCM）是用隶属度确定每个数据点属于某个聚类的程度的一种聚类算法。
% 1973年，Bezdek提出了该算法，作为早期硬均值聚类（HCM）方法的一种改进。FCM把 n 个向量 xi(i=1,2,…,n)
% 分为 c 个模糊组,并求每组的聚类中心，使得非相似性指标的价值函数达到最小。FCM 使得每个给定数据点用值
% 在 0,1 间的隶属度来确定其属于各个组的程度。与引入模糊划分相适应,隶属矩阵 U 允许有取值在 0,1 间的元素。
% 不过,加上归一化规定，一个数据集的隶属度的和总等于 1:


                        