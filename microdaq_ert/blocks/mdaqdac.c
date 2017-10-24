#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
#include "mdaq_ao.h"
#endif

#define MAX_AO_CH       (16)

#define CH_COUNT_INDEX  (0)
#define CHANNELS_INDEX  (1)

#define NOT_USE_INIT_TERM   (0)
#define USE_INIT        (1)
#define USE_TERM        (2)
#define USE_INIT_TERM   (3)


void DACInit(unsigned char *ch, unsigned char ch_count, float *range, double *init, unsigned char *use_term_init)
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)

    int i, k;
    uint8_t tmp_ch[MAX_AO_CH];
    double tmp_init_value[MAX_AO_CH];

    memset((void *)tmp_ch, 0x0, MAX_AO_CH);
    memset((void *)tmp_init_value, 0x0, sizeof(tmp_init_value));

    /* init DAC converter */
    mdaq_ao_init(AO_SYNC);

    /* set DAC ranges */
    mdaq_ao_ch_config(ch, range, ch_count);

    k = 0;
    for(i = 0; i < ch_count; i++)
    {
        if (use_term_init[i] == USE_INIT ||
            use_term_init[i] == USE_INIT_TERM)
        {
            tmp_ch[k] = ch[i];
            tmp_init_value[k] = init[i];
            k++;
        }
    }

    if (k > 0)
        mdaq_ao_write(tmp_ch, k, tmp_init_value);
#endif
}

void DACStep(unsigned char *ch, unsigned char ch_count, double *data)
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)

    if ( ch_count > MAX_AO_CH)
        return; 

	mdaq_ao_write(ch, ch_count, data);
#endif
}

void DACTerminate(unsigned char *ch, unsigned char ch_count, double *term, unsigned char *use_term_init)
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
    int i;
    for(i = 0; i < ch_count; i++)
    if (use_term_init[i] == USE_TERM ||
        use_term_init[i] == USE_INIT_TERM)
        mdaq_ao_write(&ch[i], 1, &term[i]);
#endif
}

