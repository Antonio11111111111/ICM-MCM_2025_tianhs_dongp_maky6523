%% 随机生成两簇点，测试用
rng(123);

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
%% 调用dbscan函数并可视化

data = [cluster1; cluster2];
 
epsilon = 1; % ε的选择
minPts = 5; % minPts的选择
% 执行DBSCAN聚类
idx = dbscan(data, epsilon, minPts)
%% 可视化
scatter3(data(:, 1), data(:, 2), data(:, 3), 10, idx, 'filled');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('DBSCAN Clustering Result in 3D');
legend('Cluster 1', 'Cluster 2', 'Noise');
grid on;

