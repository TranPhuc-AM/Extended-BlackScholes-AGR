## Dọc dữ liệu và thống kê mô tả
```matlab
S = readmatrix(fullfile('..', 'data', 'agr.csv'));
table(numel(S), mean(S), std(S), min(S), median(S), max(S), ...
     'VariableNames', {'N', 'Mean', 'SD', 'Min', 'Med', 'Max'})

```


## Chia dữ liệu
Chọn 1 trong 2 cách chia, cách đánh giá để trực quan về trong huấn luyện. Sau khi đã xem xét xong thể dùng cách chia dể dự báo.
### Đánh giá và huấn luyện
``` matlab
train = S(1 : def.T); 
test  = S(def.T+1 : def.T+def.H);
xTrain = 1:numel(train);
xTest = numel(train)+1:numel(train)+H;
```
### Dự báo
```matlab
% train = S;
% test = zeros(def.H,1)
% xTrain = 1:numel(train);
% xTest = numel(train)+1:numel(train)+H;
```

## Tham số tùy chỉnh
```matlab
def.P = 10000;
def.lambda = 20;
def.alpha = 0.01;

def.H = 50; % do dai tap huan luyen
```

## Tham số cố định

```matlab
def.N = numel(S);
def.dt = 1/def.N;
def.T  = numel(train);
```


## Tạo mô phỏng
```matlab
[paths] = createSimulation(train, def);
```

## Chọn các quỹ đạo
``` matlab
[slc_paths, slc_CEI] = selectPaths(train, paths, def);
```
## Dự báo
```matlab
[fit, fc, CI] = forecast(slc_paths, slc_CEI, def);

```

## Vẽ đồ thị biễu diễn
```matlab
figure(1)
hold on

h1 =  fill([xTest  fliplr(xTest )], ...
     [CI.up' fliplr(CI.lo')], ...
     [0.5, 0.5, 0.7], ...
     'EdgeColor', 'none', ...
     'FaceAlpha', 0.4);
 
 fill([xTest  fliplr(xTest )], ...
     [CI.wup' fliplr(CI.wlo')], ...
     [0.7, 0.5, 0.5], ...
     'EdgeColor', 'none', ...
     'FaceAlpha', 0.4);
 
plot(1:numel(S), S, '-b', 'LineWidth' , 1);
plot(xTrain, fit, 'r', 'LineWidth',1)
plot(xTest, fc, '--g', 'LineWidth',2)
 
hold off
legend('Unweighted 95% Forecast Interval', ...
    'Weighted 95% Forecast Interval',...
    'Actual', 'Fitted', 'Forecast', ...
    'Location', 'southwest');
xlabel('Time');
ylabel('Stock price');
grid on;

saveas(h1, fullfile('..', 'output', 'fig-fit.png')) % Luu lai neu can
```

## Đánh giá
```matlab
[accTrain, accTest] = accurary(train, fit, test, fc);

fprintf("Accuracy of Train\n")
fprintf("MAPE: %.2f, RMSE:  %.4f, MAE %.4f \n", accTrain.mape, accTrain.rmse, accTrain.mae)
fprintf("Accuracy of Test\n")
fprintf("MAPE: %.2f, RMSE:  %.4f, MAE %.4f \n", accTest.mape, accTest.rmse, accTest.mae)
```

## Ghi chú
Đối với phần tìm kiếm lưới, mở trực tiếp file `gridSearch.m` sửa đổi các giá trị trong ham và chạy hàm không có tham số đầu vào, kết quả trả ra một bảng đã sắp xếp độ chính xác từ nhỏ đến lớn và file `gridSearch.csv`