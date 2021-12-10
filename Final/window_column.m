%% This function performs windowing on the given database. NO separation between test and train, nor feature extraction.

%file_name ---> example 'Nearlab_EMG_data_subject2_day2_round3' 
%stride_time [milliseconds]
%window_size_time [milliseconds]

function [N_correct_movements, Win]= window_column(file_name, window_size_time,stride_time)


database = readmatrix(file_name);

fs = 2048;

window_size = floor(fs*window_size_time/1000); % ms ---> samples

stride = floor(fs*stride_time/1000); % ms ---> samples

tag = [];
sub_w = [];
Win = [];
Length = [];
missing = 0;
flag = 0;

for i = 1 : 40
    if (sum(database(:,12)==i+flag)==0 | flag>0)
        
        if(sum(database(:,12)==i+flag)==0)
            
            missing = [missing,i+flag];
            
            flag = flag + 1;
            
        end; %vector including not correct movements number
        
        tag(i) = find(database(:,12)==i+flag,1,'last'); % endpoints of each movement 
        
        if(i+flag==40)
            break;
        end
    else
        tag(i) = find(database(:,12)==i,1,'last');
    end
end

tag=[0,tag] ; % endpoints of each movement (from 0 to end)

N_correct_movements = size(tag,2)-1; % Number of actual movements correctly performed in the round (not necessarily 40)

for j = 1 : N_correct_movements 
    
        sub_w(j) = floor(((tag(j+1)-tag(j)-window_size)/stride) +1); % Total number of sub_windows for each movement
       
        Length(j) = tag(j+1)-tag(j); % Samples for each movement
        
end
   
    
%% Windowing: 
Win = zeros(1,13);
tic
Number = ones (window_size,1);
for j = 1 : N_correct_movements
    
    movement = database(tag(j)+1:tag(j+1),:); % working on samples not on endpoints. Selecting each movement.
    
    for i = 1 : sub_w(j)
        window = movement(1+(i-1)*stride:(i-1)*stride+window_size,:);
        window = [window,Number * (1+Win(end,13))];
        Win = [Win;window];% for each movement perform sub_windowing.
        
    end
   
end
 Win = Win(2:end,:);
toc

fprintf("window size: %i\n",window_size)
fprintf("stride length: %i\n",stride)
fprintf("total windows: %i\n",sum(sub_w))
fprintf("total correct movements: %i\n",N_correct_movements)






    
    





 