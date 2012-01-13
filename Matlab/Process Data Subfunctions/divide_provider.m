function [gps, net, gps_accu, net_accu] = divide_provider(provider)
%DIVIDE_PROVIDER sorts location data according to source
%   Divide_provider divides data in provider in gps and network location
%   data ("gps", "net"). In gps_accu and net_accu only data of accuracy
%   better thatn 60m is saved.

%   2 January 2012
%   Johanna Maisel

%% divide provider in gps and network
gps = provider;
net = provider;
gps(any(gps(:,2)==7, 2),:)=[];
net(any(net(:,2)==3, 2),:)=[];

%% delete any points less accurate than 60m
gps_accu = gps;
net_accu = net;
gps_accu(any(gps_accu(:,4)>60, 2),:)=[];
net_accu(any(net_accu(:,4)>60, 2),:)=[];

% fprintf('Done. (divide_provider)\n');

end