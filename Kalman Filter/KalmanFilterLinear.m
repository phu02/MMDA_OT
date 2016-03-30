classdef KalmanFilterLinear < handle
    % KalmanFilterLinear
    %   Implements a linear Kalman filter
    %   adapted from Python code written by Greg Czerniak
    %   by Stephen Dennison, 2/7/16
    
    properties
        A                    % state transition matrix
        B                    % control matrix
        H                    % observation matrix
        currentStateEstimate % xhat, initial state guess
        currentProbEstimate  % P, initial probability test
        Q                    % process covariance
        R                    % measured covariance
    end
    
    methods
        function obj = KalmanFilterLinear(A,B,H,x,P,Q,R)
            obj.A = A;
            obj.B = B;
            obj.H = H;
            obj.currentStateEstimate = x;
            obj.currentProbEstimate = P;
            obj.Q = Q;
            obj.R = R;
        end
        function r = getCurrentState(obj)
            r = obj.currentStateEstimate;
        end
        function obj = step(obj,controlVector,measurementVector)
            % PREDICTION STEP
            predictedStateEstimate = obj.A * obj.currentStateEstimate + obj.B*controlVector;
            predictedProbEstimate = obj.A* obj.currentProbEstimate *transpose(obj.A) + obj.Q;
            
            % OBSERVATION STEP
            innovation = measurementVector - obj.H*predictedStateEstimate;
            innovationCovariance = obj.H*predictedProbEstimate*transpose(obj.H) + obj.R;

            % UPDATE STEP
            kalmanGain = predictedProbEstimate*transpose(obj.H)*inv(innovationCovariance);
            obj.currentStateEstimate = predictedStateEstimate + kalmanGain * innovation;
            size = length(obj.currentProbEstimate);
            obj.currentProbEstimate = (eye(size)-kalmanGain*obj.H)*predictedProbEstimate;
        end

    end
    
end

