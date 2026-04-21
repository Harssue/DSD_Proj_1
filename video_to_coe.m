% ===== SETTINGS =====
VIDEO_PATH = 'input.mp4';
OUTPUT_COE = 'frames.coe';

WIDTH = 160;
HEIGHT = 120;
MAX_FRAMES = 10;   % keep small for BRAM
% ====================

% Create video reader
vid = VideoReader(VIDEO_PATH);

frames = {};
count = 0;

% Read frames
while hasFrame(vid) && count < MAX_FRAMES
    frame = readFrame(vid);

    % Resize
    frame = imresize(frame, [HEIGHT WIDTH]);

    % Convert to grayscale
    gray = rgb2gray(frame);

    count = count + 1;
    frames{count} = gray;
end

fprintf('Extracted %d frames\n', length(frames));

% Flatten frames into 1D array
data = [];

for k = 1:length(frames)
    f = frames{k};

    for y = 1:HEIGHT
        for x = 1:WIDTH
            pixel = f(y, x);
            data(end+1) = pixel; %#ok<SAGROW>
        end
    end
end

% Write COE file
fid = fopen(OUTPUT_COE, 'w');

fprintf(fid, 'memory_initialization_radix=16;\n');
fprintf(fid, 'memory_initialization_vector=\n');

for i = 1:length(data)
    hex_val = upper(dec2hex(data(i), 2));

    if i == length(data)
        fprintf(fid, '%s;\n', hex_val);
    else
        fprintf(fid, '%s,\n', hex_val);
    end
end

fclose(fid);

fprintf('COE file generated: %s\n', OUTPUT_COE);
