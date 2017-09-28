#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
#include <string.h>
#include "mdaq_ai.h"
#endif 

void ADCInit(unsigned char Converter, unsigned char *Channel, 
		unsigned char ChannelCount, unsigned char Range, 
		unsigned char Polarity, unsigned char Mode)
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
	int i; 
	uint32_t config[AI16]; 
	uint32_t range, polarity, mode; 

	if( ChannelCount > AI16 )
		return;

	range = 1 << (Range - 1);
	polarity = (Polarity == 2 ? AI_BIPOLAR : AI_UNIPOLAR);
	mode = (Mode == 1 ? AI_SINGLE : AI_DIFF);

	mdaq_ai_init(0,0,0);

	for(i = 0; i < ChannelCount; i++)
		config[i] = range | polarity | mode; 

 	mdaq_ai_config_ch(Channel, ChannelCount, config);

#endif
}

void ADCStep(unsigned short *adc_value, double *value, 
		unsigned char *Channel, unsigned char ChannelCount)
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
	mdaq_ai_read(Channel, ChannelCount, value);	
#endif
}
#if 0 
int mdaq_ai_init(uint32_t range, uint32_t polarity, uint32_t mode);
int mdaq_ai_config_ch( uint8_t ch[], uint8_t ch_count, uint32_t *ch_config );
int mdaq_ai_read( uint8_t ch[], uint8_t ch_count, double *data);
#endif 
