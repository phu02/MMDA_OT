
import Accelerate

class KalmanFilter {
    let nXn = 9;
    let nX1 = 3;
    let n : Int = 3;
    
    let I = [1.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0] //eye(3)
    var A : [Double]
    var currentProbEstimate : [Double]
    var predictedStateEstimate : [Double]
    var P : Double
    var currentStateEstimate: [Double]
    var predictedProbEstimate: [Double]
    var Q : [Double]
    var H : [Double]
    var R : [Double]
    var kalmanGain: [Double]
    var S: [Double]
    var y_tilda: [Double]
    let g = 9.81
    
    // init
    // Purpose: initializes
    init(StateMatrix: [Double]){
        // Initialize matricies to identity matrix
        A = StateMatrix
        H = I
        var point2 = 0.2
        R = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_vsmulD(I, 1, &point2, &R, 1, vDSP_Length(I.count)) // R = I * 0.2
        // Initialize to zero variables which will be overwritten
        Q = [Double](count: nXn, repeatedValue: 0.0)
        kalmanGain = [Double](count: nXn, repeatedValue: 0.0)
        S = [Double](count: nXn, repeatedValue: 0.0)
        y_tilda = [Double](count: nX1, repeatedValue: 0.0)
//        var zeroPointZeroOne = 0.01
//        vDSP_vsmulD(I, 1, &zeroPointZeroOne, &Q, 1, vDSP_Length(I.count)) // Q = I * 0.01
        predictedProbEstimate = [Double](count: nXn, repeatedValue: 0.0)
        predictedStateEstimate = [Double](count: nX1, repeatedValue: 0.0)
        // Current Estimate starting points
        currentStateEstimate = [0, 0, 0] // initial guess  x_pred
        currentProbEstimate = [Double](count: nXn, repeatedValue: 0.0)
        P = 0.1
        vDSP_vsmulD(I, 1, &P, &currentProbEstimate, 1, vDSP_Length(I.count)) // currentProbEstimate = I * 0.1
    }
    
    // update
    // Purpose: updates the Kalman filter state with the addition of new data
    func update(measurementVector : [Double]){
        predict()
        var scaledMeasurementVector = [Double](count: nX1, repeatedValue: 0.0)
        var G = g
        vDSP_vsmulD(measurementVector, 1, &G, &scaledMeasurementVector, 1, vDSP_Length(measurementVector.count))
        
        var innovationVector = observe(scaledMeasurementVector) // returns innovation and innovation covariance as one array
        // Have to parse the array for the relevant data
        y_tilda = innovationVector
        
        var innovation = [Double](count: nX1, repeatedValue: 0.0)
        var innovationCovarience = [Double](count: nXn, repeatedValue: 0.0)
        for i in 0 ... (nX1 - 1){
            innovation[i] = innovationVector[i]
        }
        
        for j in 0 ... (nXn - 1) {
           innovationCovarience[j] = innovationVector[nX1 + j]
        }
        
        updateStep(innovation, innovationCovarience: innovationCovarience)
    }
    
    // getCurrentState
    // Purpose: returns the current state
    func getCurrentState() -> [Double]{
        return currentStateEstimate
    }
    
    // predict
    // Purpose: completes the predict step of kalman filtering
    func predict(){
        // Prediction
        
        // X_pred = A * x_n
        // or Predicted State Estimate = A * currentStateEstimate
        vDSP_mmulD(A, 1, currentStateEstimate, 1, &predictedStateEstimate, 1, 3, 1, 3)
        
        // P_pred = A * P_n * A' + Q
        // Predicted Prob Estimate = (A * currentProbEst * transpose(A)) + Q
        var AXcurrentProbEst = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_mmulD(A, 1, currentProbEstimate, 1, &AXcurrentProbEst, 1, 3, 3, 3)
        var transA = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_mtransD(A, 1, &transA, 1, 3, 3)
        var AXcurrentProbEstXtransA = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_mmulD(AXcurrentProbEst, 1, transA, 1, &AXcurrentProbEstXtransA, 1, 3, 3, 3)
        vDSP_vaddD(AXcurrentProbEstXtransA, 1, Q, 1, &predictedProbEstimate, 1, vDSP_Length(AXcurrentProbEstXtransA.count))
        
        // P_pred is predictedProbEstimate
    }
    
    // observe
    // Purpose: completes the observe step of kalman filtering
    func observe(measurementVector : [Double]) -> [Double]{
        // Observation
        
        // y_tilda = Zn - H * x_pred
        // innovation = measurementVector - (H * predictedStateEst)
        var innovation = [Double](count: nX1, repeatedValue: 0.0)
        var HXpredictedStateEst = [Double](count: nX1, repeatedValue: 0.0)
        vDSP_mmulD(H, 1, predictedStateEstimate, 1, &HXpredictedStateEst, 1, 3, 1, 3)
        var negativeHXpredictedStateEst = [Double](count: nX1, repeatedValue: 0.0)
        var minusOne = -1.0
        vDSP_vsmulD(HXpredictedStateEst, 1, &minusOne, &negativeHXpredictedStateEst, 1, 3)
        vDSP_vaddD(measurementVector, 1, negativeHXpredictedStateEst, 1, &innovation, 1, vDSP_Length(measurementVector.count))
        // S = H*P_pred*H' + R
        // innovationCovarience = (H * predictedProbEst * transpose(H)) + R
        var innovationCovarience = [Double](count: nXn, repeatedValue: 0.0)
        var HXpredictedProbEst = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_mmulD(H, 1, predictedProbEstimate, 1, &HXpredictedProbEst, 1, 3, 3, 3)
        var transH = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_mtransD(H, 1, &transH, 1, 3, 3)
        var HXpredictedProbEstXtransH = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_mmulD(HXpredictedProbEst, 1, transH, 1, &HXpredictedProbEstXtransH, 1, 3, 3, 3)
        vDSP_vaddD(HXpredictedProbEstXtransH, 1, R, 1, &innovationCovarience, 1, vDSP_Length(HXpredictedProbEstXtransH.count))
        S = innovationCovarience
        innovation.appendContentsOf(innovationCovarience)
        return innovation
    }
    
    // updateStep
    // Purpose: completes the update step of kalman filtering
    func updateStep(innovation: [Double], innovationCovarience : [Double]){
        // Update
        // K = P_pred * H' * inv(S)
        // kalmanGain = predictedProbEstimate * transpose(H) * invert(innovationCovariance)
        var kalmanGain = [Double](count: nXn, repeatedValue: 0.0)
        var predictedProbEstXtransH = [Double](count: nXn, repeatedValue: 0.0)
        var transH = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_mtransD(H, 1, &transH, 1, 3, 3)
        vDSP_mmulD(predictedProbEstimate, 1, transH, 1, &predictedProbEstXtransH, 1, 3, 3, 3)
        let abMatrix = ABMatrix(matrix: innovationCovarience, row: n, col: n)
        let invertedInnovationCovarience = abMatrix.Inverse()
        vDSP_mmulD(predictedProbEstXtransH, 1, invertedInnovationCovarience.0, 1, &kalmanGain, 1, 3, 3, 3)
        self.kalmanGain = kalmanGain
        // currentStateEstimate = predictedStateEstimate + (kalmanGain * innovation)
        var kalmanGainXinnovation = [Double](count: nX1, repeatedValue: 0.0)
        vDSP_mmulD(kalmanGain, 1, innovation, 1, &kalmanGainXinnovation, 1, 3, 1, 3)
        vDSP_vaddD(predictedStateEstimate, 1, kalmanGainXinnovation, 1, &currentStateEstimate, 1, vDSP_Length(predictedStateEstimate.count))
        // currentProbEstimate = (I - (kalmanGain * H)) * predictedProbEstimate
        var kalmanGainXH = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_mmulD(kalmanGain, 1, H, 1, &kalmanGainXH, 1, 3, 3, 3)
        var negativeKalmanGainXH = [Double](count: nXn, repeatedValue: 0.0)
        var minusOne = -1.0
        vDSP_vsmulD(kalmanGainXH, 1, &minusOne, &negativeKalmanGainXH, 1, vDSP_Length(kalmanGainXH.count))
        var IMinusKalmanGainXH = [Double](count: nXn, repeatedValue: 0.0)
        vDSP_vaddD(I, 1, negativeKalmanGainXH, 1, &IMinusKalmanGainXH, 1, vDSP_Length(I.count))
        vDSP_mmulD(IMinusKalmanGainXH, 1, predictedProbEstimate, 1, &currentProbEstimate, 1, 3, 3, 3)
    }
}