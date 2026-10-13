%clear existing variables, close any figure windows, clear the command line
close all
clear all
clc

% Clear any existing serial ports
delete(instrfind);

% Create a serial port object
serialPort = serial('COM3', 'BaudRate', 115200, 'DataBits', 8, 'Parity', 'none','StopBit', 1, 'InputBufferSize', 3, 'OutputBufferSize', 3);
% TODO Modify InputBufferSize and OutputBufferSize to match, or be larger than the data.
% They control how much data Matlab will buffer before sending to (or receiving from)
% the UART

% open the serial port for reading/writing
fopen(serialPort);

% send characters to the FPGA
fprintf(serialPort,'%c','a');
pause(1)
fprintf(serialPort,'%c','b');
pause(1)
fprintf(serialPort,'%c','c');

% read 3 characters from the FPGA
% fscanf(serialPort,'%c%c%c',3)

%close the serial port
fclose(serialPort);
a