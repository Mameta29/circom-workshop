pragma circom 2.0.0;

include "circomlib/circuits/comparators.circom";

template RegionalAgeVerification() {
  // 秘密入力：誕生年
  signal input birthYear;
  
  // 公開入力：確認する年と国/地域コード
  signal input verificationYear;
  signal input regionCode; // 1=日本(20歳)、2=アメリカ(21歳)、3=ドイツ(18歳)

  // 現在年が誕生年より後であることを確認する制約
  component validYearCheck = GreaterEqThan(32); 
  validYearCheck.in[0] <== verificationYear;
  validYearCheck.in[1] <== birthYear;
  validYearCheck.out === 1; // 必ず1（true）でなければならない
  
  // 公開出力：年齢条件を満たすかどうか
  signal output isLegalAge;
  
  // 年齢を計算
  signal age;
  age <== verificationYear - birthYear;
  
  // 地域に応じた最低年齢を決定
  signal minimumAge;
  // 式で表現: regionCode=1→20歳、regionCode=2→21歳、regionCode=3→18歳
  minimumAge <== 20 + (regionCode - 1) * (regionCode == 2 ? 1 : 0) - (regionCode == 3 ? 2 : 0);
  
  // 年齢条件を確認
  component ageCheck = GreaterEqThan(32);
  ageCheck.in[0] <== age;
  ageCheck.in[1] <== minimumAge;
  
  isLegalAge <== ageCheck.out;
}

component main {public [verificationYear, regionCode]} = RegionalAgeVerification();