function present = life( varargin )
%Conway's Game of Life
% Various input types:
%
% life(); select size and points of life
% life(M,N, 'select'); %predefined size, still select points of life
%                       note: literally type 'select'
%
% life(pre_defined_binary_matrix)
%
% life(M,N); generates world of size MxN with random points of life
% life(M,N, sparsity_level) generates world of size MxN with a level of
%                           sparsity between 0 (all points filled) 
%                           to 1 (no points filled)
%
%
%
PAUSE_TIME = 0.3; %number of seconds each time step is presented

%Handle inputs ------------------------------
if size(varargin, 2) == 0
    
    [present fh] = select_input();
    set(fh, 'numbertitle', 'off', 'name', 'Conway''s Game of Life');
    
elseif  size(varargin, 2) == 1 %predefined initial  conditions matrix
    
    present = varargin{1};
    fh = figure('numbertitle', 'off', 'name', 'Conway''s Game of Life');
    
elseif size(varargin, 2) == 2 %predefined size MxN
    
    M = varargin{1};
    N = varargin{2};
    present = rand(M, N) > 0.5;
    fh = figure('numbertitle', 'off', 'name', 'Conway''s Game of Life');
        
elseif size(varargin, 2) == 3 %predefined size and sparsity (or size and selection option)
    
    M = varargin{1};
    N = varargin{2};
    if isnumeric(varargin{3})
        sparsity = varargin{3};
        present = rand(M,N) > sparsity;
        fh = figure('numbertitle', 'off', 'name', 'Conway''s Game of Life');
    elseif strcmp(varargin{3}, 'select')
        [present fh] = select_input(M, N);
        set(fh, 'numbertitle', 'off', 'name', 'Conway''s Game of Life');
    end
    
else
    sprintf('%s', 'Incorrect number of inputs!')
end

%--------------------------------------------

while ishandle(fh)
    
    imagesc(present);
    pause(PAUSE_TIME);
    
    present = update(present);
  
end

end

function future = update(present)

[M N] = size(present); %assumes m, n > 1
future = zeros(M, N); %dead by default (life is shit)

for i = 1:M
    for j = 1:N
        
        if i == 1,      up = i;   down = i+1;   %top row
        elseif i == M,  up = i-1; down = i;     %bottom row
        else            up = i-1; down = i+1;
        end
        
        if j == 1,      left = j;     right = j+1;  %left column
        elseif j == N,  left = j-1; right = j;      %right column
        else            left = j-1; right = j+1;
        end
        
        neighbors = sum(sum(present(up:down, left:right)));
        
        %Check living rules
        if present(i, j)
            
            neighbors = neighbors - 1; %no self counting
            
            %live only if you have exactly 2 or 3 neighbors
            if neighbors == 2 || neighbors == 3
                future(i,j) = 1;
            end
               %future is initialized to death by default 
        else
        %check dead rules
        
            if neighbors == 3
                future(i,j) = 1;
            end    
        end
               
    end
end

end

function [present, fh] = select_input(M, N)

if nargin == 0
    prompt = {'Enter matrix height:', 'Enter matrix width:'};
    dlg_title = 'World Size';
    numLines = 1;
    default = {'20', '20'};
    answer = inputdlg(prompt,dlg_title,numLines,default);
    
    M = str2double(answer{1});
    N = str2double(answer{2});
end


present = zeros(M, N);
finishedSelection = false;
fh = figure('numbertitle', 'off', 'name', 'Press Enter to Start...');

while ~finishedSelection


    imagesc(present);
    [j i] = myginput(1, 'crosshair');
    
    if size(j,1) > 0 %if a value was selected
        
        if present(round(i), round(j)) == 0
            present(round(i),round(j)) = 1;
        else
            present(round(i), round(j)) = 0;
        end
    else
        finishedSelection = true;
    end

end

end
