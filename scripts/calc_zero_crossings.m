function [ zero_crossings_matrix ] = calc_zero_crossings( cwt_gauss, zero_crossings_matrix )
% Calculate zero crossings in cwt_gauss with the help of crossing.m from
% MATLAB file exchange: 
% http://www.mathworks.com/matlabcentral/fileexchange/2432-crossing/content/crossing.m

for i=1:size(cwt_gauss,1)
    row = crossing(cwt_gauss(i,:));
    zero_crossings_matrix(i,row) = 1;
end

end

