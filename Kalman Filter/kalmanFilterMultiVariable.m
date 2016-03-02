% Kalman filter demo, single variable
% adapted from Greg Czerniak's website 
% http://greg.czerniak.info/guides/kalman1/
% by Stephen Dennison
% 2/5/2016

% Use importdata() ?

clear

% CONSTANTS
dx = 0.1; % dx
numsteps = 144;
noiseLevel = 30;
muzzleVelocity = 100;
angle = 45;

% MAIN
c = Cannon(dx,noiseLevel,muzzleVelocity);

x = [];
y = [];
nx = [];
ny = [];
kx = [];
ky = [];

speedX = muzzleVelocity*cos(angle*pi/180);
speedY = muzzleVelocity*sin(angle*pi/180);

% state transition vector
stateTransition = [1,dx,0,0;0,1,0,0;0,0,1,dx;0,0,0,1];
controlMatrix = [0,0,0,0;0,0,0,0;0,0,1,0;0,0,0,1];
controlVector = [0;0;0.5*-9.81*dx*dx;-9.81*dx];
obsMatrix = eye(4);

initialState = [0;speedX;500;speedY];
initialProb = eye(4);

processCov = zeros(4,4);
measCov = eye(4)*0.2;

kf = KalmanFilterLinear(stateTransition,controlMatrix,obsMatrix,initialState,initialProb,processCov,measCov);

for i = 1:numsteps
    newx = c.getX();
    newy = c.getY();
    x = horzcat(x,newx);
    y = horzcat(y,newy);
    newestX = c.getXWithNoise();
    newestY = c.getYWithNoise();
    nx = horzcat(nx,newestX);
    ny = horzcat(ny,newestY);
    c.step();
    currentState = kf.getCurrentState();
    kx = horzcat(kx,currentState(1,1));
    ky = horzcat(ky,currentState(3,1));
    kf.step(controlVector,[newestX;c.getXVelocity();newestY;c.getXVelocity()]);
end

t = 1:numsteps;
figure
plot(x,y,'r',nx,ny,'g',kx,ky,'b');
%plot(t,nx,'.',t,kx,'g',t,ny,'*',t,ky,'r');
xlabel('X Position'); ylabel('Y Position');
title('Measurement of Cannonball in Flight');
legend('true','measured','kalman');
