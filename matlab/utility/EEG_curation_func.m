function EEG = EEG_curation_func(EEG_input)
    EEG = EEG_input;
    
    if EEG.nbchan == 113
        Emotiv_data = EEG.data(5:36, :);
        event_line = round(EEG.data(44, :));
    
    elseif EEG.nbchan == 115
        Emotiv_data = EEG.data(7:38, :);
        event_line = round(EEG.data(46, :));
    end

    
    event_type = [];
    event_latency = [];
    event_ur = [];
    n = 0;
    
    for i =1:length(event_line)
        if event_line(i) ~= 0 
            if isempty(event_type) | event_line(i) ~= event_type(end) 
                event_type = [event_type; event_line(i)];
                event_latency = [event_latency; i];
                n = n+1;
                event_ur = [event_ur; n];
            end
        end
    end
    
    for j = 1:length(event_type)
        EEG.event(j).type = event_type(j);
        EEG.event(j).latency = event_latency(j);
        EEG.event(j).urevent = event_ur(j);
    
        EEG.urevent(j).type = event_type(j);
        EEG.urevent(j).latency = event_latency(j);
    end
    
    data_length = size(Emotiv_data, 2);
    
    EEG.data = single(Emotiv_data);
    
    EEG.nbchan = 32;
    
    EEG.pnts = data_length;
    
    EEG.srate = 128;

end
