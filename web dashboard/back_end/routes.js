/*



  packet layout  STX  COMMAND , ACTION   , ETX

STX = 255
ETX = 512



// COMMANDS 
NONE = 000
OFF = 001
CHANGE STSYEM MODE = 002                                     ---- parameters ( oerating mode  [ 0 = drive , 1 = arm base , 2 = excavator arm)
CHANGE FREQUENCY = 003                                ---------- parameters(action(increase/decrease)
CHANGE DIRECTION = 004                                --parameters( DIRECTION , COULD E LEFT OR RIGHT)
RESET = 005                                           ----no parameters 
MOVE = 006                                            ----------------parameters(direction)
STEER = 007
TURN = 008
BRAKE = 009                                           --------------no parameters


/// excavator arm commands
LOWER_ARM_UP = 010                                      
LOWER_ARM_DOWN = 011

MID_ARM_UP = 012
MID_ARM_DOWN = 013

SCOOP_UP = 014
SCOOP_DOWN = 015




// ACTION
NONE = 000
INCREASE = 001
DECREASE = 002
LEFT = 003
RIGHT = 004
UP = 005
DOWN = 006
FORWARD = 007
BACKWARD = 008


//PARAMS
NONE = 000

FORWARD = 001
BACKWARD = 002

CLOCKWISE = 003
ANTICLOCKWISE = 004



*/



const express = require('express');
const router = express.Router();

// const { SerialPort } = require("serialport");


// const port = new SerialPort({
//     path: "COM4",
//     baudRate: 9600
// });

// port.on("open", () => {
//     console.log("port is Ready");
// });

//

router.post('/change_system_mode' , async function(req , res){
    try{
        // command = 002
        // parameter = index of mode in front end's modes array
        // the index is moltiplied by 2 to make it a multiple of 2

      console.log('changing system mode');
      console.log(req.body);
      const info = req.body;

      const command = info.command; // command
      const mode = info.parameter; //index

      const packet = Buffer.from([command , mode]);
    //   port.write(packet, (err) => {

    //     if (err) {
    //         console.log("Write failed:", err.message);
    //         return;
    //     }
    
    //     console.log("Packet sent.");
    
    // });
    console.log('packet' , packet)
      return  res.status(200).json({error:false , message:'successfully changed system mode' });


      
    }
    catch(err){
        console.log('error occured in trying to change system mode');
    }
})






router.post('/change_drive_mode' , async function(req , res){
    try{
        // command = 4  (change direction)
        // parameter = 1/2  (forward/reverse)
       

      console.log('changing drive mode');
      console.log(req.body);
      const info = req.body;

      const command = info.command; 
      const mode = info.parameter; 

      return  res.status(200).json({error:false , message:'successfully changed drive mode' });

      
    }
    catch(err){
        console.log('error occured in trying to change drive mode');
    }
})





router.post('/change_excavator_base_mode' , async function(req , res){
    try{
        // command = 4  (change direction)
        // parameter = 3/4  (clock_wise / anti_clockwise)
       

      console.log('changing excavatoe base mode');
      console.log(req.body);
      const info = req.body;

      const command = info.command; 
      const mode = info.parameter; 

      return  res.status(200).json({error:false , message:'successfully changed excavatoe base mode' });

      
    }
    catch(err){
        console.log('error occured in trying to change excavatoe base mode');
    }
})










































module.exports = router;