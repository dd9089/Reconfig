%clear existing variables, close any figure windows, clear the command line
close all
clear all
clc

% Read image
filename = 'Images\feep.pgm';
im_orig = imread(filename);
im_orig_info = imfinfo(filename);
numRows = im_orig_info.Height;
numCols = im_orig_info.Width;
imgSize = numRows * numCols;

% Clear any existing serial ports
delete(instrfind);

% Create a serial port object
serialPort = serial('COM3', 'BaudRate', 115200, 'DataBits', 8, 'Parity', 'none','StopBit', 1, 'OutputBufferSize', imgSize, 'InputBufferSize', imgSize);

% open the serial port for reading/writing
fopen(serialPort);

% send image to the FPGA

% FULL SPEED

fprintf('Writing Image Data to FPGA... ');
fwrite(serialPort, im_orig(:));

fprintf('Reading back from FPGA... ');
im_final = fread(serialPort, imgSize, 'uint8');

im_final = reshape(im_final, [numRows numCols]);

% close the serial port
fclose(serialPort);

% Analyze and display results
if isequal(im_orig, im_final)
    fprintf('SUCCESS!\n');
    subplot(1,2,1);
    imshow(mat2gray(im_orig));
    title('Original');
    subplot(1,2,2);
    imshow(mat2gray(im_final));
    title('Received');
else
    fprintf('FAILURE!\n');
end
