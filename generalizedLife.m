nDims = 3;
stateEdge = 3;
nBits = stateEdge.^nDims;
nStates = 2.^nBits;
% nRules = 2.^nStates;
%%
spaceEdge = 10;
if nDims == 1,
    spaceSize = [spaceEdge,1];
    stateEdge = [stateEdge, 1];
else
    spaceSize = repmat(spaceEdge,1,nDims);
end;
%%
rule = 1;
%%
%space = logical(randi([0 1],spaceSize));
space = zeros(spaceSize);
 rule = fliplr(dec2bin(rule,nStates));
tempSpace = cell(1,nStates);
iter = 0;
while 1
    if nDims == 2
    imagesc(space);
    drawnow;
    else
        inds = find(space);
        clf;
        axis([0 spaceEdge 0 spaceEdge 0 spaceEdge]);
        for i = 1:numel(inds)
            [x, y, z] = ind2sub([spaceEdge,spaceEdge,spaceEdge], inds(i));
            voxel([x y z] - 1, [1, 1, 1], 'r', 0.125);
        end
        
    end
    n = 1000;
    tic
    for r = 0:n-1
        template = ones(stateEdge.*ones(1,nDims)).*(1./(nBits+1));
        highBits = regexp(dec2bin(r,nBits),'1');
        template(highBits)=1;
        %(could add repmat here to do a 'toroidal' convolution)
%         disp('conv start');
        reckoning = convn(space,template,'same');
%         disp('conv done');
        tempSpace{r+1} =  false(size(space));
        tempSpace{r+1}(reckoning==numel(highBits)) = logical(str2double(rule(r+1)));
    end;
    toc
    disp('states complete');
    space = sum(cat(nDims+1,tempSpace{1:n}),nDims+1);
    pause;
    %iter = iter+1
end;
    