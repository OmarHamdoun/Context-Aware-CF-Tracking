%
%  Context-Aware Correlation Filters
%
%  Written by Matthias Mueller, 2016
%
%  This function takes care of setting up parameters, 
%  and interfacing with the online tracking benchmark.

function results=run_MOSSE_CA(seq, res_path, bSaveImage)

%default settings
kernel.type =  'linear';

padding = 2;%1.75;  %extra area surrounding the target
lambda1 = 1e-4;     %regularization
lambda2 = 20;%0.8;
interp_factor = 0.05;%0.025;  %linear interpolation factor for adaptation
output_sigma_factor = 0.1; %0.06;  %spatial bandwidth (proportional to target)

features.gray = true;
features.hog = false;

cell_size = 1;

target_sz = seq.init_rect(1,[4,3]);
pos = seq.init_rect(1,[2,1]) + floor(target_sz/2);
img_files = seq.s_frames;
video_path = [];

%call tracker function with all the relevant parameters
[positions, time] = tracker(video_path, img_files, pos, target_sz, ...
    padding, kernel, lambda1, lambda2, output_sigma_factor, interp_factor, ...
    cell_size, features, false);

%return results to benchmark, in a workspace variable
rects = [positions(:,2) - target_sz(2)/2, positions(:,1) - target_sz(1)/2];
rects(:,3) = target_sz(2);
rects(:,4) = target_sz(1);
fps = numel(seq.s_frames) / time;
disp(['fps: ' num2str(fps)])
results.type = 'rect';
results.res = rects;
results.fps = fps;
%assignin('base', 'res', res);

end