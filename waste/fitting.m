open('Correlation_graphs.fig');
h=get(gca,'Children');
x = get(h,'Xdata');
y = get(h,'Ydata');

%find max error of each degree
yy = zeros(360,1);
for ang=1:360
    for n=1:1000
        if round(x(n)) == ang
            if y(n) > yy(ang,1)
                yy(ang,1) = y(n);
            end
        end
    end
end

%delete the non-value points;
yyy = zeros(124,1);  %may need to change length (122 points).
xxx = zeros(124,1);
m = 1;
for n = 1:360
    if yy(n,1) ~= 0
        xxx(m,1) = n;
        yyy(m,1) = yy(n,1);
        m = m + 1;
    end
end
cftool
