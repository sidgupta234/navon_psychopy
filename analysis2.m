% load data from 1.mat and 2.mat
table1 = load('matlab_exp_data/1.mat');
table2 = load('matlab_exp_data/2.mat');

% concatenate tables from 1.mat and 2.mat
combinedTable = vertcat(table1.final_table, table2.final_table);
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
hold on
plot(groupedTable_code_time.response_code, groupedTable_code_time.mean_response_time);
%xlabel('File Name');
%ylabel('Mean Response Time');
%title('Mean Response Time by File Name');
legend('frequency', 'reaction time')
% response legend
% % 0-Incorrect other, 1-Incorrect local, 2-Time Out, 3-Correct
% combinedTable = vertcat(table1.final_table, table2.final_table);
