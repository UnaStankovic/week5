pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

template Cluedo() {

    // Public inputs
    signal input pubGuessA1; //murderer
    signal input pubGuessB1;  //room
    signal input pubGuessC1; //weapon

    signal input pubSolnHash;

    // Private inputs
    signal input privSolnA; //murderer
    signal input privSolnB; //room
    signal input privSolnC; //weapon

    signal input privSalt;
    

    // Output
    signal output solnHashOut;

    var guess[3] = [pubGuessA1, pubGuessB1, pubGuessC1];
    var soln[3] =  [privSolnA, privSolnB, privSolnC];
    var j = 0;
    var k = 0;
    component lessThan[8];
    component equalGuess[6];
    component equalSoln[6];
    component equalSum;
    var equalIdx = 0;


    for (j=0; j<3; j++) {
        equalGuess[j] = IsEqual(4);
        equalGuess[j].in[0] <== guess[j];
        equalGuess[j].in[1] <== soln[j];
        equalGuess[j].out === 1;
    }
   
 

    // Verify that the hash of the private solution matches pubSolnHash
    component poseidon = Poseidon(6);
    poseidon.inputs[0] <== privSalt;
    poseidon.inputs[1] <== privSolnA;
    poseidon.inputs[2] <== privSolnB;
    poseidon.inputs[3] <== privSolnC;

    solnHashOut <== poseidon.out;
    pubSolnHash === solnHashOut;

}

component main {public [pubGuessA1, pubGuessB1, pubGuessC1, pubSolnHash]} = Cluedo();