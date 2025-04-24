pragma circom 2.0.0;

include "circomlib/circuits/comparators.circom";

// TODO: Include comparators.circom from circomlib to access the `IsZero` component

template Multiplier2Alt () {
  signal input a;
  signal input b;
  signal output c;

  // If either a or b is 1, in is 0
  // We check that in is not 0
  component isZeroCheck = IsZero();
  isZeroCheck.in <== (a - 1) * (b - 1);
  isZeroCheck.out === 0;

  c <== a * b;
}

component main = Multiplier2Alt();