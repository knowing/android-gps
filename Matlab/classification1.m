function [ p ] = classification1( instance )
%classification2 Classifies the given instance.

% attribute 1: provider speed
% attribute 2: calculated speed
% attribute 3: variance
% attribute 4: spectral energy (1-5Hz)
% attribute 5: AR coefficient 2
% classes = 'Auto, Rad, Gehen, Ubahn, Tram, Zug, Still';

instance(10:end) = []; %AR coeff 3, FFT coefficients
instance(8) = []; %AR coefficient 1
instance(6) = []; %peak amplitude
instance(4) = []; %mean
instance(1) = []; %timestamp

p = N40ba79fd119(instance)+1; % +1, weil Java bei 0, Matlab bei 1 anfängt zu zählen


function p = N40ba79fd119(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 8.61948
        p = N129ef23e120(instance);
    elseif instance(2) > 8.61948
        p = Nbe0eca0123(instance);
    end
    
    end
function p = N129ef23e120(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 0.63134
        p = 6;
    elseif instance(2) > 0.63134
        p = N131cdff121(instance);
    end
    
    end
function p = N131cdff121(instance)
    p = NaN;
    if isnan(instance(3))
        p = 8; % Error
    elseif instance(3) <= 0.17035
        p = N6ccb20f5122(instance);
    elseif instance(3) > 0.17035
        p = 2;
    end
    
    end
function p = N6ccb20f5122(instance)
    p = NaN;
    if isnan(instance(4))
        p = 8; % Error
    elseif instance(4) <= 12.31571
        p = 0;
    elseif instance(4) > 12.31571
        p = 2;
    end
    
    end
function p = Nbe0eca0123(instance)
    p = NaN;
    if isnan(instance(3))
        p = 8; % Error
    elseif instance(3) <= 0.82198
        p = N5bcf0277124(instance);
    elseif instance(3) > 0.82198
        p = N4ad2879e143(instance);
    end
    
    end
function p = N5bcf0277124(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 18.32905
        p = N73ab01b7125(instance);
    elseif instance(2) > 18.32905
        p = N3ae6e6d4137(instance);
    end
    
    end
function p = N73ab01b7125(instance)
    p = NaN;
    if isnan(instance(4))
        p = 8; % Error
    elseif instance(4) <= 13.15854
        p = N5ffdd0b4126(instance);
    elseif instance(4) > 13.15854
        p = N1459b267134(instance);
    end
    
    end
function p = N5ffdd0b4126(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 17.86557
        p = N10910aa8127(instance);
    elseif instance(2) > 17.86557
        p = 3;
    end
    
    end
function p = N10910aa8127(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 8.87429
        p = 3;
    elseif instance(2) > 8.87429
        p = N2252a417128(instance);
    end
    
    end
function p = N2252a417128(instance)
    p = NaN;
    if isnan(instance(5))
        p = 8; % Error
    elseif instance(5) <= -1.51804
        p = N5f92f39b129(instance);
    elseif instance(5) > -1.51804
        p = N4b40fe3f132(instance);
    end
    
    end
function p = N5f92f39b129(instance)
    p = NaN;
    if isnan(instance(5))
        p = 8; % Error
    elseif instance(5) <= -2.00447
        p = N28b77622130(instance);
    elseif instance(5) > -2.00447
        p = N24acc710131(instance);
    end
    
    end
function p = N28b77622130(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 11.00985
        p = 3;
    elseif instance(2) > 11.00985
        p = 4;
    end
    
    end
function p = N24acc710131(instance)
    p = NaN;
    if isnan(instance(3))
        p = 8; % Error
    elseif instance(3) <= 0.26946
        p = 0;
    elseif instance(3) > 0.26946
        p = 1;
    end
    
    end
function p = N4b40fe3f132(instance)
    p = NaN;
    if isnan(instance(5))
        p = 8; % Error
    elseif instance(5) <= -0.67027
        p = 0;
    elseif instance(5) > -0.67027
        p = N17f400b2133(instance);
    end
    
    end
function p = N17f400b2133(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 15.20315
        p = 4;
    elseif instance(2) > 15.20315
        p = 0;
    end
    
    end
function p = N1459b267134(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 12.67105
        p = Nccf92a1135(instance);
    elseif instance(2) > 12.67105
        p = 4;
    end
    
    end
function p = Nccf92a1135(instance)
    p = NaN;
    if isnan(instance(5))
        p = 8; % Error
    elseif instance(5) <= -1.0799
        p = 3;
    elseif instance(5) > -1.0799
        p = Nfa38e99136(instance);
    end
    
    end
function p = Nfa38e99136(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 9.13301
        p = 3;
    elseif instance(2) > 9.13301
        p = 4;
    end
    
    end
function p = N3ae6e6d4137(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 56.03927
        p = Nd3c8682138(instance);
    elseif instance(2) > 56.03927
        p = N16384f1f142(instance);
    end
    
    end
function p = Nd3c8682138(instance)
    p = NaN;
    if isnan(instance(4))
        p = 8; % Error
    elseif instance(4) <= 12.88476
        p = 0;
    elseif instance(4) > 12.88476
        p = Na2c798139(instance);
    end
    
    end
function p = Na2c798139(instance)
    p = NaN;
    if isnan(instance(3))
        p = 8; % Error
    elseif instance(3) <= 0.32988
        p = N3eddcc7b140(instance);
    elseif instance(3) > 0.32988
        p = 0;
    end
    
    end
function p = N3eddcc7b140(instance)
    p = NaN;
    if isnan(instance(4))
        p = 8; % Error
    elseif instance(4) <= 12.99497
        p = N539bbf7b141(instance);
    elseif instance(4) > 12.99497
        p = 4;
    end
    
    end
function p = N539bbf7b141(instance)
    p = NaN;
    if isnan(instance(5))
        p = 8; % Error
    elseif instance(5) <= -1.05016
        p = 0;
    elseif instance(5) > -1.05016
        p = 4;
    end
    
    end
function p = N16384f1f142(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 57.46853
        p = 5;
    elseif instance(2) > 57.46853
        p = 0;
    end
    
    end
function p = N4ad2879e143(instance)
    p = NaN;
    if isnan(instance(1))
        p = 3; % U-Bahn
    elseif instance(1) <= 1.91667
        p = 2;
    elseif instance(1) > 1.91667
        p = N43c5bc72144(instance);
    end
    
    end

function p = N43c5bc72144(instance)
    p = NaN;
    if isnan(instance(3))
        p = 8; % Error
    elseif instance(3) <= 2.133
        p = N6ad70320145(instance);
    elseif instance(3) > 2.133
        p = 1;
    end
    
    end

function p = N6ad70320145(instance)
    p = NaN;
    if isnan(instance(2))
        p = 8; % Error
    elseif instance(2) <= 19.49941
        p = 1;
    elseif instance(2) > 19.49941
        p = N4a0e60ac146(instance);
    end
    
    end
function p = N4a0e60ac146(instance)
    p = NaN;
    if isnan(instance(4))
        p = 8; % Error
    elseif instance(4) <= 13.48227
        p = 0;
    elseif instance(4) > 13.48227
        p = 4;
    end
    
    end
end