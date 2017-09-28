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

enum ai_range
{
	AI_10V,
	AI_5V,
	AI_2V5,
	AI_1V25,
	AI_0V64,
	AI_0V32,

	AI_RANGE
};

enum ai_polarity
{
	AI_BIPOLAR = 24,
	AI_UNIPOLAR, 
	
	AI_POLARITY
};

enum ai_mode
{
	AI_SINGLE = 28, 
	AI_DIFF,

	AI_MODE
};

#define AI_PARAM_MASK		(0x3300003F)

/* Utility functions */ 
EXTERNC MDAQ_API char *mlink_error( int err );
EXTERNC MDAQ_API char *mlink_version( int *link_fd );
EXTERNC MDAQ_API int mlink_hwid( int *link_fd, int *hwid );
EXTERNC MDAQ_API int mlink_fw_upload( int *link_fd, const char *fw_file);

EXTERNC MDAQ_API int mlink_connect( const char *addr, uint16_t port, int *link );
EXTERNC MDAQ_API int mlink_disconnect( int link );
EXTERNC MDAQ_API void mlink_disconnect_all( void );

/* DSP handling functions */
EXTERNC MDAQ_API int mlink_dsp_load( int *link_fd, const char *dspapp, const char *param );
EXTERNC MDAQ_API int mlink_dsp_start( int *link_fd );
EXTERNC MDAQ_API int mlink_dsp_stop( int *link_fd );
EXTERNC MDAQ_API int mlink_dsp_upload( int *link_fd );

/* Digital IO functions */ 
EXTERNC MDAQ_API int mlink_dio_set_func( int *link_fd, uint8_t function, uint8_t enable );
EXTERNC MDAQ_API int mlink_dio_set_dir( int *link_fd, uint8_t pin, uint8_t dir, uint8_t init_value );
EXTERNC MDAQ_API int mlink_dio_set( int *link_fd, uint8_t pin, uint8_t value );
EXTERNC MDAQ_API int mlink_dio_get( int *link_fd, uint8_t pin, uint8_t *value );
EXTERNC MDAQ_API int mlink_led_set( int *link_fd, uint8_t led, uint8_t state );
EXTERNC MDAQ_API int mlink_func_key_get( int *link_fd, uint8_t key, uint8_t *state );

/* Encoder read functions */ 
EXTERNC MDAQ_API int mlink_enc_get( int *link_fd, uint8_t ch, uint8_t *dir, int32_t *value );
EXTERNC MDAQ_API int mlink_enc_reset( int *link_fd, uint8_t ch, int32_t init_value );

/* PWM functions */ 
EXTERNC MDAQ_API int mlink_pwm_config( int *link_fd, uint8_t module, uint32_t period, uint8_t active_low, float pwm_a, float pwm_b );
EXTERNC MDAQ_API int mlink_pwm_set( int *link_fd, uint8_t module, float channel_a, float channel_b );

/* PRU functions */ 
EXTERNC MDAQ_API int mlink_pru_exec( int *link_fd, const char *pru_fw, uint8_t pru_num, uint8_t build_in_fw );
EXTERNC MDAQ_API int mlink_pru_stop( int *link_fd, uint8_t pru_num );
EXTERNC MDAQ_API int mlink_pru_reg_get( int *link_fd, uint8_t pru_num, uint8_t reg, uint32_t *reg_value );
EXTERNC MDAQ_API int mlink_pru_reg_set( int *link_fd, uint8_t pru_num, uint8_t reg, uint32_t reg_value );
EXTERNC MDAQ_API int mlink_pru_state_get( int *link_fd, uint8_t *state_ai, uint8_t *state_ao);

/* AI function */ 
EXTERNC MDAQ_API int mlink_ai_read( int *link_fd, uint8_t *ch, uint8_t ch_count, uint8_t *range, uint8_t *polarity, uint8_t *mode, double *data );
EXTERNC MDAQ_API int mlink_ao_write( int *link_fd, uint8_t dac, uint8_t *ch, uint8_t ch_count, uint8_t *range, uint8_t mode, double *data );
EXTERNC MDAQ_API int mlink_ao_ch_config(int *link_fd, uint8_t *ch, uint8_t ch_count, uint8_t *range);

EXTERNC MDAQ_API int mlink_ai_scan_init(int *link_fd, uint8_t *ch, uint8_t ch_count, uint8_t *range, uint8_t *polarity, uint8_t *mode, float *freq, float scan_time);
EXTERNC MDAQ_API int mlink_ai_scan(double *data, uint32_t scan_count, int32_t blocking);
EXTERNC MDAQ_API void mlink_ai_scan_stop( void );

EXTERNC MDAQ_API int mlink_ao_scan_init(int *link_fd, uint8_t *ch, uint8_t ch_count, float *data, int data_size, uint8_t *range, uint8_t continuous, float freq, float scan_time);
EXTERNC MDAQ_API int mlink_ao_scan_data(int *link_fd, uint8_t *ch, int ch_count, float *data, int data_size, uint8_t blocking_reset);

EXTERNC MDAQ_API int mlink_ao_scan(int *link_fd);
EXTERNC MDAQ_API int mlink_ao_scan_stop(int *link_fd);


#endif /* MLINK_H */ 
