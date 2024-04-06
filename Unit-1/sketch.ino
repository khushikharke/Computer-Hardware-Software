
int redPin = A3;
int greenPin = A4;
int bluePin = A5;
float output=0;
float lrCoef[5] = {25.142174108944573,  0.89991892,  0.48236037,  0.0356627,  -0.04208933};
void setup() {
  
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);

  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);

  Serial.begin(9600);
  // delay(1000);

  float val1 = 81.40;
  float val2 = 124.50;
  float val3 = 20.50;
  float val4 = 15.24;

  output = multiLinReg(val1, val2, val3, val4);
  Serial.print(output, 10);

}

void loop() {
  if(output<=100){
    analogWrite(redPin, 255);
    analogWrite(bluePin, 255); 
  }
  else if(output<=200){
    analogWrite(bluePin, 255); 
  }
  else{
    analogWrite(greenPin, 255);
    analogWrite(bluePin, 255); 
  }
  delay(250);
  analogWrite(redPin, 0);
  analogWrite(bluePin, 0);
  analogWrite(greenPin, 0);
  delay(250);
  
}

float multiLinReg(float a, float b, float c, float d) {
  return lrCoef[0] + a * lrCoef[1] + b * lrCoef[2] + c * lrCoef[3] + d * lrCoef[4];
}
