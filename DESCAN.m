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
%% 算法简述
%有了密度定义，DBSCAN的聚类原理就很简单了，由密度可达关系导出的最大密度相连的样本集合，即为我们最终聚类的一个类别，或者说一个簇。所以任意一个DBSACN簇都至少有一个核心
%对象，如果有多于一个核心对象，则这些核心对象必然可以组成密度可达序列。
%那么怎么才能找到这样的簇样本集合呢？DBSCAN使用的方法很简单，它任意选择一个没有类别的核心对象作为种子，然后找到所有这个核心对象能够密度可达的样本集合，即为一个聚类簇。
%接着继续选择另一个没有类别的核心对象去寻找密度可达的样本集合，这样就得到另一个聚类簇。一直运行到所有核心对象都有类别为止。参考上图的两个绿色箭头路径，聚类的两个簇。
%聚类完成后，样本集中的点一般可以分为三类：核心点，边界点和离群点（异常点）。边界点是簇中的非核心点，离群点就是样本集中不属于任意簇的样本点。此外，在簇中还有一类特殊的样本点，该类样本点可以由两个核心对象密度直达，但是这两个核心对象又不能密度可达（属于两个簇），该类样本的最终划分簇一般由算法执行顺序决定，即先被划分到哪
%个簇就属于哪个簇，也就是说DBSCAN的算法不是完全稳定的算法。这也意味着DBSCAN是并行算法，对于两个并行运算结果簇，如果两个簇中存在两个核心对象密度可达，则两个簇聚为一个簇。                       
%原文链接：https://blog.csdn.net/haveanybody/article/details/113092851
 
