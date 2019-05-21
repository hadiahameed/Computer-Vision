function  plottingRANSACtrials(x,y,xx,yy,inliers,b)
h = figure;
figure(h)
plot(x,y,'ro')
hold on
plot(x,b(1,1)*x+b(2,1),'b--')
plot(xx,yy,'y*')

x_ins = x(1,inliers>0);
y_ins = y(1,inliers>0);
hold on
plot(x_ins,y_ins,'bs')
xlim([0 400])
ylim([0 350])
grid on
legend('data','line fit','initial samples','inliers')
pause(2)
close(h)
end

