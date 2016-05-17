% frames taken per time unit
frameRate = 10; 
% Total image size (square image)
imageSize = 10000; 
% The size of the detector (in pixels)
sensorSize = 350;
% maximum pixel the stage can move per time unit
maxStageMove = 100000; 
% end of simulation
maxTime = 1000;

% Stage starting position
positionX = 1;
positionY = 1;

% other vars
time = 0;
frameCount = 0;
stageMove = 0;

% Stage move speed
requiredStageMove = floor(sensorSize * 0.9);

image = zeros(imageSize, 'int8');

w = imshow(image, 'InitialMagnification', 'fit', 'DisplayRange',[0 3]);

while ( time < maxTime )
    fprintf('Time %i, frameCount %i, stageMove %i, positionX %i, positionY %i \n', time, frameCount, stageMove, positionX, positionY);
    
    %%% Take micrograph %%%
    
    % Calculate new sensor area on the image
    sensorY = positionY:(positionY + sensorSize);
    sensorX = positionX:(positionX + sensorSize);
    
    % Take an image in the current stage position
    image(sensorY,sensorX) = image(sensorY,sensorX) + 1;
    frameCount = frameCount + 1;
    
    %%% Move stage %%%
    
    % Check whether whe need to move y stage
    if ( positionX + requiredStageMove + sensorSize > imageSize ) 
        
        % Check whether y stage is over limit, we're done
        if ( positionY + requiredStageMove + sensorSize > imageSize ) 
            fprintf('Done!\n\n')
            break;
        end
        
        positionY = positionY + requiredStageMove;
        positionX = 1;
    else
        % Only move x stage
        positionX = positionX + requiredStageMove;
        stageMove = stageMove + requiredStageMove;
    end
    
    if ( stageMove > maxStageMove || frameCount >= frameRate)
        stageMove = 0;
        frameCount = 0;
        time = time + 1;
    end
   
    %set(w,'CData', image);
    %pause(1);
end

set(w,'CData', image);