const int num_TX = 10;
const int num_RX = 3;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

}

void loop() {
  // put your main code here, to run repeatedly:
  for (int i = 0; i < num_TX * num_RX; i++) {
    Serial.print(random(0, 300)); // The +30 is to be sure it's positive
    Serial.print(",");
  }
  Serial.println();

}
