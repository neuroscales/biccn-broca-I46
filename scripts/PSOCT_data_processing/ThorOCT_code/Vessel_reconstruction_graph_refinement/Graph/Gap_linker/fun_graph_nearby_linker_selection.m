function valid_linker_str = fun_graph_nearby_linker_selection(valid_linker_str, dist_th)
% fun_graph_nearby_linker_selection finds the linker pairs who have nearby
% endpoints, select the linker that are shorter and brighter. 
% Input: 
%   valid_linker_str: structure array, each structure is generated by
%   fun_graph_connect_gap_p2p. 
%   dist_th: only consider then linker pairs whose endpoint distance is
%   not greater than this value. 
% Output: 
%   valid_linker_str: structure array, part of the input structure array.

if nargin < 2
    dist_th = 10;
end
if isempty(valid_linker_str)
    return;
end
% Find the nearby link pair for selection 
linker_pair_idx_to_select = fun_graph_nearby_point_pairs_idx(cat(1, valid_linker_str.ep_1_sub), ...
    cat(1, valid_linker_str.ep_2_sub), dist_th);
tmp_keep_Q = true(numel(valid_linker_str), 1);
for iter_pair = 1 : size(linker_pair_idx_to_select, 1)
    tmp_idx_1 = linker_pair_idx_to_select(iter_pair, 1);
    tmp_idx_2 = linker_pair_idx_to_select(iter_pair, 2);
    tmp_str1 = valid_linker_str(tmp_idx_1);
    tmp_str2 = valid_linker_str(tmp_idx_2);
    if tmp_str1.num_voxel < tmp_str2.num_voxel
        % Keep the shorter one
        tmp_keep_Q(tmp_idx_2) = false;
        continue;
    elseif tmp_str1.num_voxel > tmp_str2.num_voxel
        tmp_keep_Q(tmp_idx_1) = false;
        continue;
    else
        if tmp_str1.int_mean > tmp_str2.int_mean
            % Keep the brighter one
            tmp_keep_Q(tmp_idx_2) = false;
            continue;
        else
            tmp_keep_Q(tmp_idx_1) = false;
            continue;
        end
    end
end
valid_linker_str = valid_linker_str(tmp_keep_Q);
end