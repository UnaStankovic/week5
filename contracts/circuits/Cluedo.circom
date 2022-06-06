pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

template Cluedo() {

    // Public inputs - just one player 
    signal input pubGuessA1; //murderer
    signal input pubGuessB1;  //room
    signal input pubGuessC1; //weapon

    // signal input pubNumHit;
    // signal input pubNumBlow;
    signal input pubSolnHash;
    signal input pubGuessSum;
    signal input privSolSum;

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

   
    // equalSum = IsEqual();
    // equalSum.in[0] <== privSolSum;
    // equalSum.in[1] <== pubGuessSum;
    // equalSum.out === 1;

    for (j=0; j<3; j++) {
        equalGuess[j] = IsEqual(4);
        equalGuess[j].in[0] <== guess[j];
        equalGuess[j].in[1] <== soln[j];
        equalGuess[j].out === 1;
    }
   
    // for (j=0; j<3; j++) {
    //     lessThan[j] = LessThan(4);
    //     lessThan[j].in[0] <== guess[j];
    //     lessThan[j].in[1] <== 7;
    //     lessThan[j].out === 1;
    //     lessThan[j+4] = LessThan(4);
    //     lessThan[j+4].in[0] <== soln[j];
    //     lessThan[j+4].in[1] <== 7;
    //     lessThan[j+4].out === 1;
    //     for (k=j+1; k<3; k++) {
           
    //         equalGuess[equalIdx] = IsEqual();
    //         equalGuess[equalIdx].in[0] <== guess[j];
    //         equalGuess[equalIdx].in[1] <== guess[k];
    //         equalGuess[equalIdx].out === 0;
    //         equalSoln[equalIdx] = IsEqual();
    //         equalSoln[equalIdx].in[0] <== soln[j];
    //         equalSoln[equalIdx].in[1] <== soln[k];
    //         equalSoln[equalIdx].out === 0;
    //         equalIdx += 1;
    //     }
    // }

    // // var hit = 0;
    // var blow = 0;
    // component equalHB[16];

    // for (j=0; j<4; j++) {
    //     for (k=0; k<4; k++) {
    //         equalHB[4*j+k] = IsEqual();
    //         equalHB[4*j+k].in[0] <== soln[j];
    //         equalHB[4*j+k].in[1] <== guess[k];
    //         blow += equalHB[4*j+k].out;
    //         if (j == k) {
    //             // hit += equalHB[4*j+k].out;
    //             blow -= equalHB[4*j+k].out;
    //         }
    //     }
    // }

    
    // component equalHit = IsEqual();
    // equalHit.in[0] <== pubNumHit;
    // equalHit.in[1] <== hit;
    // equalHit.out === 1;
    
    // component equalBlow = IsEqual();
    // equalBlow.in[0] <== pubNumBlow;
    // equalBlow.in[1] <== blow;
    // equalBlow.out === 1;

    // Verify that the hash of the private solution matches pubSolnHash
    component poseidon = Poseidon(6);
    poseidon.inputs[0] <== privSalt;
    poseidon.inputs[1] <== privSolnA;
    poseidon.inputs[2] <== privSolnB;
    poseidon.inputs[3] <== privSolnC;
    poseidon.inputs[5] <== privSolSum;

    solnHashOut <== poseidon.out;
    pubSolnHash === solnHashOut;

}

component main {public [pubGuessA1, pubGuessB1, pubGuessC1, pubNumHit, pubNumBlow, pubSolnHash]} = Cluedo();