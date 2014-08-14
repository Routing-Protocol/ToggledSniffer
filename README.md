ToggledSniffer
==============
This application receives and displays binary counts on the leds of the mote.

The application works with the applications 'ToggledTransmit' application. It gathers all the packets sent by the transmitter and displayes the binary count it finds in the packet on the leds of the mote. 

The expected result when using this application in a mote which is not a destination of the transmitter is the display of binary digits on the mote. All the packets sent by all the transmitters in the range of the 'ToggledSniffer' is captured and only the ones that meant for the sniffer mote are discarded while the other counts are displayed on the mote's leds.
