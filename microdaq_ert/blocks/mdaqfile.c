#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "mdaq_file.h"
#endif

/* TODO: In case of more than one ToFile block, SH_MALLOC_SIZE should be smaller */
#define SH_MALLOC_SIZE		(0x80000) //0.5 MB
#define MDAQ_MAX_FILE       (16)
#define WRITE_FREQ 			(10) 	  //Hz
#define FLOAT_TO_CHAR 	    (24)

typedef struct buff_data
{
	char *ptr;
	unsigned int idx;
	unsigned int byte_idx;
}file_buff_t;


typedef struct file_data
{
	file_buff_t buff0;
	file_buff_t buff1;
	unsigned int buff_max_idx;
	int file_fd;
	int double_buffering;
	int buff_in_use;
}file_data_t;

static file_data_t file_data[MDAQ_MAX_FILE];

extern void *sh_malloc(uint32_t size);
extern double get_model_tsamp(void);

void ToFileInit(char *file_name, unsigned char mode, unsigned long buf_len,
                 unsigned char ch, unsigned char type )
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
    static int first_time = 1;
    int max_buf_idx;
    int model_freq;
	int block_num = 0; 

    if (first_time )
    {
        int i;
        mdaq_file_init();
        memset((void *)file_data, 0x0, sizeof(file_data));

        /* try to close all file descriptors */
        for (i = 0; i < MDAQ_MAX_FILE; i++)
        {
            mdaq_file_close(file_data[i].file_fd);
            file_data[i].file_fd = -1;
        }

        first_time = 0;
    }

    file_data[block_num].file_fd = mdaq_file_open(
            file_name,
            O_CREAT | (mode == 1 ? O_TRUNC : O_APPEND) | O_WRONLY | O_NONBLOCK);

    //Allocate memory
	if(file_data[block_num].buff0.ptr == NULL)
		file_data[block_num].buff0.ptr = (char *)sh_malloc(SH_MALLOC_SIZE);

	if(file_data[block_num].buff0.ptr != NULL)
		memset((void *) file_data[block_num].buff0.ptr, 0x0, SH_MALLOC_SIZE);

	file_data[block_num].buff1.ptr = file_data[block_num].buff0.ptr + (SH_MALLOC_SIZE>>1);

    max_buf_idx = ((SH_MALLOC_SIZE / ch) / ((type==1 ? FLOAT_TO_CHAR : sizeof(double))) >> 1);
    model_freq = (int)(1.0 / get_model_tsamp());


    if( model_freq > WRITE_FREQ)
    {
    	file_data[block_num].buff_max_idx = (model_freq/WRITE_FREQ);
    	if (file_data[block_num].buff_max_idx >= max_buf_idx)
    		file_data[block_num].buff_max_idx = max_buf_idx;

    	file_data[block_num].double_buffering = 1;
    }
    else
    {
    	file_data[block_num].double_buffering = 0;
    }
#endif 
}

void ToFileStep(double *data, unsigned long buf_len, unsigned char ch, unsigned char type )
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
    int vector_idx = 0;
	int block_num = 0;
    file_buff_t *buff;

    buff = (file_data[block_num].buff_in_use ? &file_data[block_num].buff1 : &file_data[block_num].buff0);

	if (type == 1)
		{
			for(vector_idx = 0; vector_idx < ch - 1; vector_idx++)
				buff->byte_idx += sprintf(buff->ptr + buff->byte_idx, "%f,\t", data[vector_idx]);

			buff->byte_idx += sprintf(buff->ptr + buff->byte_idx, "%f\n", data[vector_idx]);
			buff->idx++;
		}
		else
		{
			memcpy((void *) (buff->ptr + buff->byte_idx), (void *) data, sizeof(double) * ch);
			buff->byte_idx += sizeof(double) * ch;
			buff->idx++;
	}


    if (file_data[block_num].double_buffering){
		if(buff->idx >= file_data[block_num].buff_max_idx )
		{
			mdaq_file_write(file_data[block_num].file_fd, buff->ptr, buff->byte_idx);
			buff->byte_idx = 0;
			buff->idx = 0;
			file_data[block_num].buff_in_use = !file_data[block_num].buff_in_use;
		}
    }else
    {
    	mdaq_file_write(file_data[block_num].file_fd, buff->ptr, buff->byte_idx);
    	buff->byte_idx = 0;
    	buff->idx = 0;
    }


#endif 
}

void ToFileTerminate(void)
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
	file_buff_t *buff;
	int block_num = 0;
	mdaq_file_flush2(file_data[block_num].file_fd);
	buff = (file_data[block_num].buff_in_use ? &file_data[block_num].buff1 : &file_data[block_num].buff0);

    /* write data remaining in buffer */
	if(buff->idx > 0)
		    mdaq_file_writeb(file_data[block_num].file_fd, buff->ptr, buff->byte_idx);

	buff->idx = 0;
	buff->byte_idx = 0;
	file_data[block_num].buff_in_use = 0;

    mdaq_file_close(file_data[block_num].file_fd);
    file_data[block_num].file_fd = -1;
#endif 
}

void FromFileInit(int block_num, char *file_name, unsigned char mode, unsigned long buf_len,
                   unsigned char ch, unsigned char type )
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
#endif 
}

void FromFileStep(int block_num, double *data, unsigned long buf_len, unsigned char ch,
                   unsigned char type )
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
#endif 
}

void FromFileTerminate(int block_num )
{
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT)
#endif 
}

