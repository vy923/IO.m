function A = textin(path,strout,eolchar,method)

%{
	> Reads a text file, vectorised
    > Returns a column string or cell array corresponding to file's rows
    > Ignores trailing lines containing only EOL characters

    > No strout returns cell array of char vectors. 
    > NOTE: cellstr(string) is much faster than cellstr(char) 
%}

% Input defaults: string output, no EOL chars
 	if ~exist('eolchar','var') | isempty(eolchar) 	eolchar = 0;        end
    if ~exist('method','var')  | isempty(method)   	method  = 1;     	end
    if  method & eolchar                          	method  = 0;    	end                             
	if ~exist('strout','var') | isempty(strout) 	strout = 1;         end
    if  strout~=1                                   strout = 0;         end   
    
        %fid = fopen(path,'r')
        fid = fopen(path,'r','n','UTF-8');
        %disp('>>> NOTE/textin: change permission to fopen(path,''r'') if needed' );
    
% Whitespace=='', otherwise textscan ignores it at beginning of lines
% By default, endline characters are ignored
    if method                                                                                  
        if strout   A = textscan(fid,'%s','Delimiter',newline,'Whitespace','','TextType','string');
        else        A = textscan(fid,'%s','Delimiter',newline,'Whitespace','','TextType','char');                         
        end
            A = A{1};           
        if eolchar
            if strout   A = join(A,newline);
            else        A = horzcat(char(A),repmat(newline,length(A),1));
            end
        end            
% Legacy format, reading line-by-line
    else
        A = cell.empty;
        while ~feof(fid)
            if eolchar	A{length(A)+1} = fgets(fid);
            else    	A{length(A)+1} = fgetl(fid); 
            end
        end
        A = A';
    end    % if method
    
        fclose(fid);
end





