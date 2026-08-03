/*

packet format =====> [COMMAND , PARAM , ACTION]

COMMANDS =========> MOVE             01
                    STEER            02
                    MOVE_ARM         03


  


PARAMS ============> FROWARD         01
                     BACKWARD        02
                     CLOCKWISE       03
                     ANTI_CLOCKWISE  04
                     LEFT            05
                     RIGHT           06

                    


ACTIONS ===========> LOW_ARM_UP     01
                     LOW_ARM_DOWN   02
                     MID_ARM_UP     03
                     MID_ARM_DOWN   04
                     SCOOP_UP       05
                     SCOOP_DOWN     06
                    

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


router.post('/send_command' , async function(req , res){
  try{
      // command = 002
      // parameter = index of mode in front end's modes array
      // the index is moltiplied by 2 to make it a multiple of 2

    console.log('processing command');
    console.log(req.body);

    const info = req.body;
     console.log(info);
    const command = info.command; // command
    const param = info.parameter; //index
    const action = req.action;
    const packet = Buffer.from([command , param , action]);
  //   port.write(packet, (err) => {

  //     if (err) {
  //         console.log("Write failed:", err.message);
  //         return;
  //     }
  
  //     console.log("Packet sent.");
  
  // });
  console.log('packet');
  console.log(packet);
    return  res.status(200).json({error:false , message:'successfully changed system mode' });


    
  }
  catch(err){
      console.log('error occured in trying to change system mode');
  }
})














// router.post('/change_system_mode' , async function(req , res){
//     try{
//         // command = 002
//         // parameter = index of mode in front end's modes array
//         // the index is moltiplied by 2 to make it a multiple of 2

//       console.log('changing system mode');
//       console.log(req.body);
//       const info = req.body;

//       const command = info.command; // command
//       const mode = info.parameter; //index

//       const packet = Buffer.from([command , mode]);
//     //   port.write(packet, (err) => {

//     //     if (err) {
//     //         console.log("Write failed:", err.message);
//     //         return;
//     //     }
    
//     //     console.log("Packet sent.");
    
//     // });
//     console.log('packet' , packet)
//       return  res.status(200).json({error:false , message:'successfully changed system mode' });


      
//     }
//     catch(err){
//         console.log('error occured in trying to change system mode');
//     }
// })






// router.post('/change_drive_mode' , async function(req , res){
//     try{
//         // command = 4  (change direction)
//         // parameter = 1/2  (forward/reverse)
       

//       console.log('changing drive mode');
//       console.log(req.body);
//       const info = req.body;

//       const command = info.command; 
//       const mode = info.parameter; 

//       return  res.status(200).json({error:false , message:'successfully changed drive mode' });

      
//     }
//     catch(err){
//         console.log('error occured in trying to change drive mode');
//     }
// })





// router.post('/change_excavator_base_mode' , async function(req , res){
//     try{
//         // command = 4  (change direction)
//         // parameter = 3/4  (clock_wise / anti_clockwise)
       

//       console.log('changing excavatoe base mode');
//       console.log(req.body);
//       const info = req.body;

//       const command = info.command; 
//       const mode = info.parameter; 

//       return  res.status(200).json({error:false , message:'successfully changed excavatoe base mode' });

      
//     }
//     catch(err){
//         console.log('error occured in trying to change excavatoe base mode');
//     }
// })










































module.exports = router;