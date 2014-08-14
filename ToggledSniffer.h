#ifndef TOGGLED_SNIFFER_H
#define TOGGLED_SNIFFER_H


enum
{
	AM_TOGGLEDSNIFFER = 6,
	AM_TEST_SERIAL_MSG = 0x56
};

typedef nx_struct ToggledSnifferMsg
{
	nx_uint16_t nodeid;
	nx_uint16_t counter;
} ToggledSnifferMsg;

typedef nx_struct test_serial_msg
{
	nx_uint16_t nodeid;
	nx_uint16_t counter;
} test_serial_msg_t;


#endif /* TOGGLED_SNIFFER_H */
