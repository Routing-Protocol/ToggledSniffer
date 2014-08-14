#include <Timer.h>
#include "ToggledSniffer.h"


configuration ToggledSnifferAppC{
}
implementation{
	
	components MainC;
	components LedsC;
	components ToggledSnifferC as App;
	components ActiveMessageC as AMRadio;
	components new AMReceiverC(AM_TOGGLEDSNIFFER);
	components SerialActiveMessageC as AMSerial;
	
	
	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.RadioControl -> AMRadio;
	App.RadioSnoop -> AMRadio.Snoop;
	App.SerialControl -> AMSerial;
	App.AMSend -> AMSerial.AMSend[AM_TEST_SERIAL_MSG];
	App.Packet -> AMSerial;
    App.AMPacket -> AMSerial;
}
