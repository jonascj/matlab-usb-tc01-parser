function [t T desc dt] = parse_temp_log(file)

    [fid msg] = fopen(file, 'rt');
    
    % Get dt from log line 5
    % "Logging Interval:	3 second(s)"
    % * means do not store/keep
    c = textscan(fid, '%*s %*s %d %*s', 1, 'headerlines', 4, 'delimiter', [' ', '\t']);
    dt = c{1};
    
    % Multi line description from line 6 and until "Time\t Temp" is found
    c = {};
    tline = fgetl(fid);
    while ischar(tline)
        if strncmp(tline, 'Time', 4)
            break
        
        elseif ~strcmp('', tline)
            c{end+1} = tline;
            
        end
        tline = fgetl(fid);
    end
    
    c{1} = strrep(c{1}, sprintf('Description:\t'), '')
    
    
    desc = sprintf('%s\n',c{:})
  
    % Get temperatures
    % "1:56:33 PM	30.6"
    C = textscan(fid, '%*s %f', 'delimiter', '\t');
    T = C{1};

    % Times are now given by the lengt of T and dt
    t = 0:dt:(length(T)-1)*dt;
    t = double(t');


end