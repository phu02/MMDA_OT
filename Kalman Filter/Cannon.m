classdef Cannon < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        angle = 45;
        muzzle_vel = 100;
        gravity = [0,-9.81];
        velocity;% = [muzzle_vel*cos(angle*pi/180),muzzle_vel*sin(angle*pi/180)];
        loc = [0,0];
        acceleration = [0,0];
        timeSlice;
        noiseLevel;
    end
    
    methods
        function obj = Cannon(timeSlice,noiseLevel,muzzle_vel)
            obj.timeSlice = timeSlice;
            obj.noiseLevel = noiseLevel;
            obj.muzzle_vel = 100;
            obj.angle = 45;
            obj.velocity = [muzzle_vel*cos(obj.angle*pi/180),muzzle_vel*sin(obj.angle*pi/180)];
        end
        function r = add(x,y)
            r = x + y;
        end
        function r = mult(x,y)
            r = x * y;
        end
        function r = getX(obj)
            r = obj.loc(1);
        end
        function r = getY(obj)
            r = obj.loc(2);
        end
        function r = getXWithNoise(obj)
            r = normrnd(obj.loc(1),obj.noiseLevel);
        end
        function r = getYWithNoise(obj)
            r = normrnd(obj.loc(2),obj.noiseLevel);
        end
        function r = getXVelocity(obj)
            r = obj.velocity(1);
        end
        function r = getYVelocity(obj)
            r = obj.velocity(2);
        end
        function step(obj)
            dxVec = [obj.timeSlice,obj.timeSlice];
            slicedGrav = obj.gravity .* dxVec;
            % only force on cannonball is gravity
            slicedAcc = slicedGrav;
            obj.velocity = obj.velocity + slicedAcc;
            slicedVel = obj.velocity .* dxVec;
            obj.loc = obj.loc + slicedVel;
            if obj.loc(2) < 0
                obj.loc(2) = 0;
            end
        end
        
    end
    
end

