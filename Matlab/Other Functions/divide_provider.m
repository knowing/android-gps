function [gps, net] = divide_provider(provider, max_accu)
%DIVIDE_PROVIDER sorts location data according to source
%   Divide_provider divides data in provider in gps and network location
%   data ("gps", "net"). In gps_accu and net_accu only data of accuracy
%   better thatn "acc_max" meters is saved.

%   2 January 2012
%   Johanna Maisel

%% divide provider in gps and network
gps = provider;
net = provider;
gps(any(gps(:,2)==7, 2),:)=[];
net(any(net(:,2)==3, 2),:)=[];

%% delete any points less accurate than "max_accu"
gps(any(gps(:,4)> max_accu, 2),:)=[];
net(any(net(:,4)> max_accu, 2),:)=[];

end