function [ p ] = classification2( instance )
%classification4 Classifies the given instance based on training data from
%Johanna and Matze.

% attribute 1: provider speed
% attribute 2: calculated speed
% attribute 3: peak amplitude
% attribute 4: spectral energy (1-5Hz)
% attribute 5: AR coefficient 2
% classes = 'Auto, Rad, Gehen, Ubahn, Tram, Zug, Still, Error';

instance(10:end) = []; %AR coeff 3, FFT coefficients
instance(8) = []; %AR coefficient 1
instance(5) = []; %variance
instance(4) = []; %mean
instance(1) = []; %timestamp

p = N35ace71b0(instance)+1; % +1, weil Java bei 0, Matlab bei 1 anfängt zu zählen

    function p = N35ace71b0(instance)
        p = NaN;
        if isnan(instance(2))
        p = 8; % Error
        elseif ( instance(2) <= 8.61948)
            p = N6a78b9241(instance);
        elseif ( instance(2) > 8.61948)
            p = N5a2168447(instance);
        end
        
    end
    function p = N6a78b9241(instance)
        p = NaN;
        if isnan(instance(2))
        p = 8; % Error
        elseif ( instance(2) <= 0.9)
            p = N1bc321182(instance);
        elseif ( instance(2) > 0.9)
            p = N5e872bf4(instance);
        end
        
    end
    function p = N1bc321182(instance)
        p = NaN;
        if isnan(instance(1))
        p = 8; % Error
        elseif ( instance(1) <= -1.0)
            p = 6;
        elseif ( instance(1) > -1.0)
            p = N27b1bce53(instance);
        end
        
    end
    function p = N27b1bce53(instance)
        p = NaN;
        if isnan(instance(4))
        p = 8; % Error
        elseif ( instance(4) <= 12.93607)
            p = 6;
        elseif ( instance(4) > 12.93607)
            p = 1;
        end
        
    end
    function p = N5e872bf4(instance)
        p = NaN;
        if isnan(instance(3))
        p = 8; % Error
        elseif ( instance(3) <= 10.73869)
            p = N5fc55ca05(instance);
        elseif ( instance(3) > 10.73869)
            p = 2;
        end
        
    end
    function p = N5fc55ca05(instance)
        p = NaN;
        if isnan(instance(3))
        p = 8; % Error
        elseif ( instance(3) <= 9.65752)
            p = 0;
        elseif ( instance(3) > 9.65752)
            p = N16443d7f6(instance);
        end
        
    end
    function p = N16443d7f6(instance)
        p = NaN;
        if isnan(instance(1))
        p = 8; % Error
        elseif ( instance(1) <= 1.42097)
            p = 2;
        elseif ( instance(1) > 1.42097)
            p = 0;
        end
        
    end
    function p = N5a2168447(instance)
        p = NaN;
        if isnan(instance(1))
        p = 8; % Error
        elseif ( instance(1) <= 0.33333)
            p = N474476968(instance);
        elseif ( instance(1) > 0.33333)
            p = N7626fb7a18(instance);
        end
        
    end
    function p = N474476968(instance)
        p = NaN;
        if isnan(instance(2))
        p = 8; % Error
        elseif ( instance(2) <= 18.32905)
            p = N5fc596679(instance);
        elseif ( instance(2) > 18.32905)
            p = N73d3905315(instance);
        end
        
    end
    function p = N5fc596679(instance)
        p = NaN;
        if isnan(instance(5))
        p = 8; % Error
        elseif ( instance(5) <= -2.2987)
            p = 4;
        elseif ( instance(5) > -2.2987)
            p = N2515755010(instance);
        end
        
    end
    function p = N2515755010(instance)
        p = NaN;
        if isnan(instance(4))
        p = 8; % Error
        elseif ( instance(4) <= 12.71892)
            p = N23c8ea3511(instance);
        elseif ( instance(4) > 12.71892)
            p = N39972c2614(instance);
        end
        
    end
    function p = N23c8ea3511(instance)
        p = NaN;
        if isnan(instance(2))
        p = 8; % Error
        elseif ( instance(2) <= 17.06075)
            p = N5b884fed12(instance);
        elseif ( instance(2) > 17.06075)
            p = 3;
        end
        
    end
    function p = N5b884fed12(instance)
        p = NaN;
        if isnan(instance(2))
        p = 8; % Error
        elseif ( instance(2) <= 9.70278)
            p = 3;
        elseif ( instance(2) > 9.70278)
            p = N52377f8d13(instance);
        end
        
    end
    function p = N52377f8d13(instance)
        p = NaN;
        if isnan(instance(3))
        p = 8; % Error
        elseif ( instance(3) <= 13.20599)
            p = 0;
        elseif ( instance(3) > 13.20599)
            p = 1;
        end
        
    end
    function p = N39972c2614(instance)
        p = NaN;
        if isnan(instance(2))
        p = 8; % Error
        elseif ( instance(2) <= 13.64825)
            p = 3;
        elseif ( instance(2) > 13.64825)
            p = 4;
        end
        
    end
    function p = N73d3905315(instance)
        p = NaN;
        if isnan(instance(5))
        p = 8; % Error
        elseif ( instance(5) <= -2.00447)
            p = 3;
        elseif ( instance(5) > -2.00447)
            p = N46a8748d16(instance);
        end
        
    end
    function p = N46a8748d16(instance)
        p = NaN;
        if isnan(instance(4))
        p = 8; % Error
        elseif ( instance(4) <= 13.46327)
            p = 0;
        elseif ( instance(4) > 13.46327)
            p = N5d7bf93817(instance);
        end
        
    end
    function p = N5d7bf93817(instance)
        p = NaN;
        if isnan(instance(3))
        p = 8; % Error
        elseif ( instance(3) <= 10.79494)
            p = 5;
        elseif ( instance(3) > 10.79494)
            p = 0;
        end
        
    end
    function p = N7626fb7a18(instance)
        p = NaN;
        if isnan(instance(5))
        p = 8; % Error
        elseif ( instance(5) <= -1.44266)
            p = N7948432f19(instance);
        elseif ( instance(5) > -1.44266)
            p = N26dc83dd23(instance);
        end
        
    end
    function p = N7948432f19(instance)
        p = NaN;
        if isnan(instance(3))
        p = 8; % Error
        elseif ( instance(3) <= 10.40028)
            p = N773300dd20(instance);
        elseif ( instance(3) > 10.40028)
            p = N357dea4e21(instance);
        end
        
    end
    function p = N773300dd20(instance)
        p = NaN;
        if isnan(instance(4))
        p = 8; % Error
        elseif ( instance(4) <= 12.84301)
            p = 0;
        elseif ( instance(4) > 12.84301)
            p = 4;
        end
        
    end
    function p = N357dea4e21(instance)
        p = NaN;
        if isnan(instance(1))
        p = 8; % Error
        elseif ( instance(1) <= 1.91667)
            p = N5da1c25122(instance);
        elseif ( instance(1) > 1.91667)
            p = 1;
        end
        
    end
    function p = N5da1c25122(instance)
        p = NaN;
        if isnan(instance(3))
        p = 8; % Error
        elseif ( instance(3) <= 12.97037)
            p = 0;
        elseif ( instance(3) > 12.97037)
            p = 2;
        end
        
    end
    function p = N26dc83dd23(instance)
        p = NaN;
        if isnan(instance(4))
        p = 8; % Error
        elseif ( instance(4) <= 12.88476)
            p = N5755361924(instance);
        elseif ( instance(4) > 12.88476)
            p = N59dc68f926(instance);
        end
        
    end
    function p = N5755361924(instance)
        p = NaN;
        if isnan(instance(3))
        p = 8; % Error
        elseif ( instance(3) <= 11.71924)
            p = 0;
        elseif ( instance(3) > 11.71924)
            p = N1b52d01a25(instance);
        end
        
    end
    function p = N1b52d01a25(instance)
        p = NaN;
        if isnan(instance(1))
        p = 8; % Error
        elseif ( instance(1) <= 4.7)
            p = 1;
        elseif ( instance(1) > 4.7)
            p = 0;
        end
        
    end
    function p = N59dc68f926(instance)
        p = NaN;
        if isnan(instance(3))
        p = 8; % Error
        elseif ( instance(3) <= 11.63579)
            p = N156fe18627(instance);
        elseif ( instance(3) > 11.63579)
            p = N7041884229(instance);
        end
        
    end
    function p = N156fe18627(instance)
        p = NaN;
        if isnan(instance(4))
        p = 8; % Error
        elseif ( instance(4) <= 13.10349)
            p = N643f2f6828(instance);
        elseif ( instance(4) > 13.10349)
            p = 4;
        end
        
    end
    function p = N643f2f6828(instance)
        p = NaN;
        if isnan(instance(5))
        p = 8; % Error
        elseif ( instance(5) <= -0.93551)
            p = 0;
        elseif ( instance(5) > -0.93551)
            p = 4;
        end
        
    end
    function p = N7041884229(instance)
        p = NaN;
        if isnan(instance(1))
        p = 8; % Error
        elseif ( instance(1) <= 3.33333)
            p = 1;
        elseif ( instance(1) > 3.33333)
            p = 0;
        end
        
    end
end