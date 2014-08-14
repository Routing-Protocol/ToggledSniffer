#include <Timer.h>
#include "ToggledSniffer.h"


module ToggledSnifferC{
	
	uses interface Boot;
	uses interface Leds;
	uses interface Packet;
	uses interface AMPacket;
	
	uses interface Receive as RadioSnoop[am_id_t id];
	uses interface SplitControl as RadioControl;
	
	uses interface SplitControl as SerialControl;
	uses interface AMSend;
}
implementation{
	
	message_t packet;
	
	bool busy = FALSE;
	bool locked = FALSE;
	
	
	void setLeds(uint16_t val)
	{
		if (val & 0x01)
		    call Leds.led0On();
		else
		    call Leds.led0Off();
		if (val & 0x02)
		    call Leds.led1On();
		else 
		    call Leds.led1Off();
	    if (val & 0x04)
	        call Leds.led2On();
	    else 
	        call Leds.led2Off();
	 }
	 
	 event void Boot.booted()
	 {
	 	call SerialControl.start();
	 }   
	     
	 event void SerialControl.startDone(error_t err)
	 {
	 	if (err == SUCCESS)
	 	{
	 		call RadioControl.start();
	 	}
	 	else
	 	{
	 		call SerialControl.start();
	 	}
	 }
	 
	 event void RadioControl.startDone(error_t err)
	 {
	 	if (err == SUCCESS)
	 	{}
	 	else
	 	{
	 		call RadioControl.start();
	 	}
	 }
	 
	 event void RadioControl.stopDone(error_t err)
	 {}
	 
	 event void SerialControl.stopDone(error_t err)
	 {}
	 
	 event message_t* RadioSnoop.receive[am_id_t id](message_t* msg, void* payload, uint8_t len)
	 {
	 	dbg("ToggledSnifferC", "Received a packet of lenght %hhu @ %s with payload : %hhu \n", len, sim_time_string(), payload);
	 	
	 	if (call AMPacket.isForMe(msg) == TRUE)
	 	{
	 		if (len == sizeof(ToggledSnifferMsg))
	 		{
	 			ToggledSnifferMsg* tspkt = (ToggledSnifferMsg*)payload;
	 			setLeds(tspkt->counter);
	 			
	 			if (locked)
	 			{
	 				return msg;
	 			}
	 			
	 			else
	 			{
	 				test_serial_msg_t* rcm = (test_serial_msg_t*)call Packet.getPayload(&packet, sizeof(test_serial_msg_t));
	 				
	 				if (rcm == NULL)
	 				{
	 					return msg;
	 				}
	 				
	 				rcm->counter = tspkt->counter;
	 				rcm->nodeid = tspkt->nodeid;
	 			}
	 			
	 			if (call AMSend.send(0x00, &packet, sizeof(test_serial_msg_t)) == SUCCESS)
	 			{
	 				locked = TRUE;
	 			}
	 		}
	 	}
	 	
	 	return msg;
	 }
	 
	 event void AMSend.sendDone(message_t* bufptr, error_t err)
	 {
	 	if (&packet == bufptr)
	 	{
	 		locked = FALSE;
	 	}
	 }
	
}
