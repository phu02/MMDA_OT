class ABMatrix
{
    // storage is column-major
    var M: [Double] = [0.0, 0.0, 0.0, 0.0]
    var row: Int = 0
    var col: Int = 0
    
    init(let row: Int, let col: Int) {
        self.row = row
        self.col = col
        M = Array(count: (row*col), repeatedValue: 0.0)
    }
    
    init(let s: Int) { // square matric
        row = s
        col = s
        M = Array(count: (row*col), repeatedValue: 0.0)
    }
    
    
    init(let matrix:[Double], let row: Int, let col: Int) {
        M = matrix
        self.row = row
        self.col = col
    }
    
    func MakeZero() -> () {
        let Z = Array(count: (row*col), repeatedValue: 0.0)
        self.M = Z
    }
    
    func MakeZero(let row: Int, let col: Int) -> [Double] {
        let Z = Array(count: (row*col), repeatedValue: 0.0)
        return Z
    }
    
    func MakeOne() -> () {
        let Z = Array(count: (row*col), repeatedValue: 1.0)
        self.M = Z
    }
    
    func Multiply(let N: [Double], let row: Int, let col: Int ) -> ([Double], Int) {
        // self.row x self.col  * row x col = self.row x col
        
        if(self.col != row) {
            return ([], 0)
        }
        
        var P = MakeZero(row, col: col)
        
        for i in 0..<self.row {
            for j in 0..<col {
                for k in 0..<self.col {
                    P[col*i+j] = P[col*i+j] + self.M[self.col*i+k] * N[col*k+j]
                }
            }
        }
        
        return (P, 1)
    }
    
    func Multiply(let N: ABMatrix) -> (ABMatrix) {
        // self.row x self.col  * N.row x N.col = self.row x N.col
        var P = self.MakeZero(row, col: N.col)
        var output = ABMatrix(matrix: P, row: self.row, col: N.col)
        
        if(self.col != row) {
            return (output)
        }
        
        for i in 0..<self.row {
            for j in 0..<N.col {
                for k in 0..<self.col {
                    P[N.col*i+j] = P[N.col*i+j] + self.M[self.col*i+k] * N.M[N.col*k+j]
                }
            }
        }
        output = ABMatrix(matrix: P, row: self.row, col: N.col)
        return (output)
    }
    
    func Add(let N: ABMatrix) -> (ABMatrix) {
        if (self.row == N.row) {
            if(self.col == N.col) {
                for r in 0..<row {
                    for c in 0..<col {
                        let index = (r * col) + c
                        self.M[index] += N.M[index]
                    }
                }
            }
        }
        let output = ABMatrix(matrix: self.M, row: N.row, col: N.col)
        return output
    }
    
    
    func Subtract(let N: ABMatrix) -> (ABMatrix) {
        if (self.row == N.row) {
            if(self.col == N.col) {
                for r in 0..<row {
                    for c in 0..<col {
                        let index = (r * col) + c
                        self.M[index] -= N.M[index]
                    }
                }
            }
        }
        let output = ABMatrix(matrix: self.M, row: N.row, col: N.col)
        return output
    }
    
    func Transpose() ->(ABMatrix){
        var T = self.M
        for r in 0..<row {
            for c in 0..<col {
                // rowIndex * col + colIndex
                let indexM = (r * col) + c
                // colIndex * row + rowIndex
                let indexT = (c * row) + r
                T[indexT] = self.M[indexM]
            }
        }
//        self.M = T
//        let buffer = self.row
//        self.row = self.col
//        self.col = buffer
        let output = ABMatrix(matrix: T, row: self.col, col: self.row)
        return output
    }
    
    func Scale(let s: Double) -> () {
        for index  in 0..<self.M.count {
            self.M[index] *= s
        }
    }
    
    func Inverse() -> (ABMatrix) {
        // if returned Int is 0, matrix M is singular - no inverse
        // Gauss Jordan Method: Strang page 71 to 75
        let square = self.row  // number rows = cols
        var currentPivotRow = 0  //current pivot row
        var pivotMatrix = [Int](count: square, repeatedValue: 0) // row swap tracking
        var value: Double = 0.0  // temporary value
        
        let N = ABMatrix(matrix: self.M, row: row, col: col)
        
        for indexPivot in 0..<square {
            //print("==> \(indexPivot)")
            // locate largest value in current column to identify pivot row
            value = 0.0
            for indexRow in indexPivot..<square {
                //print("==> \(indexRow)")
                //PrintMatrix(N.M, row: square, col: square, label: "square")
                if(abs(N.M[indexRow * square + indexPivot]) >= value) {
                    value = abs(N.M[indexRow * square + indexPivot])
                    currentPivotRow = indexRow
                }
                //print("==indexPivot: \(indexPivot)")
                //print("==pivrow: \(currentPivotRow)")
            }
            // is this a singular matrix
            if (N.M[currentPivotRow*square+indexPivot] == 0.0) {
                //print("Inversion failed")
                N.MakeZero()
                return N // N = 0 returned in .1 position of tuple if singular
            }
            // do the pivot - swap row, as required
            //print("^^^^^^cpr: \(currentPivotRow) &  iP: \(indexPivot)")
            if(currentPivotRow != indexPivot) {
                // do the row swap:  currentPivotRow with indexPivot row
                for index in 0..<square {
                    value = N.M[indexPivot * square + index]
                    N.M[indexPivot * square + index] = N.M[currentPivotRow*square+index]
                    N.M[currentPivotRow * square + index] = value
                    //print("-------\(value)")
                }
            }
            // document the swap or not swap
            pivotMatrix[indexPivot] = currentPivotRow
            // pivot value insertion
            value = 1.0 / N.M[indexPivot * square + indexPivot]
            // change result matrix
            N.M[indexPivot * square + indexPivot] = 1.0
            
            // divide by inserted pivot value for row reduction
            for index in 0..<square {
                N.M[indexPivot * square + index] = N.M[indexPivot * square + index] * value
            }
            // elimination of column values
            for indexI in 0..<square {
                if (indexI != indexPivot) {
                    value = N.M[indexI * square + indexPivot]
                    //insertion
                    N.M[indexI * square + indexPivot] = 0.0
                    for indexJ in 0..<square {
                        N.M[indexI * square + indexJ] = N.M[indexI * square + indexJ] - (N.M[indexPivot * square + indexJ] * value)
                    }
                }
            }
        }
        
        // reverse of pivot row swaps -> do column swaps in reverse
        //for index in (square - 1)...0
        
        for index in (0...(square - 1)).reverse() {
            if (pivotMatrix[index] != index) {
                for indexN in 0...square {
                    value = N.M[indexN * square + index]
                    N.M[indexN * square + index] = N.M[indexN * square + pivotMatrix[index]]
                    N.M[indexN * square + pivotMatrix[index]] = value
                }
                
            }
        }
        //print("Inversion successful")
        
        return N
//        return (N.M, 1) // 1 returned with inverse in .1 posiiton of tuple
    }
    
    func PrintMatrix(let M: [Double], let row: Int, let col: Int, let label: String) -> () {
        print(label)
        for r in 0..<row {
            for c in 0..<col {
                let index = (r * col) + c
                print(M[index], terminator: " ")
            }
            print(" ")
        }
    }
    
    func PrintMatrixLabel(let M: [Double], let row: Int, let col: Int, let label: String) -> () {
        print(label)
        for r in 0..<row {
            for c in 0..<col {
                let index = (r * col) + c
                print(M[index], terminator: " ")
            }
            print(" ")
        }
    }
    
    
    func Print() {
        PrintMatrix(self.M, row: self.row, col: self.col, label: "")
    }
    
    func Copy(let M: [Double]) -> ([Double]) {return M}

    
    //currently CopyRow function can only support copying matrix with n rows, 3 cols
//    func CopyRow(let rowNum: Int)->(ABMatrix) {
//        var input_X = ABMatrix(matrix: [0, 0, 0], row: 1, col: self.col)
//    
//        if rowNum <= self.row {
//            let index = ((rowNum-1) * (col))
////                print(M[index], terminator: " ")
//            input_X = ABMatrix(matrix:[self.M[index], self.M[index+1], self.M[index+2]], row: 1, col: self.col)
//        }
//        return input_X
//    }
    
//    //currently CopyCol function can only support copying matrix with 3 rows, n cols
//    func CopyCol(let colNum: Int)->(ABMatrix) {
//
//        let output = self.Transpose().CopyRow(colNum).Transpose()
//       return output
//    }
    

    func Identity() -> (Int) {
        var Z = Array(count: (row*col), repeatedValue: 0.0)
        if(row == col) {
            for r in 0..<row {
                for c in 0..<col {
                    if (r == c) {
                        let index = (r * col) + c
                        print("--> \(index)")
                        Z[index] = 1
                        print("-[]> \(Z[index])")
                    }
                }
            }
            self.M = Z
            return 1
        }
        else {
            self.M = Z
            return 0
        }
        
    }
}

func PrintMatrix(let M: [Double], let row: Int, let col: Int, let label: String) -> () {
    print(label)
    for r in 0..<row {
        for c in 0..<col {
            let index = (r * col) + c
            print(M[index], terminator: " ")
        }
        print(" ")
    }
}



