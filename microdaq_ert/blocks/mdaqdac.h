#ifndef _MDAQDAC_H
#define _MDAQDAC_H

void DACInit(unsigned char *ch, unsigned char ch_count, float *range, double *init, unsigned char *use_term_init);
void DACStep(unsigned char *ch, unsigned char ch_count, double *data);
void DACTerminate(unsigned char *ch, unsigned char ch_count, double *term, unsigned char *use_term_init);

#endif /* _MDAQDAC_H */
