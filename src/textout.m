%{
-------------------------------------
    Vladimir V. Yotov

    Created: 21.04.2017
    Version: 29.10.2021
-------------------------------------

GENERAL
	Writes a text file, vectorised
	Fastest output if A is a string vector, and no removal of trailing
	whitespaces is required

	NOTE: Does NOT work if A is char array and eol = 1
    
CHANGES
    [03.02.2022] added var 'literal' / 'true' escapes special characters
%}

function textout(A,path,deblankA,append,eolchar,literal)

% Set input variable defaults
    if ~exist('deblankA','var') | isempty(deblankA)     deblankA = false;   end
    if ~exist('append','var') | isempty(append)         append	= false;    end
 	if ~exist('eolchar','var') | isempty(eolchar)     	eolchar	= false;    end
    if ~exist('literal','var') | isempty(literal)     	literal	= false;    end

% Break if char input + eolchar is requested
    if ischar(A) & eolchar 
        disp('WARNING: eolchar = 1 selected with char array input')
        return
%    elseif ischar(A)
%        disp('NOTE: Call with string(A) to prevent removal of trailing whitespaces')
    end

% Default fopen specifier: ensures appropriate EOL chars.
    if append       spec = 'a';
    else            spec = 'w';         end     
    if ~eolchar     spec = [spec 't'];  end

% Select appropriate string joining character
    if eolchar      joinChar = '';
    else            joinChar = newline;
    end

% Write A to path
    fid = fopen(path,spec);
    
        if ischar(A) && ~deblankA
            A(:,size(A,2)+1) = newline;
            A = A';
        else
            if ~isstring(A)     A = string(A);      end
            if  deblankA        A = deblank(A);     end
            A = join(A,joinChar);
        end

        if literal
            fprintf(fid,A);
        else
      	    fprintf(fid,'%s',A);
        end
        
	fclose(fid);  
    
end

%{
	% Old write version
	if ~isstring(A)
       	filestr = join(cellstr(A),joinChar); 
      	fprintf(fid,'%s',filestr{1});
   	else
    	fprintf(fid,'%s',join(A,joinChar));
	end 
%}