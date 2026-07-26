#include <stdint.h>

 













#define RODATA_BASE_ADDRESS          ((const volatile uint32_t *)0x08FF)  // RODATA base address



#define DC_MOTOR_BASE_ADDRESS        ((volatile uint32_t *)0x0BFF)  //DC motor peripheral base address


#define STEPPER_MOTOR_BASE_ADDRESS   ((volatile uint32_t *)0x0C1F)   //stepper motor peripheral base address

#define SERVO_MOTOR_BASE_ADDRESS     ((volatile uint32_t *)0x0C3F)   //servo motor peripheral base address

#define SPI_BASE_ADDRESS            ((volatile uint32_t *)0x0C5F)   //SPI peripheral base address

#define NRF24_BASE_ADDRESS          ((volatile uint32_t *)0x0C7F)   //NRF tranciever peripheral base address
#define SYSTEM_REGS_BASE_ADDRESS          ((volatile uint32_t *)0x0C9F)   //NRF tranciever peripheral base address ( 3231)




void modify_register(volatile uint32_t* reg_address , uint32_t mask , uint32_t shift , uint32_t action ){
    uint32_t value = *reg_address;
    // extract the field bits
    uint32_t field_bits = (value >> shift) & (mask >> shift);
    // least frequency value = 64 max = 256

    // modify the field bits
    switch (action)
    {
    case 64:   // INCREASE_freq
           if(field_bits == 256){

           }else{
            field_bits >> 2; // multiply by 2 
           }
        break;

      case 128:   // DECREASE_freq
           if(field_bits == 64){

           }else{
            field_bits << 2; // divide by 2 
           }
        break;


       case 256:   // change motor direction
          field_bits = ~field_bits;  // invert the direction bit
        break;

         
    
    
    
    default:
        break;
    }

//    clear the field bits
    uint32_t removed_field = value &  ~(mask);
    // insert new field value
    uint32_t new_reg_bits = removed_field | (field_bits << shift);

    *reg_address = new_reg_bits;
}













uint32_t read_register_field(volatile uint32_t* reg_address , uint32_t mask , uint32_t shift , uint32_t action ){
          uint32_t value = *reg_address;
    // extract the field bits
    uint32_t field_bits = (value >> shift) & (mask >> shift);
    // least frequency value = 64 max = 256
    return field_bits;
}













void send_servo_pulse(volatile uint32_t* servo_control_reg_address , uint32_t duration_mask , uint32_t duration_shift  , uint32_t angle){
   uint32_t pulse_width;
  
  uint16_t value = *servo_control_reg_address;

switch (angle)
{
    case 0:
        pulse_width = 1000;
        break;

    case 15:
        pulse_width = 1083;
        break;

    case 30:
        pulse_width = 1167;
        break;

    case 45:
        pulse_width = 1250;
        break;

    case 60:
        pulse_width = 1333;
        break;

    case 75:
        pulse_width = 1417;
        break;

    case 90:
        pulse_width = 1500;
        break;

    case 105:
        pulse_width = 1583;
        break;

    case 120:
        pulse_width = 1667;
        break;

    case 135:
        pulse_width = 1750;
        break;

    case 150:
        pulse_width = 1833;
        break;

    case 165:
        pulse_width = 1917;
        break;

    case 180:
        pulse_width = 2000;
        break;

    default:
        /* Invalid angle */
        pulse_width = 1500;   // Default to 90°
        break;
}


//    clear the field bits
    uint32_t removed_field = value &  ~(duration_mask);
    // insert new field value
    uint32_t new_reg_bits = removed_field | (pulse_width << duration_shift);

    *servo_control_reg_address = new_reg_bits;

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