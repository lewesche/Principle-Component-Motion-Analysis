% Leif Wesche
% PCA Motion Analysis

%%

clear all
close all
clc

% 1) Load Data
load('cam1_1');
load('cam1_2');
load('cam1_3');
load('cam1_4');
load('cam2_1');
load('cam2_2');
load('cam2_3');
load('cam2_4');
load('cam3_1');
load('cam3_2');
load('cam3_3');
load('cam3_4');

%% veiw clips
implay(vidFrames3_3)

%% 2) Index videos, convert to grey, convert to doubles
clc

i_ind=[1:3]; %range 1-3, Trials
j_ind=[1:4]; %range 1-4, 1=Ideal Case, 2=Noisey Case, 3=Horizontal Displacement, 4=Horizontal Displacement and Rotation

for i=i_ind
    for j=j_ind
vidc{i}{j}=eval(strcat('vidFrames', num2str(i), '_', num2str(j)));
framecount = size(vidc{i}{j}(1,1,1,:));  
framecount = framecount(4);
        for framecount = [1:framecount] 
vid_u{i}{j}{framecount}=rgb2gray(vidc{i}{j}(:,:,:,framecount));
vid{i}{j}{framecount}=flipud(double(vid_u{i}{j}{framecount}));
        end
    end
end

%% 3) Starting Positions
clc
close all
%
Xmin_start{1}{1}=250; Xmax_start{1}{1}=270; Ymin_start{1}{1}=310; Ymax_start{1}{1}=340;
Xmin_step{1}{1}=20;   Xmax_step{1}{1}=20;   Ymin_step{1}{1}=8;    Ymax_step{1}{1}=8;
%
Xmin_start{2}{1}=200; Xmax_start{2}{1}=220; Ymin_start{2}{1}=270; Ymax_start{2}{1}=290;
Xmin_step{2}{1}=20;   Xmax_step{2}{1}=20;   Ymin_step{2}{1}=8;    Ymax_step{2}{1}=8;
%
Xmin_start{3}{1}=200; Xmax_start{3}{1}=220; Ymin_start{3}{1}=310; Ymax_start{3}{1}=320;
Xmin_step{3}{1}=10;   Xmax_step{3}{1}=10;   Ymin_step{3}{1}=20;    Ymax_step{3}{1}=20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xmin_start{1}{2}=165; Xmax_start{1}{2}=180; Ymin_start{1}{2}=310; Ymax_start{1}{2}=330;
Xmin_step{1}{2}=20;   Xmax_step{1}{2}=20;   Ymin_step{1}{2}=20;    Ymax_step{1}{2}=20;
%
Xmin_start{2}{2}=60; Xmax_start{2}{2}=80; Ymin_start{2}{2}=310; Ymax_start{2}{2}=330;
Xmin_step{2}{2}=40;   Xmax_step{2}{2}=40;   Ymin_step{2}{2}=40;    Ymax_step{2}{2}=40;
%
Xmin_start{3}{2}=220; Xmax_start{3}{2}=250; Ymin_start{3}{2}=330; Ymax_start{3}{2}=360;
Xmin_step{3}{2}=20;   Xmax_step{3}{2}=20;   Ymin_step{3}{2}=20;    Ymax_step{3}{2}=20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xmin_start{1}{3}=185; Xmax_start{1}{3}=210; Ymin_start{1}{3}=310; Ymax_start{1}{3}=335;
Xmin_step{1}{3}=20;   Xmax_step{1}{3}=20;   Ymin_step{1}{3}=20;    Ymax_step{1}{3}=20;
%
Xmin_start{2}{3}=170; Xmax_start{2}{3}=200; Ymin_start{2}{3}=230; Ymax_start{2}{3}=250;
Xmin_step{2}{3}=20;   Xmax_step{2}{3}=20;   Ymin_step{2}{3}=25;    Ymax_step{2}{3}=25;
%
Xmin_start{3}{3}=240; Xmax_start{3}{3}=270; Ymin_start{3}{3}=340; Ymax_start{3}{3}=370;
Xmin_step{3}{3}=20;   Xmax_step{3}{3}=20;   Ymin_step{3}{3}=20;    Ymax_step{3}{3}=20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xmin_start{1}{4}=140; Xmax_start{1}{4}=200; Ymin_start{1}{4}=360; Ymax_start{1}{4}=400;
Xmin_step{1}{4}=15;   Xmax_step{1}{4}=15;   Ymin_step{1}{4}=15;    Ymax_step{1}{4}=15;
%
Xmin_start{2}{4}=140; Xmax_start{2}{4}=200; Ymin_start{2}{4}=210; Ymax_start{2}{4}=240;
Xmin_step{2}{4}=15;   Xmax_step{2}{4}=15;   Ymin_step{2}{4}=15;    Ymax_step{2}{4}=15;
%
Xmin_start{3}{4}=250; Xmax_start{3}{4}=280; Ymin_start{3}{4}=390; Ymax_start{3}{4}=410;
Xmin_step{3}{4}=15;   Xmax_step{3}{4}=15;   Ymin_step{3}{4}=15;    Ymax_step{3}{4}=15;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4) Track Bucket Method
clc
close all


for i=i_ind
    for j=j_ind
        
        Xmin=Xmin_start{i}{j}; 
        Xmax=Xmax_start{i}{j}; 
        Ymin=Ymin_start{i}{j}; 
        Ymax=Ymax_start{i}{j};
        
        Xdata=[]; 
        Ydata=[]; 
        Xbox=[Xmin, Xmax, Xmax, Xmin, Xmin];
        Ybox=[Ymin, Ymin, Ymax, Ymax, Ymin];
        
        framecount = size(vidc{i}{j}(1,1,1,:));
        framecount = framecount(4);
        
            for framecount=[1:framecount]
            testframe=vid{i}{j}{framecount};
            MAX=max(testframe(Xmin:Xmax, Ymin:Ymax));
            MAX=max(MAX);
            ind=find(testframe == MAX);
            [X, Y]=ind2sub(size(testframe), ind);
            
            X=X( X >= Xmin & X <= Xmax);
            Y=Y( Y >= Ymin & Y <= Ymax);
            
            X=round(mean(X));
            Y=round(mean(Y));

            Xdata=[Xdata, X];
            Ydata=[Ydata, Y];
        
%             pcolor(testframe), colormap(gray), shading interp
%             hold on
%             plot(Y, X, 'ro', 'linewidth', 2)
%             title (['Test ', num2str(j), ' Camera ', num2str(i), ' Frame ', num2str(framecount)])
%             hold on
%             
%             plot(Ybox, Xbox, 'linewidth', 2)
%             hold off
%             pause(0.08)
            
            Xmin=X-Xmin_step{i}{j}; 
            Xmax=X+Xmax_step{i}{j};
            Ymin=Y-Ymin_step{i}{j};
            Ymax=Y+Ymax_step{i}{j};
            Xbox=[Xmin, Xmax, Xmax, Xmin, Xmin];
            Ybox=[Ymin, Ymin, Ymax, Ymax, Ymin];
            end
            
    Xdata_all{i}{j}=Xdata;
    Ydata_all{i}{j}=Ydata;
    
    end
end
close all

%% 5) Align and Normalize Trajectories
clc
close all

Ydata_all{1}{1}=Ydata_all{1}{1}(29:179);
Xdata_all{1}{1}=Xdata_all{1}{1}(29:179);
Ydata_all{2}{1}=Ydata_all{2}{1}(40:190);
Xdata_all{2}{1}=Xdata_all{2}{1}(40:190);
Ydata_all{3}{1}=Ydata_all{3}{1}(12:162);
Xdata_all{3}{1}=Xdata_all{3}{1}(12:162);
test{1}=[Ydata_all{1}{1}; Xdata_all{1}{1}; Ydata_all{2}{1}; Xdata_all{2}{1}; Ydata_all{3}{1}; Xdata_all{3}{1}];

Ydata_all{1}{2}=Ydata_all{1}{2}(15:215);
Xdata_all{1}{2}=Xdata_all{1}{2}(15:215);
Ydata_all{2}{2}=Ydata_all{2}{2}(80:280);
Xdata_all{2}{2}=Xdata_all{2}{2}(80:280);
Ydata_all{3}{2}=Ydata_all{3}{2}(40:240);
Xdata_all{3}{2}=Xdata_all{3}{2}(40:240);
test{2}=[Ydata_all{1}{2}; Xdata_all{1}{2}; Ydata_all{2}{2}; Xdata_all{2}{2}; Ydata_all{3}{2}; Xdata_all{3}{2}];

Ydata_all{1}{3}=Ydata_all{1}{3}(20:220);
Xdata_all{1}{3}=Xdata_all{1}{3}(20:220);
Ydata_all{2}{3}=Ydata_all{2}{3}(5:205);
Xdata_all{2}{3}=Xdata_all{2}{3}(5:205);
Ydata_all{3}{3}=Ydata_all{3}{3}(29:229);
Xdata_all{3}{3}=Xdata_all{3}{3}(29:229);
test{3}=[Ydata_all{1}{3}; Xdata_all{1}{3}; Ydata_all{2}{3}; Xdata_all{2}{3}; Ydata_all{3}{3}; Xdata_all{3}{3}];

Ydata_all{1}{4}=Ydata_all{1}{4}(32:232);
Xdata_all{1}{4}=Xdata_all{1}{4}(32:232);
Ydata_all{2}{4}=Ydata_all{2}{4}(85:285);
Xdata_all{2}{4}=Xdata_all{2}{4}(85:285);
Ydata_all{3}{4}=Ydata_all{3}{4}(50:250);
Xdata_all{3}{4}=Xdata_all{3}{4}(50:250);
test{4}=[Ydata_all{1}{4}; Xdata_all{1}{4}; Ydata_all{2}{4}; Xdata_all{2}{4}; Ydata_all{3}{4}; Xdata_all{3}{4}];

for j=j_ind
    n=mean(test{j}, 2);
    N=ones(size(test{j}));
    for k=1:length(test{j}) 
        N(:,k)=n;
    end
    test{j}=test{j}-N;
end

for j=j_ind
    Ydata_all{1}{j}=test{j}(1,:);
    Xdata_all{1}{j}=test{j}(2,:);
    Ydata_all{2}{j}=test{j}(3,:);
    Xdata_all{2}{j}=test{j}(4,:);
    Ydata_all{3}{j}=test{j}(5,:);
    Xdata_all{3}{j}=test{j}(6,:);
end


%% 6) Plot Trajectories

for j=j_ind
    figure
    hold on
    for i=i_ind
        subplot(2,2,i)
        plot(Ydata_all{i}{j}, 'linewidth', 2)
        hold on
        plot(Xdata_all{i}{j}, 'linewidth', 2)
        title(['Bucket Trajectory: Test ', num2str(j), [' Camera '], num2str(i)])
        xlabel('Frame #'); ylabel('Position'); legend('Y Position', 'X Position');
        hold off   
    end
end


%% 7) SVD
clc
close all

proj={}; U={}; S={}; V={};
for k= [1:4]
    [U_,S_,V_]=svd(test{k}, 'econ');
    U{k}=U_;
    S{k}=S_;
    V{k}=V_;
    proj{k}=(U_.')*test{k};
end

abcd=['A','B','C','D'];

figure
for k= [1:4]
subplot(2,2,k)
scatter([1:6], diag(S{k})/sum(diag(S{k})), 'ro', 'linewidth', 2)
title([abcd(k), ') Singular Values: Test ', num2str(k)])
xlabel('Singular Value #'); ylabel('Normalized Magnitude');
end

figure
for k= [1:4]
subplot(2,2,k)
plot(proj{k}(1, :), 'linewidth', 2)
hold on
plot(proj{k}(2, :), 'linewidth', 2)
hold on
plot(proj{k}(3, :), 'linewidth', 2)
title([abcd(k), ') U Projection: Test ', num2str(k)])
xlabel('Time'); ylabel('Position');
% hold on
% plot(proj{k}(4, :), 'linewidth', 2)
% hold on
% plot(proj{k}(5, :), 'linewidth', 2)
% hold on
% plot(proj{k}(6, :), 'linewidth', 2)
legend('Ref. Frame 1', 'Ref. Frame 2', 'Ref. Frame 3', 'Ref. Frame 4', 'Ref. Frame 5', 'Ref. Frame 6');
end

