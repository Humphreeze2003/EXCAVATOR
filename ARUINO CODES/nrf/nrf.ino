#include <SPI.h>
#include <RF24.h>

// -------------------------
// NRF24L01 Pin Assignment
// -------------------------
RF24 radio(9, 10);        // CE = D9, CSN = D10

// 3-byte radio address
const byte address[3] = {0xAA, 0xAA, 0xAA};

void setup()
{
    // =====================================
    // UART INITIALIZATION
    // =====================================

    // Open the hardware UART at 9600 baud.
    // This UART is connected to the PC through
    // the Arduino's USB interface.
    Serial.begin(9600);

    // Wait until the serial port is ready.
    // (Mostly useful on boards like Leonardo.
    // On an Uno it returns immediately.)
    while (!Serial);

    Serial.println("Arduino Started");

    bool ok = radio.begin();

Serial.print("radio.begin() = ");
Serial.println(ok);

    // Serial.print(radio);
    // =====================================
    // NRF24L01 INITIALIZATION
    // =====================================
    // radio.begin();
    // Initialize SPI and the nRF24L01
    if (!radio.begin())
    {
        Serial.println("NRF24L01 NOT FOUND!");

        while (1);
    }

    Serial.println("NRF24L01 Found");


    // =====================================
    // RADIO CONFIGURATION
    // =====================================

    // RF Channel = 76
    radio.setChannel(76);

    // Air data rate = 1 Mbps
    radio.setDataRate(RF24_1MBPS);

    // Maximum transmit power
    radio.setPALevel(RF24_PA_MAX);

    // Address width = 3 bytes
    radio.setAddressWidth(3);

    // Destination address
    radio.openWritingPipe(address);

    // Payload size = 3 bytes ( my packet is only 3 bytes wide)
    radio.setPayloadSize(3);

    // Put the radio into TX mode
    radio.stopListening();

    Serial.println("Radio Configured");
}





void loop()
{
    uint8_t packet[3] = {0xAA, 0xBB, 0xCC};

    bool success = radio.write(packet, 3);

    delay(1000);
}














// void loop()
// {
//     // Wait until 3 bytes have arrived
//     if (Serial.available() >= 3)
//     {
//         uint8_t packet[3];

//         // Read exactly 3 bytes
//         Serial.readBytes(packet, 3);


//         // -----------------------------
//         // Print packet in HEX
//         // -----------------------------

//         Serial.print("Received: ");

//         for (int i = 0; i < 3; i++)
//         {
//             if (packet[i] < 16)
//                 Serial.print("0");

//             Serial.print(packet[i], HEX);
//             Serial.print(" ");
//         }

//         Serial.println();


//         // -----------------------------
//         // Send over NRF24L01
//         // -----------------------------

//         bool success = radio.write(packet, 3);

//         if (success)
//         {
//             Serial.println("Packet Sent");
//         }
//         else
//         {
//             Serial.println("Transmission Failed");
//         }
//     }
// }