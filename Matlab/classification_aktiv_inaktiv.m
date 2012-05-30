function [ p ] = classification_aktiv_inaktiv( instance )
%classification2 Classifies the given instance.

% attributes = 'timestamp', 'provider speed', 'calculated speed',...
%     'mean', 'variance','average peak amplitude', 'spectral energy (1-5Hz)',...
%     'AR coefficient 1', 'AR coefficient 2', 'AR coefficient 3',...
%     'FFT coeff 1Hz', 'FFT coeff 2Hz', 'FFT coeff 3Hz', 'FFT coeff 4Hz'end;

% attribute 1: timestamp
% attribute 2: calculated speed
% attribute 3: variance
% attribute 4: peak amplitude
% attribute 5: FFT coefficient 3Hz
% classes = 'Inaktiv, Aktiv, Still, Pause';

instance(14) = []; %FFT coefficient 4
instance(7:12) = []; % spectral energy, AR coefficients, FFT coefficients 1 & 2
instance(4) = []; %mean
instance(2) = []; %timestamp, provider speed

p = begin(instance)+1; % +1, weil Java bei 0, Matlab bei 1 anfängt zu zählen

  function p =  begin(instance) 
    p = NaN;
    if isnan(instance(1)) 
      p = 7; %Error
    elseif (instance(1) == 0) 
      p = 3; % Pause
    elseif (instance(1) ~= 0) 
      p = N60562a700(instance);
    end 
    
  end

  function p =  N60562a700(instance) 
    p = NaN;
    if isnan(instance(2)) 
      p = 7; %Error
    elseif (instance(2) <= 1.2) %eigentlich 0.9
      p = 2; % Still
    elseif (instance(2) > 1.2) %eigentlich 0.9
    p = N2c68160c3(instance);
    end  
  end

  function p =  N2c68160c3(instance) 
    p = NaN;
    if isnan(instance(5)) 
      p = 7; %Error
    elseif (instance(5) <= 0.01659) 
    p = N657f849a4(instance);
    elseif (instance(5) > 0.01659) 
      p = 1; % Aktiv
    end 
  end

  function p =  N657f849a4(instance) 
    p = NaN;
    if isnan(instance(5)) 
      p = 7; %Error
    elseif (instance(5) <= 0.00477) 
      p = 0; %Inaktiv
    elseif (instance(5) > 0.00477) 
    p = N16dace855(instance);
    end 
  end

  function p =  N16dace855(instance) 
    p = NaN;
    if isnan(instance(2)) 
      p = 7; %Error
    elseif (instance(2) <= 8.085) 
      p = 1; %Aktiv
    elseif (instance(2) > 8.085) 
    p = N772c897b6(instance);
    end 
  end

  function p =  N772c897b6(instance) 
    p = NaN;
    if isnan(instance(3)) 
      p = 7; %Error
    elseif (instance(3) <= 0.12295) 
    p = Ncf6275d7(instance);
    elseif (instance(3) > 0.12295) 
      p = 0; %Inaktiv
    end 
  end

  function p =  Ncf6275d7(instance) 
    p = NaN;
    if isnan(instance(4)) 
      p = 7; %Error
    elseif (instance(4) <= 10.49395) 
      p = 0; %Inaktiv
    elseif (instance(4) > 10.49395) 
      p = 1; %Aktiv
    end 
  end

end
