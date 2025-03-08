import Microsoft.Quantum.Diagnostics.*;
import Microsoft.Quantum.Convert.*;
import Microsoft.Quantum.Math.*;
import Microsoft.Quantum.Arrays.*;

operation entanglementTest() : (Result, Result)
{
    use (q1, q2) = (Qubit(), Qubit());

    H(q1);
    //Z(q1);
    CNOT(q1, q2);

    DumpMachine();

    let (m1, m2) = (M(q1), M(q2));
    Reset(q1);
    Reset(q2);

    return (m1, m2);
}
operation multiSuperPositionSet() :Int
{
    use qubits = Qubit[3];
    ApplyToEach(H, qubits);
    let result = ForEach(M, qubits);
    DumpMachine();
    ResetAll(qubits);
    return BoolArrayAsInt(ResultArrayAsBoolArray(result));
}
operation Main() : Int {
        let max = 100;
        let min = 50;
        Message($"Sampling a random number between {min} and {max}: ");
    
        return GenerateRandomNumber(max,min);
    }

operation GenerateRandomNumber(max:Int,min:Int) : Int {
    mutable bits = [];
    let nBits = BitSizeI(max);
    for idxBit in 1..nBits {
            set bits += [GenerateRandomBit()];
        }
    let sample = ResultArrayAsInt(bits);
    return sample > max  or sample < min? GenerateRandomNumber(max,min) | sample;
}
operation GenerateRandomBit() : Result {
    use q = Qubit();
    //Hadamard superpozice  pravdepodobnost 50/50
    //H(q);
    //pravdepodobnost 0,3=>0 a 0,7 =>1 
    let P = 0.333333; 
    Ry(2.0 * ArcCos(Sqrt(P)), q);

    let result = M(q);
    Reset(q);
    return result;
}
