#include <stdint.h>

 













#define RODATA_BASE_ADDRESS          ((const volatile uint32_t *)0x08FF)  // RODATA base address (2303)



#define DC_MOTOR_BASE_ADDRESS        ((volatile uint32_t *)0x0BFF)  //DC motor peripheral base address (3071)


#define STEPPER_MOTOR_BASE_ADDRESS   ((volatile uint32_t *)0x0C1F)   //stepper motor peripheral base address (3103)

#define SERVO_MOTOR_BASE_ADDRESS     ((volatile uint32_t *)0x0C3F)   //servo motor peripheral base address (3135)

#define SPI_BASE_ADDRESS            ((volatile uint32_t *)0x0C5F)   //SPI peripheral base address (3167)

#define NRF24_BASE_ADDRESS          ((volatile uint32_t *)0x0C7F)   //NRF tranciever peripheral base address (3199)
#define SYSTEM_REGS_BASE_ADDRESS          ((volatile uint32_t *)0x0C9F)   //NRF tranciever peripheral base address ( 3231)


/** order of peripheral registers from base address
           control_reg -----[0]
           status_reg ------[1]
           buffer_0 --------[2]
           buffer_1 --------[3]
           buffer_2 --------[4]
           buffer_3 --------[5]
           other registers  




*/

// // based on action
// void modify_register_based_on_action(volatile uint32_t* reg_address , uint32_t mask , uint32_t shift , uint32_t action ){
//     uint32_t value = *reg_address;
//     // extract the field bits
//     uint32_t field_bits = (value >> shift) & (mask >> shift);
//     // least frequency value = 64 max = 256

//     // modify the field bits
//     switch (action)
//     {
//     case 64:   // INCREASE_freq
//            if(field_bits == 256){

//            }else{
//             field_bits >> 2; // multiply by 2 
//            }
//         break;

//       case 128:   // DECREASE_freq
//            if(field_bits == 64){

//            }else{
//             field_bits << 2; // divide by 2 
//            }
//         break;


//        case 256:   // change motor direction
//           field_bits = ~field_bits;  // invert the direction bit
//         break;

         
    
    
    
//     default:
//         break;
//     }

// //    clear the field bits
//     uint32_t removed_field = value &  ~(mask);
//     // insert new field value
//     uint32_t new_reg_bits = removed_field | (field_bits << shift);

//     *reg_address = new_reg_bits;
// }







// general modification
void modify_register(volatile uint32_t* reg_address , uint32_t mask , uint32_t shift , uint32_t new_val ){
    uint32_t value = *reg_address;
    // extract the field bits
    // uint32_t field_bits = (value >> shift) & (mask >> shift);
    // least frequency value = 64 max = 256

    // modify the field bits
 
//    clear the field bits
    uint32_t removed_field = value &  ~(mask);
    // insert new field value
    uint32_t new_reg_bits = removed_field | (new_val << shift);

    *reg_address = new_reg_bits;
}













uint32_t read_register_field(volatile uint32_t* reg_address , uint32_t mask , uint32_t shift){
          uint32_t value = *reg_address;
    // extract the field bits
    uint32_t field_bits = (value >> shift) & (mask >> shift);
    // least frequency value = 64 max = 256
    return field_bits;
}













// void send_servo_pulse(volatile uint32_t* servo_control_reg_address , uint32_t duration_mask , uint32_t duration_shift  , uint32_t angle){
//    uint32_t pulse_width;
  
//   uint32_t value = *servo_control_reg_address;

// switch (angle)
//    // pulse width is in microseconds
// {
//     case 0:
//         pulse_width = 1000;
//         break;

//     case 15:
//         pulse_width = 1083;
//         break;

//     case 30:
//         pulse_width = 1167;
//         break;

//     case 45:
//         pulse_width = 1250;
//         break;

//     case 60:
//         pulse_width = 1333;
//         break;

//     case 75:
//         pulse_width = 1417;
//         break;

//     case 90:
//         pulse_width = 1500;
//         break;

//     case 105:
//         pulse_width = 1583;
//         break;

//     case 120:
//         pulse_width = 1667;
//         break;

//     case 135:
//         pulse_width = 1750;
//         break;

//     case 150:
//         pulse_width = 1833;
//         break;

//     case 165:
//         pulse_width = 1917;
//         break;

//     case 180:
//         pulse_width = 2000;
//         break;

//     default:
//         /* Invalid angle */
//         pulse_width = 1500;   // Default to 90°
//         break;
// }


// //    clear the field bits
//     uint32_t removed_field = value &  ~(duration_mask);
//     // insert new field value
//     uint32_t new_reg_bits = removed_field | (pulse_width << duration_shift);

//     *servo_control_reg_address = new_reg_bits;

// }



// void initialize_nrf_module(){
// //    const int tx_busy = read_register_field(NRF24_BASE_ADDRESS , uint32_t mask , uint32_t shift , uint32_t action)
// }







void parse_command(){
      // read the reg with the received bytes
    //   based on the system mode register , decide what to do

    //   uint32_t data = SPI_BASE_ADDRESS[3]; // the buffer with received bytes
      uint32_t command = read_register_field(&SPI_BASE_ADDRESS[3] , 255U, 0);
      uint32_t param = read_register_field(&SPI_BASE_ADDRESS[3] ,(255U << 8) , 8);
      uint32_t action = read_register_field(&SPI_BASE_ADDRESS[3] , (255U << 16), 16);

      switch (SYSTEM_REGS_BASE_ADDRESS[0])
      {
      case 0:  //  IDLE SYSTEM MODE MODE
               switch (command)
               {
               case 4: // change system ode
                    switch (param)
                    {
                    case 0:  // change to drive mode
                        modify_register(SYSTEM_REGS_BASE_ADDRESS , 0xffffffff , 0 , 1);
                        break;


                    case 1:  // change to excavator arm mode
                     modify_register(SYSTEM_REGS_BASE_ADDRESS , 0xffffffff , 0 , 2);

                        break;




                    case 2:   // change to excavator arm mode
                         modify_register(SYSTEM_REGS_BASE_ADDRESS , 0xffffffff , 0 , 4);
                    
                        break;
                    
                    default:
                        break;
                    }
                break;
               
               default:
                break;
               }
        break;










     case 1:  //  DRIVE SYSTEM  MODE
             switch (command)
             {
             case 1:  // move
                  switch (param)
                  {
                  case 1:  // froward
                      modify_register(DC_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                      modify_register(DC_MOTOR_BASE_ADDRESS , 0x01 , 0x0 , 1); // set direction bit in conrol reg to 1

                    break;

                 case 2:  // backward
                     modify_register(DC_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                     modify_register(DC_MOTOR_BASE_ADDRESS , 0x01 , 0x0 , 0); // set direction bit in conrol reg to 0
                    break;
                  
                  default:
                    break;
                  }
                break;




             case 2:  // steer
                     switch (param)
                  {
                  case 5:  // left  set servo to 135 degrees (1750 microseconds)
                    //    modify_register(SERVO_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                       modify_register(SERVO_MOTOR_BASE_ADDRESS , 0xffff , 0 , 1750);
                    break;

                 case 6:  // right  set servo to 45 degrees (1250 microseconds)
                    //    modify_register(DC_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                       modify_register(SERVO_MOTOR_BASE_ADDRESS , 0xffff , 0 , 1250);

                    break;
                  
                  default:
                    break;
                  }
                break;




             case 4:   // CHANGE SYSTEM MODE
               switch (param)
                    {
                    case 0:  // change to drive mode
                    modify_register(DC_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                    modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff , 0 , 1);  
                        break;


                    case 1:  // change to excavator arm mode
                     modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0                 
                    modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff , 0 , 2);  
               
                        break;




                    case 2:   // change to excavator arm mode
                     modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0                  
                    modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff , 0 , 4);  
                        
                        break;
                    
                    default:
                        break;
                    }
          break;


             case 5:   // NO KEY PRESSED
            modify_register(DC_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 1); // assert standby mode
              break;
        break;



             
             default:
                break;
             }

    break;

       



     case 2:  //  EXCAVATOR BASE SYSTEM MODE MODE
          
          switch (command)
          {
          case 1: // MOVE
                switch (param)
                {
                case 3:  // clockwise
                modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                modify_register(STEPPER_MOTOR_BASE_ADDRESS , 0x1 , 0 , 1);
                    break;

                case 4:  //anticlockwise
                modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                modify_register(STEPPER_MOTOR_BASE_ADDRESS , 0x1 , 0 , 0);

                    break;
                
                default:
                    break;
                }
            break;



                 case 4:   // CHANGE SYSTEM MODE
               switch (param)
                    {
                    case 0:  // change to drive mode
                     modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                    modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff , 0 , 1);  
                        
                        break;


                    case 1:  // change to excavator BASE mode
                     modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0                  
                     modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff , 0 , 2);  
                       
                        break;




                    case 2:   // change to excavator arm mode
                    modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                    modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff , 0 , 4);  
                        
                        break;
                    
                    default:
                        break;
                    }
          break;


             case 5:   // NO KEY PRESSED
                     modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 1); // assert standby bit to 1

              break;
          
          default:
            break;
          }
        break;















     case 4:  //  EXCAVATOR ARM SYSTEM MODE MODE
           switch (command)
           {
           case 3: // MOVE ARM
                  switch (action)
                  {
                  case 1:  // move lower arm up
                
                    break;

                case 2:  // move lower arm down
                
                    break;


                case 3:  // move mid arm up
                
                    break;

                case 4:  // move mid arm down
                
                    break;




                case 5:  // move scoop up
                
                    break;

                case 6:  // move scoop down
                
                    break;
                  
                  default:
                    break;
                  }
            break;






                    case 4:   // CHANGE SYSTEM MODE
               switch (param)
                    {
                    case 0:  // change to drive mode
                    // modify_register(DC_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0
                    modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff , 0 , 1);  
                        break;


                    case 1:  // change to excavator arm mode
                    //  modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0                 
                    modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff , 0 , 2);  
               
                        break;




                    case 2:   // change to excavator arm mode
                    //  modify_register(STEPPER_MOTOR_BASE_ADDRESS , (0x1 << 10), 10 , 0); // assert standby bit to 0                  
                    modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff , 0 , 4);  
                        
                        break;
                    
                    default:
                        break;
                    }
          break;
             case 5:   // NO KEY PRESSED

              break;
            
           
           default:
            break;
           }
        

        break;
      
      default:
        break;
      }
}








void initialize_nrf_module(){
    
    //  if(!spi_tx_busy){
        // set spi master clk freq
                       // do this for every command
        // set no of bytes to send
        //put data into spi tx buffer
        // assert start tx
        // listen for tx going back to 0 then send the next comman bytes


          modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)

        while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){

                         }    

                 //  write to confic reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 2); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x200f);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg



         while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  




         //  write to EN_AA reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 2); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x2101);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg
        



          while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  


         //  write to EN_RX_ADDR reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 2); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x2201);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg




               while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  



        //  //  write to SETTUP_AW reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 2); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x2301);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg


                 while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  


        //  //  write to SETUP_RETY reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 2); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x2400);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg


                while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  


        //  //  write to RF_CH reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 2); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x254C);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg
        


                while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  


        //  //  write to RF_SETUP reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 2); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x2606);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg



                    while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  



        //  //  write to STSTUS reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 2); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x2770);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg




                    while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  




        //  //  write to RX_ADDR_P0 reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 4); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x2AAAAAAA);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg




                   while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  




        //  //  write to RX_PW_P0 reg
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 2); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0x3120);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg
  




                  while(read_register_field(&SPI_BASE_ADDRESS[1]  , 0x01 , 0)){
            
                         }  




        //  //  write to FLUSH_RX
        // modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
        modify_register(SPI_BASE_ADDRESS , (0xf << 16) , 16 , 1); // set number of bytes to send
        modify_register(&SPI_BASE_ADDRESS[2] , 0xffffffff , 0 , 0xE2);  // put data into the spi tx buffer
        modify_register(SPI_BASE_ADDRESS , (0x1 << 24) , 24 , 1);  // assert tx in control reg

        return;
    //  }
}






void receive_data(){
    // after detecting NRF IRQ
    // set spi freq
    // set no of bytes to receive
    // TRIGGER START_RX of spi

modify_register(SPI_BASE_ADDRESS , 0xffff , 0 , 27); // set frequency to 1mhz from 27mhz ( counter counts to 27)
modify_register(SPI_BASE_ADDRESS , (0xf << 20) , 20 , 3); // set number of bytes to receive
modify_register(SPI_BASE_ADDRESS , (0x1 << 25) , 25 , 1);  // assert rx in control reg

modify_register(&NRF24_BASE_ADDRESS[1] , 0x1 , 0 , 0); // reset irq bit in nrf status reg back to 0  ( when irq goes low  the bit goes high to show a packet has been received) 

  while (read_register_field(SPI_BASE_ADDRESS , (0x1 << 25) , 25)){
    //  wait untill rx is set to low by hardware ( spi done receiving)
  }
  

  parse_command();
  

}




void initialize_system(){
    modify_register(SYSTEM_REGS_BASE_ADDRESS , 0xffffffff , 0 , 0); // set system mode to none

     // reset dc motor control reg
    modify_register(DC_MOTOR_BASE_ADDRESS , 0x1 , 0 , 1); // set dc motor direction bit to 1
    modify_register(DC_MOTOR_BASE_ADDRESS , (0x1ff << 1) , 1 , 0x1ff); // set initial dc motor freq counter to 256
    modify_register(DC_MOTOR_BASE_ADDRESS , (0x1 << 10) , 10 , 0); // set standby bit to 0


     // reset stepper motor control reg
    modify_register(STEPPER_MOTOR_BASE_ADDRESS , 0x1 , 0 , 1); // set dc motor direction bit to 1
    modify_register(STEPPER_MOTOR_BASE_ADDRESS, (0x1ff << 1) , 1 , 0x1ff); // set initial dc motor freq counter to 256
    modify_register(STEPPER_MOTOR_BASE_ADDRESS, (0x1 << 10) , 10 , 0); // set standby bit to 0

    // reset sERVO motor control reg
    modify_register(SERVO_MOTOR_BASE_ADDRESS , 0xffff , 0 , 1500); // set initial servo motor angle to 90 degrees (duration is in microseconds)
    modify_register(SERVO_MOTOR_BASE_ADDRESS, (0x1 << 16) , 16 , 0x0); // set standby bit of servo motor to 0

    initialize_nrf_module();

    modify_register(&SYSTEM_REGS_BASE_ADDRESS[1] , 0xffffffff , 0 , 0); // set reset register to 0

}






int main(){
    // initialize whole system
                                        // initialize system regs (set mode regs to 0 --- no mode yet , set reset reg to 0)
                                        // initialize all control regs (dc , stpper , servo , spi , nrf ) --- set default freq counters ( 256) , initial direction bits to 1 , standby bit to 0
                                        // initialize nrf module -- call the function
    //    all the above done by initialize_system() function



// LOOP:
    // listen for reset
            // if reset:
              // call initialize system()
                    // then start loop again


           // else
    // listen for received command
                    // if_command is received:
                             // receive command
                             // parse command
                                    // start loop again

                            // else
                                // start loop again


    initialize_system();
    while(1){
         if(!read_register_field(&SYSTEM_REGS_BASE_ADDRESS[1] , 0xffffffff , 0)){
            if(read_register_field(&NRF24_BASE_ADDRESS[1] , 0x1 , 0)){
              // packet received
              receive_data();  // internally calls parse_command()
            }

         }else
         {
            initialize_system();
         }
          

    }
    
    
}


















































































// remember to make the duration firld in servo control register 16 bit ( 15:0) , it is in microseconds




// a web dashboard where the i is the top part has a section showing ( mode , which could be driving , or excavator arm or eacavator base  , direction which if mode is driving , could be forward or reverse , if mode is excavator arm , it could be clockwise or anticlockwise)

// there will be an array called modes , and it will contain the 3 modes , 1 = drive , 2 = excavator base , 3 = excavator arm
// at the bottom , is a keyboard UI , containing directions , alphabet ( capital) and numbers. so there will be an event listener , for button press , button release , etc , and when i press a button on the physical keyboard, the respective button on the UI becomes brighter or duller to show that it has been pressed as long as the key is pressed down

// so there will be an array of objects , each object being a key/button on the keyboard , and each will have the following properties 
        
        // index => will be the ascii code for that key pressed
        // values => another object which will have special properties like for some keys when they are pressed when shift key is down it means something eg for M , if it is pressed when shift is down , it means change mode , and it will be iterating over the modes array , changing to the next mode in the array , then wrapping back to the first one




// so when a key is pressed , there wil be a function to sen its properties to the back end , and also there will be a way to like if the button is long pressed down , the function is continuously triggered , untill it is releaded

// make this UI using chara UI framework , style it very beautifully , choose very good colors to mix , and make the U very beautiful