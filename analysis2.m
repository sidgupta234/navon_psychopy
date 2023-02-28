% load data from 1.mat and 2.mat
table1 = load('matlab_exp_data/1.mat');
table2 = load('matlab_exp_data/2.mat');
table3 = load('matlab_exp_data/3.mat');
table4 = load('matlab_exp_data/4.mat');
table5 = load('matlab_exp_data/5.mat');
% concatenate tables from 1.mat and 2.mat
combinedTable = vertcat(table1.final_table, table2.final_table, table3.final_table,table4.final_table, ...
    table5.final_table);
groupedTable_code_time = groupsummary(combinedTable, 'response_code');
h = bar(groupedTable_code_time.response_code, groupedTable_code_time.GroupCount);
h.FaceAlpha = 0.05
possibilities = {'Incorrect other', 'Incorrect local', 'Time out', 'Correct'}
xticklabels(possibilities)
xlabel('Code');
ylabel('Count');
title('Count Response per Code');
%legend('reaction time')
groupedTable_code_time = groupsummary(combinedTable, 'response_code', 'mean', 'response_time');

% create bar chart of mean response time by file_name
%bar(str2num(groupedTable.response_code),s
%groupedTable.mean_response_time);s
%hold on
p = bar(groupedTable_code_time.response_code, groupedTable_code_time.mean_response_time);
possibilities = {'Incorrect other', 'Incorrect local', 'Time out', 'Correct'}
%xticks(1:6)
xticklabels(possibilities)
xlabel('Code');
ylabel('Mean Response Time (sec)');
title('Mean Response Time per code');
%legend('frequency', 'reaction time')
% response legend
% % 0-Incorrect other, 1-Incorrect local, 2-Time Out, 3-Correct
% combinedTable = vertcat(table1.final_table, table2.final_table);
