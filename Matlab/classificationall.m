function [ p ] = classificationall( instance )
%classification4 Classifies the given instance based on training data from
%Johanna and Matze.

% attributes = {'timestamp', 'provider speed', 'calculated speed',...
%     'mean', 'variance','average peak amplitude', 'spectral energy (1-5Hz)',...
%     'AR coefficient 1', 'AR coefficient 2', 'AR coefficient 3',...
%     'FFT coeff 1Hz', 'FFT coeff 2Hz', 'FFT coeff 3Hz', 'FFT coeff 4Hz'};

% attribute 1: provider speed
% attribute 2: calculated speed
% attribute 3: mean
% attribute 4: variance
% attribute 5: peak amplitude
% attribute 6: spectral energy (1-5Hz)
% attribute 7: AR coefficient 2
% attribute 8: FFT coeff 2Hz
% attribute 9: FFT coeff 3Hz
% attribute 10: FFT coeff 4Hz
% classes = 'Auto, Rad, Gehen, Ubahn, Tram, Zug, Still, Error';

instance(10:11) = []; %AR coeff 3, FFT coefficient 1Hz
instance(8) = []; %AR coefficient 1
instance(1) = []; %timestamp

p = N440a18950(instance)+1; % +1, weil Java bei 0, Matlab bei 1 anfängt zu zählen

    function p = N440a18950(instance)
        p = NaN;
        if isnan(instance(1+1))
            p = 2;
        elseif (instance(1+1) <= 8.61948)
            p = N72d401181(instance);
        elseif (instance(1+1) > 8.61948)
            p = N165b28ba8(instance);
        end

    end
    function p = N72d401181(instance)
        p = NaN;
        if isnan(instance(1+1))
            p = 6;
        elseif (instance(1+1) <= 0.9)
            p = N3c94098d2(instance);
        elseif (instance(1+1) > 0.9)
            p = N655cd4534(instance);
        end

    end
    function p = N3c94098d2(instance)
        p = NaN;
        if isnan(instance(0+1))
            p = 6;
        elseif (instance(0+1) <= -1.0)
            p = 6;
        elseif (instance(0+1) > -1.0)
            p = N1aff270d3(instance);
        end

    end
    function p = N1aff270d3(instance)
        p = NaN;
        if isnan(instance(2+1))
            p = 6;
        elseif (instance(2+1) <= 9.56432)
            p = 6;
        elseif (instance(2+1) > 9.56432)
            p = 1;
        end

    end
    function p = N655cd4534(instance)
        p = NaN;
        if isnan(instance(7+1))
            p = 0;
        elseif (instance(7+1) <= 0.00141)
            p = N3177c9225(instance);
        elseif (instance(7+1) > 0.00141)
            p = N2f35f08d6(instance);
        end

    end
    function p = N3177c9225(instance)
        p = NaN;
        if isnan(instance(2+1))
            p = 0;
        elseif (instance(2+1) <= 9.3934)
            p = 0;
        elseif (instance(2+1) > 9.3934)
            p = 2;
        end

    end
    function p = N2f35f08d6(instance)
        p = NaN;
        if isnan(instance(3+1))
            p = 2;
        elseif (instance(3+1) <= 1.91123)
            p = N7e43d1317(instance);
        elseif (instance(3+1) > 1.91123)
            p = 2;
        end

    end
    function p = N7e43d1317(instance)
        p = NaN;
        if isnan(instance(6+1))
            p = 1;
        elseif (instance(6+1) <= -2.17565)
            p = 1;
        elseif (instance(6+1) > -2.17565)
            p = 2;
        end

    end
    function p = N165b28ba8(instance)
        p = NaN;
        if isnan(instance(8+1))
            p = 3;
        elseif (instance(8+1) <= 0.01659)
            p = N3aced6cd9(instance);
        elseif (instance(8+1) > 0.01659)
            p = N38a8fd2f26(instance);
        end

    end
    function p = N3aced6cd9(instance)
        p = NaN;
        if isnan(instance(0+1))
            p = 3;
        elseif (instance(0+1) <= -1.0)
            p = N61784ae410(instance);
        elseif (instance(0+1) > -1.0)
            p = N8dd765919(instance);
        end

    end
    function p = N61784ae410(instance)
        p = NaN;
        if isnan(instance(1+1))
            p = 3;
        elseif (instance(1+1) <= 18.32905)
            p = N207cf0ba11(instance);
        elseif (instance(1+1) > 18.32905)
            p = N5c7032be16(instance);
        end

    end
    function p = N207cf0ba11(instance)
        p = NaN;
        if isnan(instance(6+1))
            p = 4;
        elseif (instance(6+1) <= -2.2987)
            p = 4;
        elseif (instance(6+1) > -2.2987)
            p = N6aa053ff12(instance);
        end

    end
    function p = N6aa053ff12(instance)
        p = NaN;
        if isnan(instance(1+1))
            p = 3;
        elseif (instance(1+1) <= 12.94757)
            p = N43eac10913(instance);
        elseif (instance(1+1) > 12.94757)
            p = N692758b414(instance);
        end

    end
    function p = N43eac10913(instance)
        p = NaN;
        if isnan(instance(2+1))
            p = 0;
        elseif (instance(2+1) <= 9.44711)
            p = 0;
        elseif (instance(2+1) > 9.44711)
            p = 3;
        end

    end
    function p = N692758b414(instance)
        p = NaN;
        if isnan(instance(1+1))
            p = 0;
        elseif (instance(1+1) <= 17.86557)
            p = N1630c75b15(instance);
        elseif (instance(1+1) > 17.86557)
            p = 3;
        end

    end
    function p = N1630c75b15(instance)
        p = NaN;
        if isnan(instance(2+1))
            p = 0;
        elseif (instance(2+1) <= 9.70305)
            p = 0;
        elseif (instance(2+1) > 9.70305)
            p = 4;
        end

    end
    function p = N5c7032be16(instance)
        p = NaN;
        if isnan(instance(6+1))
            p = 3;
        elseif (instance(6+1) <= -2.00447)
            p = 3;
        elseif (instance(6+1) > -2.00447)
            p = N4a13875b17(instance);
        end

    end
    function p = N4a13875b17(instance)
        p = NaN;
        if isnan(instance(2+1))
            p = 0;
        elseif (instance(2+1) <= 9.74777)
            p = 0;
        elseif (instance(2+1) > 9.74777)
            p = N481b8d5b18(instance);
        end

    end
    function p = N481b8d5b18(instance)
        p = NaN;
        if isnan(instance(3+1))
            p = 5;
        elseif (instance(3+1) <= 0.23415)
            p = 5;
        elseif (instance(3+1) > 0.23415)
            p = 0;
        end

    end
    function p = N8dd765919(instance)
        p = NaN;
        if isnan(instance(2+1))
            p = 0;
        elseif (instance(2+1) <= 9.54799)
            p = N384d19b20(instance);
        elseif (instance(2+1) > 9.54799)
            p = N30df7a3b23(instance);
        end

    end
    function p = N384d19b20(instance)
        p = NaN;
        if isnan(instance(3+1))
            p = 0;
        elseif (instance(3+1) <= 0.25209)
            p = 0;
        elseif (instance(3+1) > 0.25209)
            p = N4dd18eb21(instance);
        end

    end
    function p = N4dd18eb21(instance)
        p = NaN;
        if isnan(instance(1+1))
            p = 1;
        elseif (instance(1+1) <= 25.09763)
            p = N4f8eeecb22(instance);
        elseif (instance(1+1) > 25.09763)
            p = 0;
        end

    end
    function p = N4f8eeecb22(instance)
        p = NaN;
        if isnan(instance(3+1))
            p = 0;
        elseif (instance(3+1) <= 0.30402)
            p = 0;
        elseif (instance(3+1) > 0.30402)
            p = 1;
        end

    end
    function p = N30df7a3b23(instance)
        p = NaN;
        if isnan(instance(7+1))
            p = 4;
        elseif (instance(7+1) <= 0.00387)
            p = 4;
        elseif (instance(7+1) > 0.00387)
            p = N1fd1d08e24(instance);
        end

    end
    function p = N1fd1d08e24(instance)
        p = NaN;
        if isnan(instance(6+1))
            p = 1;
        elseif (instance(6+1) <= -1.51957)
            p = N7d32af425(instance);
        elseif (instance(6+1) > -1.51957)
            p = 0;
        end

    end
    function p = N7d32af425(instance)
        p = NaN;
        if isnan(instance(9+1))
            p = 1;
        elseif (instance(9+1) <= 0.00486)
            p = 1;
        elseif (instance(9+1) > 0.00486)
            p = 4;
        end

    end
    function p = N38a8fd2f26(instance)
        p = NaN;
        if isnan(instance(0+1))
            p = 2;
        elseif (instance(0+1) <= 1.91667)
            p = N5e8635b827(instance);
        elseif (instance(0+1) > 1.91667)
            p = N58c33cd729(instance);
        end

    end
    function p = N5e8635b827(instance)
        p = NaN;
        if isnan(instance(0+1))
            p = 1;
        elseif (instance(0+1) <= -1.0)
            p = N3d30f38328(instance);
        elseif (instance(0+1) > -1.0)
            p = 2;
        end

    end
    function p = N3d30f38328(instance)
        p = NaN;
        if isnan(instance(3+1))
            p = 0;
        elseif (instance(3+1) <= 2.7225)
            p = 0;
        elseif (instance(3+1) > 2.7225)
            p = 1;
        end

    end
    function p = N58c33cd729(instance)
        p = NaN;
        if isnan(instance(6+1))
            p = 1;
        elseif (instance(6+1) <= -1.40272)
            p = 1;
        elseif (instance(6+1) > -1.40272)
            p = N79cf74c730(instance);
        end

    end
    function p = N79cf74c730(instance)
        p = NaN;
        if isnan(instance(3+1))
            p = 0;
        elseif (instance(3+1) <= 1.12633)
            p = 0;
        elseif (instance(3+1) > 1.12633)
            p = 1;
        end

    end
end