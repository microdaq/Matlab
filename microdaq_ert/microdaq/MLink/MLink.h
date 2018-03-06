/*
 * Copyright 2013-2017 Embedded Solutions
 *
 * File: MLink.h     $Revision: 2.1.0 $
 *
 * Abstract:
 *	MLink function prototypes
 */

#ifndef _MLINK_H_
#define _MLINK_H_

#include <stdint.h>

#define EXTERNC
#define MDAQ_API

/* Utility functions */ 
EXTERNC MDAQ_API int mlink_connect( const char *addr, uint16_t port, int *link );
EXTERNC MDAQ_API int mlink_disconnect( int link_fd );
EXTERNC MDAQ_API void mlink_disconnect_all( void );

EXTERNC MDAQ_API char *mlink_error( int err );
EXTERNC MDAQ_API int mlink_fw_version(int *link_fd, int *major, int *minor, int *fix, int *build);
EXTERNC MDAQ_API int mlink_lib_version(int *link_fd, int *major, int *minor, int *fix, int *build);

EXTERNC MDAQ_API int mlink_hwid( int *link_fd, int *hwid );
EXTERNC MDAQ_API int mlink_fw_upload( int *link_fd, const char *fw_file);

/* DSP handling functions */
EXTERNC MDAQ_API int mlink_dsp_run(int *link_fd,  const char *dsp_binary_path, double period);
EXTERNC MDAQ_API int mlink_dsp_signal_read(int signal_id, int signal_size, double *data, int data_size, int timeout);
EXTERNC MDAQ_API int mlink_dsp_mem_write(int *link_fd, int start_idx, int len, float *data);
EXTERNC MDAQ_API int mlink_dsp_stop(int *link_fd );

EXTERNC MDAQ_API int mlink_dsp_load( int *link_fd, const char *dsp_binary_path, const char *args );
EXTERNC MDAQ_API int mlink_dsp_start( int *link_fd );
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
EXTERNC MDAQ_API int  mlink_ai_read( int *link_fd, uint8_t *ch, uint8_t ch_count, double *range, uint8_t *mode, double *data );
EXTERNC MDAQ_API int  mlink_ai_scan_init(int *link_fd, uint8_t *ch, uint8_t ch_count, double *range, uint8_t *mode, float *rate, float duration);
EXTERNC MDAQ_API int  mlink_ai_scan(double *data, uint32_t scan_count, int32_t blocking);
EXTERNC MDAQ_API int  mlink_ai_scan_stop( void );
EXTERNC MDAQ_API int  mlink_ai_check_params(int *link_fd, uint8_t *ch, uint8_t ch_count, double *range, uint8_t *mode);
EXTERNC MDAQ_API int  mlink_ai_scan_get_ch_count(void);

/* Recorder functions */ 

EXTERNC MDAQ_API int mlink_recorder_start(int *link_fd, char *filename, char *comments, uint32_t has_comments, uint32_t is_csv, uint32_t is_seq, uint32_t time_format, uint32_t append, uint32_t time, uint32_t sec_between_scan, uint32_t ch_count, float rate, float duration); 
EXTERNC MDAQ_API int mlink_recorder_stop(int *link_fd); 
EXTERNC MDAQ_API int mlink_recorder_info(int *link_fd, uint8_t ch[], uint8_t ch_count, char *label, uint8_t len, uint32_t *done, uint32_t *status, uint32_t *remaining); 

/* AO functions */ 
EXTERNC MDAQ_API int mlink_ao_write( int *link_fd, uint8_t *ch, uint8_t ch_count, double *range, uint8_t mode, double *data );
EXTERNC MDAQ_API int mlink_ao_scan_init(int *link_fd, uint8_t *ch, uint8_t ch_count, float *data, int data_size, double *range, uint8_t stream_mode, float rate, float duration);
EXTERNC MDAQ_API int mlink_ao_scan(int *link_fd);
EXTERNC MDAQ_API int mlink_ao_scan_stop(int *link_fd);
EXTERNC MDAQ_API int mlink_ao_scan_data(int *link_fd, uint8_t *ch, int ch_count, float *data, int data_size, uint8_t opt);
EXTERNC MDAQ_API int mlink_ao_check_params(int *link_fd, uint8_t *ch, uint8_t ch_count, double *range);

/* PRU and MEM functions */
EXTERNC MDAQ_API int mlink_get_obj_size( int *link_fd, char *var_name, uint32_t *size );
EXTERNC MDAQ_API int mlink_get_obj( int *link_fd, char *obj_name, void *data, uint32_t size );
EXTERNC MDAQ_API int mlink_set_obj( int *link_fd, char *obj_name, void *data, uint32_t size );
EXTERNC MDAQ_API int mlink_mem_open( int *link_fd, uint32_t addr, uint32_t len );
EXTERNC MDAQ_API int mlink_mem_close( int *link_fd, uint32_t addr, uint32_t len );
EXTERNC MDAQ_API int mlink_mem_set( int *link_fd, uint32_t addr, int8_t *data, uint32_t len );
EXTERNC MDAQ_API int mlink_mem_get( int *link_fd, uint32_t addr, int8_t *data, uint32_t len );

#endif /* _MLINK_H_ */ 
