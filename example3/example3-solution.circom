pragma circom 2.0.0;

include "circomlib/circuits/comparators.circom";

template AgeVerification() {
  // 秘密入力：誕生年
  signal input birthYear;
  
  // 公開入力：確認する年と最低年齢
  signal input verificationYear;
  signal input minimumAge;

  // 現在年が誕生年より後であることを確認する制約
  component validYearCheck = GreaterEqThan(32); 
  validYearCheck.in[0] <== verificationYear;
  validYearCheck.in[1] <== birthYear;
  validYearCheck.out === 1; // 必ず1（true）でなければならない
  
  // 公開出力：年齢条件を満たすかどうか（1=true, 0=false）
  signal output isLegalAge;
  
  // 年齢を計算
  signal age;
  age <== verificationYear - birthYear;
  
  // 年齢条件を確認（age >= minimumAge）
  component ageCheck = GreaterEqThan(32); // 32ビットの数値を比較
  ageCheck.in[0] <== age;
  ageCheck.in[1] <== minimumAge;
  
  isLegalAge <== ageCheck.out;
}

component main {public [verificationYear, minimumAge]} = AgeVerification();