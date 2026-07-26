/*



  packet layout  STX  COMMAND , ACTION   , ETX

STX = 255
ETX = 512



// COMMANDS 
NONE = 000
OFF = 001
CHANGE SYSTEM MODE = 002                                     ---- parameters ( oerating mode  [ 0 = drive , 1 = arm base , 2 = excavator arm)
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


import React, { useEffect, useState } from "react";
import {
  Box,
  VStack,
  HStack,
  Flex,
  Text,
  Heading,
} from "@chakra-ui/react";

export default function Control_Dashboard() {








    const modes = [
        "Drive",
        "Excavator Base",
        "Excavator Arm",
      ];
    
      const keyboard = [
        ["1","2","3","4","5","6","7","8","9","0"],
        ["Q","W","E","R","T","Y","U","I","O","P"],
        ["A","S","D","F","G","H","J","K","L"],
        ["SHIFT","Z","X","C","V","B","N","M","ENTER"],
        ["SPACE"],
      ];
    
     
    
      const arrows = [
        "ArrowUp",
        "ArrowLeft",
        "ArrowDown",
        "ArrowRight",
      ];







  
  const [pressedKeys, setPressedKeys] = useState(new Set());
  let [mode_index , set_mode_index] = useState(0);
  let current_mode = modes[mode_index];
  console.log("current mode is" , current_mode);
  let command ;
  let action ;
  let parameter;



  useEffect(() => {
    console.log([...pressedKeys]);
}, [pressedKeys]);


 


  const send_control = async function(){  // when a button is pressed
      const response = await fetch("http://localhost:3000/"  , {
        method: "POST",
        headers:{
            "Content-Type":"application/json"
        },
        body : JSON.stringify({
             command:command,
             action:action
        })
      });
  }





  const change_mode = async function(){
   try{
    console.log('changing system mode');
    set_mode_index(function(prev){
        return (prev + 1) % (modes.length);
    });

   

    
    // const response = await fetch();
   }
   catch(err){
     console.log("error occured while changing mode" , err);
   }

  }







  useEffect(function(){
    
  } , [])
  



const change_system_mode = async function(){
   try{
    //  await change_mode();

    const nextMode = (mode_index + 1) % modes.length;

    set_mode_index(nextMode);

    

    const res = await  fetch("http://localhost:3000/change_system_mode" ,{
      method:'POST',
      headers:{
          "Content-Type":"application/json"
      },

      body : JSON.stringify({
          command:  command,
          parameter: nextMode,
          action:0

      })

    
  

  })

  if(!res.ok){
      throw new Error('response not okay');
  }

  const info = await res.json();
  console.log(info);

  


   
   }
   catch(err){
    console.log("error occured while changing system mode" , err);

   }
}











  const change_drive_mode = async function(){
    console.log('changing drive mode');
          try{
            const res = await  fetch("http://localhost:3000/change_drive_mode" ,{
                method:'POST',
                headers:{
                    "Content-Type":"application/json"
                },
        
                body : JSON.stringify({
                    command:  command,
                    parameter: parameter,
                    action:0
                    
                })
        
              
        
        
            })

            if(!res.ok){
                throw new Error('response not okay');
            }

            const info = await res.json();
            console.log(info);
          } catch(err){
            console.log('error occured trying to change drive mode' , err);
          }
 }


 const change_excavator_base_mode = async function(){
    console.log('changing excavator base mode');


    try{
        const res = await  fetch("http://localhost:3000/change_excavator_base_mode" ,{
            method:'POST',
            headers:{
                "Content-Type":"application/json"
            },
    
            body : JSON.stringify({
                command:  command,
                parameter: parameter,
                action:0
            })
    
          
    
    
        })

        if(!res.ok){
            throw new Error('response not okay');
        }

        const info = await res.json();
        console.log(info);
      } catch(err){
        console.log('error occured trying to change excavator base mode' , err);
      }
 }





















  useEffect(() => {

    const handleKeyDown = (e) => {


         // for normal keys
         if(e.key.length == 1){
            const key = e.key.length === 1
            ? e.key.toUpperCase()
            : e.key;
    
          setPressedKeys(prev => {
            const copy = new Set(prev);
            copy.add(key);
            return copy;
          });



          if(key == "M" && e.shiftKey){
            command = 2 // change system mode
            change_system_mode(command );
          } 



     
          switch (current_mode) {

            case "Drive":
                
              
          if(e.code == "Digit1" && e.shiftKey){
            command = 4; //change direction
            parameter = 1 // forward
            change_drive_mode(); // Change direction of the drive motor
          } 


          if(e.code == "Digit2" && e.shiftKey){
            command = 4; //change direction
            parameter = 2 // backward
            change_drive_mode();  // Change direction of the drive motor
          }

                break;















            
            case "Excavator Base":
                
                     
          if(e.code == "Digit1" && e.shiftKey){
            command = 4; //change direction
            parameter = 3 // clockwise 
            change_excavator_base_mode(); // Change direction of the drive motor
          } 


          if(e.code == "Digit2" && e.shiftKey){
            command = 4; //change direction
            parameter = 1 // anti clockwise
            change_excavator_base_mode();  // Change direction of the drive motor
          }
            

                break;



            


























            case "Excavator Arm":
                 
                break;
          
            default:
                break;
          }



        

         } 
         else{   // special keys and symbols
            if(e.shiftKey){
                setPressedKeys(prev => {
                    const copy = new Set(prev);
                    copy.add("Shift");
                    return copy;
                  });
            } 




            switch (current_mode) {
                case "Drive":
                    
                  switch (e.key) {
                    case "ArrowUp":
                        command = (6); // MOVE
                        // action = (7); //forward not neeed
                        break;
    
    
                    case "ArrowDown":
                        command = (6); // MOVE
                        // action = (8); // backward
                        break;
    
                    
                        case "ArrowLeft":
                            command = (7); // steer
                            // action = (3);
                        break;
    
    
    
    
                        case "ArrowRight":
                            command = (7); // steer
                            // action = (4);
                        break;
                  
                    default:
                        break;
                  }
    
    
                    break;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
                
                case "Excavator Base":
                    
                switch (e.key) {
                 
    
                    
                        case "ArrowLeft":
                            command = (6); // MOVE 
                            // action = (3);
                        break;
    
    
    
    
                        case "ArrowRight":
                            command = (6); // MOVE
                            // action = (4);
                        break;
                  
                    default:
                        break;
                  }
    
                
    
                    break;
    
    
    
                
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
                case "Excavator Arm":
                     
                    break;
              
                default:
                    break;
              }
         }
      

    console.log(pressedKeys);

    };

    const handleKeyUp = (e) => {

      const key = e.key.length === 1
        ? e.key.toUpperCase()
        : e.key;

      setPressedKeys(prev => {
        const copy = new Set(prev);
        copy.delete(key);
        return copy;
      });



    };

    window.addEventListener("keydown", handleKeyDown);
    window.addEventListener("keyup", handleKeyUp);

    return () => {

      window.removeEventListener("keydown", handleKeyDown);
      window.removeEventListener("keyup", handleKeyUp);

    };

  }, [current_mode]);

  const Key = ({ label, value }) => {

    const active = pressedKeys.has(value);
  
    let width = "60px";
  
    if (label === "SHIFT")
      width = "110px";
  
    if (label === "ENTER")
      width = "110px";
  
    if (label === "SPACE")
      width = "420px";
  
    return (
  
      <Flex
        w={width}
        h="60px"
        justify="center"
        align="center"
        bg={active ? "cyan.400" : "#1B2433"}
        color={active ? "black" : "white"}
        borderRadius="12px"
        border="2px solid"
        borderColor={active ? "cyan.200" : "#334155"}
        fontWeight="bold"
        fontSize="20px"
        transition="0.08s"
        transform={active ? "translateY(4px)" : "translateY(0px)"}
        boxShadow={
          active
            ? "0px 0px 20px cyan"
            : "0px 5px 10px rgba(0,0,0,0.5)"
        }
        userSelect="none"
      >
        {label}
      </Flex>
  
    );
  
  };
  return (

    <Box
      bg="#09111F"
      minH="100vh"
      color="white"
      p={8}
    >

      <VStack spacing={12}>

        {/* TOP */}

        <Box
          w="100%"
          maxW="1000px"
          bg="#111C2E"
          borderRadius="20px"
          p={8}
          border="1px solid #23314A"
          boxShadow="xl"
        >

          <Heading
            size="md"
            mb={8}
            color="cyan.300"
          >
            ROBOT OPERATING MODE
          </Heading>

          <HStack spacing={8} justify="center">

            {modes.map(function(mode , index){
        return <>
              <Flex
                key={mode}
                flex={1}
                maxW="250px"
                h="90px"
                bg={(current_mode == mode)?"gray.400":"#182437"}
                borderRadius="16px"
                justify="center"
                align="center"
                border="2px solid"
                borderColor={(current_mode == mode)?"white":"cyan.500"}
                transition=".2s"
                _hover={{
                  bg:"#22324A",
                  transform:"translateY(-3px)",
                  boxShadow:"0px 0px 15px cyan"
                }}
              >

                <Text
                  fontWeight="bold"
                  fontSize="lg"
                >
                  {mode}
                </Text>

              </Flex>
              </>

})}

          </HStack>

        </Box>

        {/* BOTTOM */}

        <Box
          w="100%"
          maxW="1000px"
          bg="#111C2E"
          p={8}
          borderRadius="20px"
          border="1px solid #23314A"
        >

          <Heading
            size="md"
            mb={6}
            color="cyan.300"
          >
            KEYBOARD INPUT
          </Heading>

          <VStack spacing={3}>

            {keyboard.map((row,i)=>

              <HStack key={i}>

                {row.map(key=>

<Key
key={key}
label={key}
value={
    key === "SHIFT"
        ? "Shift"
        : key === "ENTER"
        ? "Enter"
        : key === "SPACE"
        ? " "
        : key
}
/>

                )}

              </HStack>

            )}

            <HStack mt={6} spacing={5}>

              <Key label="↑" value="ArrowUp"/>

            </HStack>

            <HStack spacing={5}>

              <Key label="←" value="ArrowLeft"/>

              <Key label="↓" value="ArrowDown"/>

              <Key label="→" value="ArrowRight"/>

            </HStack>

          </VStack>

        </Box>

      </VStack>

    </Box>

  );

}