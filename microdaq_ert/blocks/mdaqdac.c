#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
#include "mdaq_ao.h"
#endif

#define MDAQ_AOUT_MAX   (16)

void DACInit( unsigned char converter, unsigned char *channels, 
        unsigned char channel_count, unsigned char mode, 
        unsigned char update_mode_tirg )
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
	int i; 
	uint8_t range[MDAQ_AOUT_MAX];
	for(i = 0; i < channel_count; i++)
		range[i] = mode; 
	
    mdaq_ao_init(1, AO_SYNC);
	mdaq_ao_ch_config(channels, range, channel_count);
#endif

}

void DACStep(double *dac_data, unsigned char *channels, 
        unsigned char channel_count)
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
    if ( channel_count > MDAQ_AOUT_MAX)
        return; 

    mdaq_ao_write(channels, channel_count, dac_data);
#endif
}

void DACTerminate(double *dac_data_term, unsigned char channel_count, 
        unsigned short term_all_ch)
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
    int count, i; 
    double term_voltage[MDAQ_AOUT_MAX];
    unsigned char ch_config[MDAQ_AOUT_MAX]; 

    for(i = 0; i < channel_count; i++)
    {
	term_voltage[i] = 0.0; 
	ch_config[i] = i + 1; 

    }
    if ( term_all_ch )
    {
        if ( dac_data_term[0] != 0 )
        {
            for(count = 0; count < MDAQ_AOUT_MAX; count++ ) 
            {
                term_voltage[count] = dac_data_term[0]; 
            }
        }
        mdaq_ao_write(ch_config, sizeof(ch_config), term_voltage);
    }
    else
    {
        mdaq_ao_write(ch_config, channel_count, dac_data_term);
    }
    return; 
#endif
}

