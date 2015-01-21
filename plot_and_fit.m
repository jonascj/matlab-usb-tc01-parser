function [fh slope] = plot_and_fit(file, figh)

    % Scale (right now sec to min)
    s = 1/60;


    % If a valid figure handle is provided use it for plotting
    if ishandle(figh) && strcmp(get(figh,'type'),'figure')
        figure(figh)
        fh = figh;
        clf
    else
        fh = figure();
    end

    % % Parse the temperature log file
    [t T desc dt] = parse_temp_log(file);
    
    % % seconds to minutes
    t = t*s;
    
    % % Plot the (t,T) curve
    ph_data = plot(t,T, '.b');
    xlabel('Time [min]','interpreter', 'latex', 'fontsize', 18)
    ylabel('Temperature [$^\circ C$]', 'interpreter', 'latex', 'fontsize', 18)
    hleg=legend('Data');
    set(hleg,'fontsize',14);
    title(strrep(desc, sprintf('\n'), ' | '));
    
    
    % % Rectangular selection used for selecting fitting region
    rect = getrect(fh);
    
    xmin = rect(1);
    ymin = rect(2);
    width = rect(3);
    height = rect(4);
    
     
    idx_low = floor( xmin / (2*s) ) + 1;
    if idx_low <= 0
        idx_low = 1;
    end
        
    idx_high = idx_low + floor( width / (2*s) );
    if idx_high > max(t) / (2*s)
        idx_high = max(t) / (2*s);
    end
    
    idx = idx_low:idx_high;
    
    % % Filter the indices based on y-coordinates of the rectangle 
    idx = idx(ymin < T(idx) & T(idx) < ymin+height);
    
    % % Mark the points used for fitting
    hold on;
    plot(t(idx), T(idx), '+g')
    
    % % Fit and plot fit
    p = polyfit(t(idx), T(idx), 1);
    
    slope = p(1);
    fit_legend = sprintf('Slope: $%0.3f ^\\circ \\mathrm{C/min}$',slope);
    
    T_fit = polyval(p,t(idx) );
    
    hold on;
    ph_fit = plot(t(idx), T_fit, '-r', 'linewidth', 2);
    legend([ph_data, ph_fit], {'Data', fit_legend}, 'interpreter', 'latex', 'fontsize', 18)
    

      
    

end

