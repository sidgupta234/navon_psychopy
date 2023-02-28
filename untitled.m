% Clear the workspace and the screen
close all;
clear;
sca

% Create a Psychtoolbox dialog box
prompt = {'Enter PID:', 'Enter age:'};
dlgtitle = 'Personal Information';
dims = [1 50];
definput = {'', ''};
options = struct('Resize','on');    

% Display the dialog box and wait for user input
answer = inputdlg(prompt, dlgtitle, dims, definput, options);

% Save the input to variables   
pid = answer{1};
age = str2double(answer{2});

% Check that age is a valid number
if isnan(age)
    error('Invalid age entered. Please enter a number.');
end

% Display the input to the user
disp(['PID: ' pid]);
disp(['Age: ' num2str(age)]);

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 0)
KbName('UnifyKeyNames')
% Get the screen numbers
screens = Screen('Screens');

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% Draw text in the upper portion of the screen with the default font in red
%Screen('TextSize', window, 70);
%DrawFormattedText(window, 'Hello World', 'center',...
%    screenYpixels * 0.25, [1 0 0]);

%Read csv

% Define the path to the CSV file
csvPath = 'navon_dataset.csv';

% Read the CSV file using the built-in MATLAB function
csvData = readtable(csvPath);
nRows = height(csvData);
permutedIndices = randperm(nRows);
csvData = csvData(permutedIndices, :);

% Extract the 'text' column from the CSV data
textColumn = csvData.letter_prints;
global_ans = csvData.global_letter;
local_ans = csvData.local_letter;
local_letter = []
global_letter = []
num_total = 0;
num_correct = 0;
num_wrong_local = 0;
num_wrong_other = 0;
num_no_press = 0;

response_code = []; % 0-Incorrect other, 1-Incorrect local, 2-Time Out, 3-Correct 
response_time = [];

correct_time = [];
local_incorrect_time = [];
other_incorrect_time = [];
file_name = [];

% Draw text in the middle of the screen in Courier in white
Screen('TextSize', window, 20);
Screen('TextFont', window, 'Courier');
formatted_text = ['Hello ' pid ' You will be shown an image of an (global) english alphabet \n\n made up of another english alphabet. \n\nClick key corresponding to \n\n the global letter. \n\nPress any key to start'];

DrawFormattedText(window, formatted_text, 'center', 'center', black);
Screen('Flip', window);  
KbWait();

%Screen('TextSize', window, 80);
%Screen('TextFont', window, 'Courier');

for block = 1:3
    Screen('TextSize', window, 20);
    Screen('TextFont', window, 'Courier');
    formattedText = ['Press any key to start block ' num2str(block) '.'];
    DrawFormattedText(window, formattedText, 'center', 'center', black);
    Screen('Flip', window);  
    KbWait();
    WaitSecs(0.5);

    for trial = 1+(block-1)*10:10*(block)
        local_letter = [local_letter local_ans(trial)]
        global_letter = [global_letter global_ans(trial)]
        file_name = [file_name pid]

        Screen('TextSize', window, 20);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window, 'x', 'center', 'center', black);
        Screen('Flip', window);
        WaitSecs(0.3)

        Screen('TextSize', window, 80);
        Screen('TextFont', window, 'Courier');
        %disp(trial);
        num_total = num_total + 1;
        DrawFormattedText(window, char(textColumn(trial)), 'center', 'center', black);
        Screen('Flip', window);
        local_key_code = KbName(local_ans(trial));
        global_key_code = KbName(global_ans(trial));

        startTime= WaitSecs(0);
        [time, keyCode] = KbWait([], 3 ,startTime+4);
        time = time - startTime;
        %disp(time)
        disp(KbName(keyCode))
    
        if KbName(keyCode) == KbName(global_key_code)
            num_correct = num_correct+1;
            correct_time = [correct_time time];
            response_code = [3 response_code];
            disp('You pressed the global key!');
            response_time = [time response_time];
    
        elseif KbName(keyCode) == KbName(local_key_code)
            num_wrong_local = num_wrong_local+1;
            local_incorrect_time = [local_incorrect_time time];
            response_code = [1 response_code];
            disp('You pressed the local key!');
            response_time = [time response_time];
    
        elseif time>3.9
            num_no_press = num_no_press+1;
            local_incorrect_time = [local_incorrect_time time];
            response_code = [2 response_code];
            response_time = [time response_time];

        else
            num_wrong_other = num_wrong_other + 1;
            other_incorrect_time = [other_incorrect_time time];
            response_code = [0 response_code];
            response_time = [time response_time];
        end
    end

    Screen('TextSize', window, 20);
    Screen('TextFont', window, 'Courier');
    formattedText = ['Accuracy till now in percent..' num2str((num_correct/num_total)*100) '.\n\n Press any key to continue'];
    DrawFormattedText(window, formattedText, 'center', 'center', black);
    Screen('Flip', window);  
    KbWait();
    WaitSecs(0.5);

end

formattedText = ['Overall accuracy in percent: ' num2str((num_correct/num_total)*100) '\n\n' ...
    'Percentage incorrect local guess in percent: ' num2str((num_wrong_local/num_total)*100) '\n\n' ...
    'Average time for correct answer: '  num2str(mean(correct_time)) '\n\n' ...
    'Average time for local incorrect answer: '  num2str(mean(local_incorrect_time)) '\n\n' ...
    'Average time for other incorrect answer: '  num2str(mean(other_incorrect_time)) ...
    ];

DrawFormattedText(window, formattedText, 'center', 'center', black);
Screen('Flip', window);
KbWait();
WaitSecs(0.5);
    %WaitSecs(1)
% Flip to the screen
    %duration = 2

local_letter_table = array2table(local_letter.');
local_letter_table.Properties.VariableNames = {'local_letter'};


global_letter_table = array2table(global_letter.');
global_letter_table.Properties.VariableNames = {'global_letter'};


response_code_table = array2table(response_code.');
response_code_table.Properties.VariableNames = {'response_code'};


response_time_table = array2table(response_time.');
response_time_table.Properties.VariableNames = {'response_time'};

file_name = char(file_name)'
pid_table = array2table(file_name);
pid_table.Properties.VariableNames = {'file_name'};

final_table = horzcat(pid_table, local_letter_table, global_letter_table, response_code_table, response_time_table);
save(['matlab_exp_data\', pid, '.mat'], 'final_table');
    

    %disp(keyCode)
% Draw text in the bottom of the screen in Times in blue
%Screen('TextSize', window, 90);
%Screen('TextFont', window, 'Times');
%DrawFormattedText(window, 'Hello World', 'center',...
%    screenYpixels * 0.75, [0 0 1]);
%a
% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo

% Clear the screen1111111
sca;