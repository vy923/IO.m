%{
-------------------------------------
    Vladimir V. Yotov
    Te Pūnaha Ātea Space Institute
    University of Auckland

    Version: 19.02.2022
-------------------------------------

INPUT
    path        path to some folder F, e.g. 'C:\Users\...\F\'
    numeric     optional
        true    converts data read from char to double
        false   default, A{n} is char

OUTPUT
    A       cell array A{n} is n-th text file from N with numerical name 

%}


function A = multiFileRead(path,numeric)
if nargin<2 || isempty(numeric) 
    numeric = false;
end

% Get folder data
dirCur = pwd;
cd(path);

F = struct2cell(dir(path))';                                                % file data cell
F = char(F(:,1));                                                           % file names 

% Find numeric file names
num = double.empty(0,2);
for i = 1:size(F,1)
    f = F(i,1:find(F(i,:)=='.',1,'last')-1);                                % remove extension
    fnum = str2num(f);
    if ~isempty(fnum)
        num = [num; [i fnum]];                                              % [file number, number in file name]
    end
end

% Sort file names
[~,idxSorted] = sort(num(:,2));
stringID = num(idxSorted,1);

% Read data onto cell A
A = cell(numel(stringID),1);
for i = 1:length(A)
    A{i} = textin(deblank(F(stringID(i),:)));
    if numeric
        A{i} = str2num(char(A{i}));
    end
end

cd(dirCur)








