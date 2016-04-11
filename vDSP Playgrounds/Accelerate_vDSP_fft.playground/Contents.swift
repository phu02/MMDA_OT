//: Playground - noun: a place where people can play
// https://www.objc.io/issues/16-swift/rapid-prototyping-in-swift-playgrounds/

import Foundation
import XCPlayground
import Accelerate
/*
let sineArraySize = 64

let frequency1 = 4.0
let phase1 = 0.0
let amplitude1 = 2.0
let sineWave = (0..<sineArraySize).map {
    amplitude1 * sin(2.0 * M_PI / Double(sineArraySize) * Double($0) * frequency1 + phase1)
}


func plotArrayInPlayground<T>(arrayToPlot:Array<T>, title:String) {
    for currentValue in arrayToPlot {
        XCPCaptureValue(title, value: currentValue)
    }
}


plotArrayInPlayground(sineWave, title: "Sine wave 1")
*/


// A little playground helper function
func plotArrayInPlayground<T>(arrayToPlot:Array<T>, title:String) {
    for currentValue in arrayToPlot {
        XCPCaptureValue(title, value: currentValue)
        }
}

let sineArraySize = 64 // Should be power of two for the FFT

let frequency1 = 4.0
let phase1 = 0.0
let amplitude1 = 2.0
let sineWave = (0..<sineArraySize).map {
    amplitude1 * sin(2.0 * M_PI / Double(sineArraySize) * Double($0) * frequency1 + phase1)
}

let frequency2 = 1.0
let phase2 = M_PI / 2.0
let amplitude2 = 1.0
let sineWave2 = (0..<sineArraySize).map {
    amplitude2 * sin(2.0 * M_PI / Double(sineArraySize) * Double($0) * frequency2 + phase2)
}

plotArrayInPlayground(sineWave, title: "Sine wave 1")
plotArrayInPlayground(sineWave2, title: "Sine wave 2")

// Simple loop-based array addition
var combinedSineWave = [Double](count:sineArraySize, repeatedValue:0.0)
for currentIndex in 0..<sineArraySize {
    combinedSineWave[currentIndex] = sineWave[currentIndex] + sineWave2[currentIndex]
}

// Accelerate-enabled array addition
infix operator  +++ {}
func +++ (a: [Double], b: [Double]) -> [Double] {
    assert(a.count == b.count, "Expected arrays of the same length, instead got arrays of two different lengths")
    
    var result = [Double](count:a.count, repeatedValue:0.0)
    vDSP_vaddD(a, 1, b, 1, &result, 1, UInt(a.count))
    return result
}

let combinedSineWave2 = sineWave +++ sineWave2

plotArrayInPlayground(combinedSineWave, title: "Combined wave (loop addition)")
plotArrayInPlayground(combinedSineWave2, title: "Combined wave (Accelerate)")

// Wrapping vecLib in overloaded functions
func sqrt(x: [Double]) -> [Double] {
    var results = [Double](count:x.count, repeatedValue:0.0)
    vvsqrt(&results, x, [Int32(x.count)])
    return results
}

sqrt(4.0)
sqrt([4.0, 3.0, 16.0])


// Accelerate-enabled FFT
let fft_weights: FFTSetupD = vDSP_create_fftsetupD(vDSP_Length(log2(Float(sineArraySize))), FFTRadix(kFFTRadix2))

func fft(var inputArray:[Double]) -> [Double] {
    var fftMagnitudes = [Double](count:inputArray.count, repeatedValue:0.0)
    var zeroArray = [Double](count:inputArray.count, repeatedValue:0.0)
    var splitComplexInput = DSPDoubleSplitComplex(realp: &inputArray, imagp: &zeroArray)
    
    vDSP_fft_zipD(fft_weights, &splitComplexInput, 1, vDSP_Length(log2(CDouble(inputArray.count))), FFTDirection(FFT_FORWARD));
    vDSP_zvmagsD(&splitComplexInput, 1, &fftMagnitudes, 1, vDSP_Length(inputArray.count));
    
    let roots = sqrt(fftMagnitudes) // vDSP_zvmagsD returns squares of the FFT magnitudes, so take the root here
    var normalizedValues = [Double](count:inputArray.count, repeatedValue:0.0)
    
    vDSP_vsmulD(roots, vDSP_Stride(1), [2.0 / Double(inputArray.count)], &normalizedValues, vDSP_Stride(1), vDSP_Length(inputArray.count))
//    print(normalizedValues)
    return normalizedValues
    
}

//print(sineWave)
//print("sineWave printed, now print fftOfWave1")
let fftOfWave1 = fft(sineWave)
//print(fftOfWave1)
let fftOfWave2 = fft(sineWave2)
let fftOfWave3 = fft(combinedSineWave)

fftOfWave1.filter {$0 > 0.1}    //filter applies the function {if value > 0.1} then returns true or false for values in fftOfWave1
/* Note, we will use this for threshold detecting. If certain frequency is most dominant in the signal detected, the information will be fft and filter detected here.
 */

//func filter(includeElement: (T) -> Bool) -> [T]

class SomeType {
    let a = 1
}

extension SomeType {
    func swapTwoValues<T>(inout a: T, inout _ b: T) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
}

// enumerate function for array
let arl = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
for i in arl.enumerate() {
    print("--> \(i)")
}

extension Slice {
    func filterWithIndicesAdjustedByMultiplier<T>(indexAdjustment:Double, includeElement: (T) -> Bool) -> [(Double, T)] {
        var filterResults: [(Double, T)] = []
        //for (index, arrayElement) in enumerate(self) {
        for (index, arrayElement) in self.enumerate() {
            let t = arrayElement as! T;
            if includeElement(t) {
                let indexAdjusted = Double(index) * indexAdjustment
                //filterResults.append(Double(index) * indexAdjustment, t)
                filterResults.append((indexAdjusted, t))
            }
        }
        return filterResults
    }
}

plotArrayInPlayground(fftOfWave1, title: "FFT of sine wave 1")
plotArrayInPlayground(fftOfWave2, title: "FFT of sine wave 2")
plotArrayInPlayground(fftOfWave3, title: "FFT of combined sine waves")
/*
let amplitudeThreshold = 0.00001
func identifyFrequenciesAndAmplitudesOfWaveform(waveform:[Double]) -> [(Double, Double)] {
    let fftOfWaveform = fft(waveform)
    let halfFFT = fftOfWaveform[0..<(waveform.count / 2)]
    return halfFFT.filterWithIndicesAdjustedByMultiplier(1.0) { $0 > amplitudeThreshold }
}

identifyFrequenciesAndAmplitudesOfWaveform(sineWave)
identifyFrequenciesAndAmplitudesOfWaveform(sineWave2)
identifyFrequenciesAndAmplitudesOfWaveform(combinedSineWave)
*/
