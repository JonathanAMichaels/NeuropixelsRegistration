clear all
clc
close all

%%% NEUROPIXELS REGISTRATION --
%%% ----see vignettes for examples of different datasets and replace file paths

%% PARAMETERS
globalTic=tic;
timebins=200; %% set the number of time bins to use
mintime=0;%starting time point (in seconds)
maxtime=999;%ending time point (in seconds)
timestep=1; %seconds (how big should each time bin be)
sample_rate=30000; %%Set the sampling rate of recording
threshold=2;
L=28;
sigma=0;
%% DATA FORMAT
dataset='EPHYS'; %types of data format (NP-binary,NP-H5,EPHYS)



%% helper functions
times=round(linspace(mintime,maxtime,timebins));
ptp=@(x)(movmax(x,25,2)-movmin(x,25,2));
vec=@(x)(x(:));
bp = @(x)(reshape(bandpass(vec(double(x)'),[300 2000],30000),size(x'))');
thresh = @(x,t)(x.*(x>t));
minmax = @(x)((x-min(x(:)))./max(x(:)-min(x(:))));
[b,a] = butter(3,[300 2000]/(30000/2));
bp2 = @(x)(reshape(filter(b,a,vec(double(x)')),size(x'))');

%% DATA LOADING
%% see different examples of data formats supported)
if strcmpi(dataset,'NP-H5');
    
    %% time bin loading - h5 files
    bestsnr=0;
    tic
    for t=1:length(times)
        
        [X,geom,data{t}]=batch_extract('\Users\Erdem\Dropbox\Projects\spike_drift\neuropixel_data.h5',sample_rate,times(t),times(t)+timestep,1000);
        
        
        
        clc
        fprintf(['Loading time bins (' num2str(t) '/' num2str(length(times)) ')...\n']);
        fprintf(['\n' repmat('.',1,50) '\n\n'])
        for tt=1:round(t*50/length(times))
            fprintf('\b|\n');
        end
        T=toc;
        disp(['Time elapsed (minutes): ' num2str(T/60) ' Time remaining (minutes): ' num2str((length(times)-t)*(T/t)*(1/60))]);
        
    end
    
end

if strcmpi(dataset,'NP-binary')
    %% time bin loading - binary files
    fileID = fopen('/Users/erdem/Downloads/pacman-task_c_191202_neu_001_CAR.bin','r');
    dataset_info=load('/Users/erdem/Downloads/neuropixels_primateDemo128_chanMap.mat');
    geom(:,1)=dataset_info.xcoords;
    geom(:,2)=dataset_info.ycoords;
    bestsnr=0;
    tic
    for t=1:length(times)
        fseek(fileID,length(dataset_info.chanMap)*30000*times(t),'bof');
        data{t} = fread(fileID, [length(dataset_info.chanMap) 30000], '*int16');
        clc
        fprintf(['Loading time bins (' num2str(t) '/' num2str(length(times)) ')...\n']);
        fprintf(['\n' repmat('.',1,50) '\n\n'])
        for tt=1:round(t*50/length(times))
            fprintf('\b|\n');
        end
        T=toc;
        disp(['Time elapsed (minutes): ' num2str(T/60) ' Time remaining (minutes): ' num2str((length(times)-t)*(T/t)*(1/60))]);
        
    end
    fclose(fileID);
end

if strcmpi(dataset,'NP-binary2')
    %% time bin loading - binary files
    fileID = fopen('/Users/erdem/Downloads/cortexlab-drift-dataset1.bin','r');
    dataset_info=load('/Users/erdem/Downloads/NP2_kilosortChanMap.mat');
    geom(:,1)=dataset_info.xcoords;
    geom(:,2)=dataset_info.ycoords;
    bestsnr=0;
    tic
    for t=1:length(times)
        fseek(fileID,length(dataset_info.chanMap)*30000*times(t),'bof');
        data{t} = fread(fileID, [length(dataset_info.chanMap) 30000], '*int16');
        clc
        fprintf(['Loading time bins (' num2str(t) '/' num2str(length(times)) ')...\n']);
        fprintf(['\n' repmat('.',1,50) '\n\n'])
        for tt=1:round(t*50/length(times))
            fprintf('\b|\n');
        end
        T=toc;
        disp(['Time elapsed (minutes): ' num2str(T/60) ' Time remaining (minutes): ' num2str((length(times)-t)*(T/t)*(1/60))]);
        
    end
    fclose(fileID);
end


if strcmpi(dataset,'EPHYS');
    
    %% time bin loading - EPHYS FILES
    bestsnr=0;
    tic
    dataset_info=load('/Users/erdem/Downloads/buz32chMap.mat');
    for t=1:8
            [tmp, timestamps, info] = load_open_ephys_data(['/Users/erdem/Downloads/2019-11-18_16-27-36_HR46_R0_001/100_CH' num2str(t) '.continuous']);
            if t==1
                data0=zeros(8,size(tmp,1));
            end
            data0(t,:)=tmp';
            i
        
        
        clc
        fprintf(['Loading time bins (' num2str(t) '/' num2str(32) ')...\n']);
        fprintf(['\n' repmat('.',1,50) '\n\n'])
        for tt=1:round(t*50/32)
            fprintf('\b|\n');
        end
        T=toc;
        disp(['Time elapsed (minutes): ' num2str(T/60) ' Time remaining (minutes): ' num2str((32-t)*(T/t)*(1/60))]);
        
    end
    
    rec_length=floor(size(data0,2)/24000);
    tic
    for t=1:rec_length
        data{t}=data0(:,(t-1)*24000+1:t*24000);
             clc
        fprintf(['Loading time bins (' num2str(t) '/' num2str(rec_length) ')...\n']);
        fprintf(['\n' repmat('.',1,50) '\n\n'])
        for tt=1:round(t*50/rec_length)
            fprintf('\b|\n');
        end
        T=toc;
        disp(['Time elapsed (minutes): ' num2str(T/60) ' Time remaining (minutes): ' num2str((rec_length-t)*(T/t)*(1/60))]);
    end
    geom(:,1)=dataset_info.xcoords(1:8,:);
    geom(:,2)=dataset_info.ycoords(1:8,:);
    
    clear data0;
end


%% MAIN ROUTINE
%% Filtering / background removal


tic
for t=1:length(data)
<<<<<<< HEAD
    
    data_denoised{t}=sinkhorn_denoise(ptp(data{t}),0.5,2);
=======
%     data{t}=bp2(data{t});
>>>>>>> c0c3a92e2e63e282df95d5a7900a7daed8654807
    clc
    fprintf(['Bandpass filtering (' num2str(t) '/' num2str(length(times)) ')...\n']);
    fprintf(['\n' repmat('.',1,50) '\n\n'])
    for tt=1:round(t*50/length(times))
        fprintf('\b|\n');
    end
    T=toc;
    disp(['Time elapsed (minutes): ' num2str(T/60) ' Time remaining (minutes): ' num2str((length(times)-t)*(T/t)*(1/60))]);
end




%% feature extraction
nhood=L;
geom=geom-min(geom,[],1)+1;
[x,y]=meshgrid((min(geom(:,1)):max(geom(:,1))),(min(geom(:,2)):max(geom(:,2))));
coor=[vec(permute(x,[2 1])) vec(permute(y,[2 1]))];
M=mapping_matrix(geom,coor,'krigging',1,sigma,L);
tic;
for t=1:length(data)
    
    A=thresh(ptp(bp2(decorrelate(single(data{t}),2))),threshold);
%     E=zeros(size(A,1),1);
%     E(any(A>0,2))=sum(A(any(A>0,2),:),2)./sum(A(any(A>0,2),:)>0,2);
%     E=max(E-threshold,0);
    A(A==0)=nan;
    E=nanmean(A,2);E(isnan(E))=0;
    E=max(E-threshold,0);
    I{t}=max(reshape(M*E,size(x')),0);
    clc
    fprintf(['Generating images (' num2str(t) '/' num2str(length(times)) ')...\n']);
    fprintf(['\n' repmat('.',1,50) '\n\n'])
    for tt=1:round(t*50/length(times))
        fprintf('\b|\n');
    end
    T=toc;
    disp(['Time elapsed (minutes): ' num2str(T/60) ' Time remaining (minutes): ' num2str((length(times)-t)*(T/t)*(1/60))]);
end

%% vignette correction

vignette_estimator_2;
%% decentralized displacement estimate
 [Dx,Dy,cmax]=pairwise_reg(Ic,1,100);

<<<<<<< HEAD
`
=======

D=Dy';
lambda=1;
D0=D;
S=zeros(size(D));
p0=nanmean(D0-nanmean(D0,2),1);


% robust regression
for t=1:10
    p=nanmean(D-l1tf(nanmean(D,2),lambda),1);
    P=D0-l1tf(nanmean(D,2),lambda);
    S=abs(zscore(P,[],1))>2;S=or(S,S');
    D=D0;
    D(S==1)=nan;
end

py0=p0;
py=p;

D=Dx';
lambda=1;
D0=D;
S=zeros(size(D));
p0=nanmean(D0-nanmean(D0,2),1);

>>>>>>> c0c3a92e2e63e282df95d5a7900a7daed8654807

% robust regression
for t=1:10
    p=nanmean(D-l1tf(nanmean(D,2),lambda),1);
    P=D0-l1tf(nanmean(D,2),lambda);
    S=abs(zscore(P,[],1))>2;S=or(S,S');
    D=D0;
    D(S==1)=nan;
end
px0=p0;
px=p;

subplot(1,2,1);
plot(py-py(1),'LineWidth',2,'Color',[0.5 0 0.5 0.5]);xlabel('Time bins');ylabel('Displacement');title('Y-Displacement estimate');grid on;

subplot(1,2,2);
plot(px-px(1),'LineWidth',2,'Color',[0 0.5 0.5 0.5]);xlabel('Time bins');ylabel('Displacement');title('X-Displacement estimate');grid on;

totalTime=toc(globalTic);

disp(['Total time: ' num2str(totalTime/60) ' minutes. ' num2str(totalTime/length(data)) ' seconds per one-second time bin of data.']);

