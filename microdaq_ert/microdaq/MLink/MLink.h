/*
 * Copyright 2013-2017 Embedded Solutions
 *
 * File: MLink.h     $Revision: 2.0.0 $
 *
 * Abstract:
 *	MLink function prototypes
 */

#ifndef MLINK_H
#define MLINK_H

#include <stdint.h>

#define OUT
#define IN
#define IO

#define EXTERNC
#define MDAQ_API

#define	AI_SINGLE	0 
#define AI_DIFF		1

/* Utility functions */ 
EXTERNC MDAQ_API int mlink_connect( const char *addr, uint16_t port, int *link );
EXTERNC MDAQ_API int mlink_disconnect( int link_fd );
EXTERNC MDAQ_API void mlink_disconnect_all( void );

EXTERNC MDAQ_API char *mlink_error( int err );
EXTERNC MDAQ_API char *mlink_version( int *link_fd );
EXTERNC MDAQ_API int mlink_hwid( int *link_fd, int *hwid );
EXTERNC MDAQ_API int mlink_fw_upload( int *link_fd, const char *fw_file);

/* DSP handling functions */
EXTERNC MDAQ_API int mlink_dsp_load( int *link_fd, const char *dsp_binary_path, const char *args );
EXTERNC MDAQ_API int mlink_dsp_start( int *link_fd );
EXTERNC MDAQ_API int mlink_dsp_stop( int *link_fd );
EXTERNC MDAQ_API int mlink_dsp_upload( int *link_fd );

/* Digital IO functions */ 
EXTERNC MDAQ_API int mlink_dio_set_func( int *link_fd, uint8_t function, uint8_t enable );
EXTERNC MDAQ_API int mlink_dio_set_dir( int *link_fd, uint8_t pin, uint8_t dir, uint8_t init_value );
EXTERNC MDAQ_API int mlink_dio_write( int *link_fd, uint8_t pin, uint8_t value );
EXTERNC MDAQ_API int mlink_dio_read( int *link_fd, uint8_t pin, uint8_t *value );
EXTERNC MDAQ_API int mlink_led_write( int *link_fd, uint8_t led, uint8_t state );
EXTERNC MDAQ_API int mlink_func_read( int *link_fd, uint8_t key, uint8_t *state );

/* Encoder read functions */ 
EXTERNC MDAQ_API int mlink_enc_read( int *link_fd, uint8_t ch, uint8_t *dir, int32_t *value );
EXTERNC MDAQ_API int mlink_enc_init( int *link_fd, uint8_t ch, int32_t init_value );

/* PWM functions */ 
EXTERNC MDAQ_API int mlink_pwm_init( int *link_fd, uint8_t module, uint32_t period, uint8_t active_low, float duty_a, float duty_b );
EXTERNC MDAQ_API int mlink_pwm_write( int *link_fd, uint8_t module, float duty_a, float duty_b );

/* Memory access functions */
EXTERNC MDAQ_API int mlink_mem_read(int *link_fd, int index, int length, float *data);
EXTERNC MDAQ_API int mlink_mem_write(int *link_fd, int index, int length, float *data);

/* PRU functions */ 
EXTERNC MDAQ_API int mlink_pru_exec( int *link_fd, const char *pru_fw, uint8_t pru_num, uint8_t build_in_fw );
EXTERNC MDAQ_API int mlink_pru_stop( int *link_fd, uint8_t pru_num );
EXTERNC MDAQ_API int mlink_pru_reg_read( int *link_fd, uint8_t pru_num, uint8_t reg, uint32_t *reg_value );
EXTERNC MDAQ_API int mlink_pru_reg_write( int *link_fd, uint8_t pru_num, uint8_t reg, uint32_t reg_value );
EXTERNC MDAQ_API int mlink_pru_state_read( int *link_fd, uint8_t *pru0, uint8_t *pru1);

/* AI functions */ 
EXTERNC MDAQ_API int mlink_ai_read( int *link_fd, uint8_t *ch, uint8_t ch_count, double *range, uint8_t *mode, double *data );
EXTERNC MDAQ_API int mlink_ai_scan_init(int *link_fd, uint8_t *ch, uint8_t ch_count, double *range, uint8_t *mode, float *rate, float duration);
EXTERNC MDAQ_API int mlink_ai_scan(double *data, uint32_t scan_count, int32_t blocking);
EXTERNC MDAQ_API int mlink_ai_scan_stop( void );
EXTERNC MDAQ_API int mlink_ai_check_params(int *link_fd, uint8_t *ch, uint8_t ch_count, double *range, uint8_t *mode);
EXTERNC MDAQ_API int mlink_ai_scan_get_ch_count(void);

/* AO functions */ 
EXTERNC MDAQ_API int mlink_ao_write( int *link_fd, uint8_t *ch, uint8_t ch_count, double *range, uint8_t mode, double *data );
EXTERNC MDAQ_API int mlink_ao_scan_init(int *link_fd, uint8_t *ch, uint8_t ch_count, float *data, int data_size, double *range, uint8_t stream_mode, float rate, float duration);
EXTERNC MDAQ_API int mlink_ao_scan(int *link_fd);
EXTERNC MDAQ_API int mlink_ao_scan_stop(int *link_fd);
EXTERNC MDAQ_API int mlink_ao_scan_data(int *link_fd, uint8_t *ch, int ch_count, float *data, int data_size, uint8_t opt);
EXTERNC MDAQ_API int mlink_ao_check_params(int *link_fd, uint8_t *ch, uint8_t ch_count, double *range);

#endif /* MLINK_H */ 
