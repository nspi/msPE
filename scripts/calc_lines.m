function [ sign_matrix, u01Lines ] = calc_lines( zero_crossings_matrix, sign_matrix, numScales, sign, u01Lines)
% Calculate zero-crossing lines

if (sign==1)
    u01Lines = [];
else
    u02Lines = [];
end

for n=1:size(zero_crossings_matrix,2)-1
    
    if (zero_crossings_matrix(1,n) == 1)
        line = true; n_old=n; m_new = 1;
        
        while (line==true) n_old=n;
            
            if (n<16 | n>size(zero_crossings_matrix,2)-16)
                break;
            end
            
            % detect zero crossings in next scale
            if (zero_crossings_matrix(m_new+1,n))   == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n;  m_new = m_new+1; n = n;
            elseif (zero_crossings_matrix(m_new+1,n-1)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-1;  m_new = m_new+1; n = n-1;
            elseif (zero_crossings_matrix(m_new+1,n+1)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+1;  m_new = m_new+1; n = n+1;
            elseif (zero_crossings_matrix(m_new+1,n-2)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-2;  m_new = m_new+1; n = n-2;
            elseif (zero_crossings_matrix(m_new+1,n+2)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+2;  m_new = m_new+1; n = n+2;
            elseif (zero_crossings_matrix(m_new+1,n-3)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-3;  m_new = m_new+1; n = n-3;
            elseif (zero_crossings_matrix(m_new+1,n+3)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+3;  m_new = m_new+1; n = n+3;
            elseif (zero_crossings_matrix(m_new+1,n-4)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-4;  m_new = m_new+1; n = n-4;
            elseif (zero_crossings_matrix(m_new+1,n+4)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+4;  m_new = m_new+1; n = n+4;
            elseif (zero_crossings_matrix(m_new+1,n-5)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-5;  m_new = m_new+1; n = n-5;
            elseif (zero_crossings_matrix(m_new+1,n+5)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+5;  m_new = m_new+1; n = n+5;
            elseif (zero_crossings_matrix(m_new+1,n-6)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-6;  m_new = m_new+1; n = n-6;
            elseif (zero_crossings_matrix(m_new+1,n+6)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+6;  m_new = m_new+1; n = n+6;
            elseif (zero_crossings_matrix(m_new+1,n-7)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-7;  m_new = m_new+1; n = n-7;
            elseif (zero_crossings_matrix(m_new+1,n+7)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+7;  m_new = m_new+1; n = n+7;
            elseif (zero_crossings_matrix(m_new+1,n-8)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-8;  m_new = m_new+1; n = n-8;
            elseif (zero_crossings_matrix(m_new+1,n+8)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+8;  m_new = m_new+1; n = n+8;
            elseif (zero_crossings_matrix(m_new+1,n-9)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-9;  m_new = m_new+1; n = n-9;
            elseif (zero_crossings_matrix(m_new+1,n+9)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+9;  m_new = m_new+1; n = n+9;
            elseif (zero_crossings_matrix(m_new+1,n-10)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-10;  m_new = m_new+1; n = n-10;
            elseif (zero_crossings_matrix(m_new+1,n+10)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+10;  m_new = m_new+1; n = n+10;
            elseif (zero_crossings_matrix(m_new+1,n-11)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-11;  m_new = m_new+1; n = n-11;
            elseif (zero_crossings_matrix(m_new+1,n+11)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+11;  m_new = m_new+1; n = n+11;
            elseif (zero_crossings_matrix(m_new+1,n-12)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-12;  m_new = m_new+1; n = n-12;
            elseif (zero_crossings_matrix(m_new+1,n+12)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+12;  m_new = m_new+1; n = n+12;
            elseif (zero_crossings_matrix(m_new+1,n-13)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-13;  m_new = m_new+1; n = n-13;
            elseif (zero_crossings_matrix(m_new+1,n+13)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+13;  m_new = m_new+1; n = n+13;
            elseif (zero_crossings_matrix(m_new+1,n-14)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-14;  m_new = m_new+1; n = n-14;
            elseif (zero_crossings_matrix(m_new+1,n+14)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+14;  m_new = m_new+1; n = n+14;
            elseif (zero_crossings_matrix(m_new+1,n-15)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n-15;  m_new = m_new+1; n = n-15;
            elseif (zero_crossings_matrix(m_new+1,n+15)) == 1;
                pos(m_new,1) = m_new+1; pos(m_new,2) = n+15;  m_new = m_new+1; n = n+15;
            else
                line=false; n = n_old;
            end
            
            % store line if last scale is reached
            if (m_new==numScales)
                
                if sign == 1
                    u01Lines = [u01Lines pos(:,2)];
                else
                    u02Lines = [u02Lines pos(:,2)];
                end
                
                break;
            end
            
        end
        
    else
        line = false;
    end
    
end

% Detect WT1 mu line
if (sign == 1) && (~isempty(u01Lines))
    
    EP = u01Lines(end, :);          % endpoints
    idx = [1:size(u01Lines,2)];
    V = var( u01Lines(numScales/2:end, idx )); % compute variance
    [~, mu_idx] = min( V ); % get index of line with lowest var.
    mu_line_idx = EP(idx(mu_idx));
    
    % store line
    pos = u01Lines(:, idx(mu_idx));
    for (k=1:size(pos,1))
        sign_matrix( k + 1, pos(k)) = 1;
    end
    u01Lines = u01Lines(:, idx(mu_idx));
    
end

% Detect WT2 lines left and right of WT1 line
if (sign == 2) && (~isempty(u01Lines)) && (~isempty(u02Lines))
    
    EP_WT1 = u01Lines(end, :);          % endpoints
    EP_WT2 = u02Lines(end, :);          % endpoints
    [~, idx,~] = unique(EP_WT2);        % indices of all unique lines
    EP_WT2 = u02Lines(end, idx );
    
    % find left line
    [~,WT2_left_idx] = min(abs( EP_WT1 - EP_WT2(EP_WT2<EP_WT1)));
    [~,WT2_right_idx] = min(abs( EP_WT1 - EP_WT2(EP_WT2>EP_WT1)));
    WT2_right_idx = WT2_right_idx +  numel(EP_WT2(EP_WT2<=EP_WT1));
    
    % store lines
    if (~isempty(WT2_left_idx))
        pos = u02Lines(:, idx(WT2_left_idx));
        for (k=1:size(pos,1))
            sign_matrix( k + 1, pos(k)) = 2;
        end
    end
    
    % store lines
    if (~isempty(WT2_right_idx))
        pos = u02Lines(:, idx(WT2_right_idx));
        for (k=1:size(pos,1))
            sign_matrix( k + 1, pos(k)) = 2;
        end
    end
    
end

end

