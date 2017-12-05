#ifndef _MDAQADC_H_
#define _MDAQADC_H_

void ADCInit(unsigned char *ch, unsigned char ch_count, float *range, unsigned char *mode);
void ADCStep(unsigned char *ch, unsigned char ch_count, unsigned int oversampling, double *value);


#endif /* __ADC_H */
