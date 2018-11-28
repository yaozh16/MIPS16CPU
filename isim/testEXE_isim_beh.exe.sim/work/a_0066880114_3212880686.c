/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/EXE.vhd";
extern char *WORK_P_2332286434;
extern char *IEEE_P_3620187407;
extern char *IEEE_P_2592010699;

char *ieee_p_2592010699_sub_12303121079769504865_503743352(char *, char *, char *, char *, unsigned char );
char *ieee_p_2592010699_sub_16439767405979520975_503743352(char *, char *, char *, char *, char *, char *);
char *ieee_p_2592010699_sub_16439989832805790689_503743352(char *, char *, char *, char *, char *, char *);
char *ieee_p_2592010699_sub_16439989833707593767_503743352(char *, char *, char *, char *, char *, char *);
char *ieee_p_2592010699_sub_207919886985903570_503743352(char *, char *, char *, char *);
char *ieee_p_2592010699_sub_24166140421859237_503743352(char *, char *, char *, char *);
unsigned char ieee_p_2592010699_sub_3488768496604610246_503743352(char *, unsigned char , unsigned char );
unsigned char ieee_p_2592010699_sub_374109322130769762_503743352(char *, unsigned char );
unsigned char ieee_p_3620187407_sub_1366267000076357978_3965413181(char *, char *, char *, char *, char *);
char *ieee_p_3620187407_sub_1496620905533649268_3965413181(char *, char *, char *, char *, char *, char *);
char *ieee_p_3620187407_sub_1496620905533721142_3965413181(char *, char *, char *, char *, char *, char *);
int ieee_p_3620187407_sub_5109402382352621412_3965413181(char *, char *, char *);


static void work_a_0066880114_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(57, ng0);

LAB3:    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t1 = (t0 + 4976);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 4U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 4848);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_0066880114_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    char *t5;
    char *t6;
    int t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(62, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t1 = (t0 + 8236);
    t4 = xsi_mem_cmp(t1, t2, 2U);
    if (t4 == 1)
        goto LAB3;

LAB6:    t5 = (t0 + 8238);
    t7 = xsi_mem_cmp(t5, t2, 2U);
    if (t7 == 1)
        goto LAB4;

LAB7:
LAB5:    xsi_set_current_line(65, ng0);
    t1 = ((WORK_P_2332286434) + 1168U);
    t2 = *((char **)t1);
    t1 = (t0 + 5040);
    t3 = (t1 + 56U);
    t5 = *((char **)t3);
    t6 = (t5 + 56U);
    t8 = *((char **)t6);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t1);

LAB2:    t1 = (t0 + 4864);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(63, ng0);
    t8 = (t0 + 1512U);
    t9 = *((char **)t8);
    t8 = (t0 + 5040);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t9, 16U);
    xsi_driver_first_trans_fast(t8);
    goto LAB2;

LAB4:    xsi_set_current_line(64, ng0);
    t1 = ((WORK_P_2332286434) + 1168U);
    t2 = *((char **)t1);
    t1 = (t0 + 5040);
    t3 = (t1 + 56U);
    t5 = *((char **)t3);
    t6 = (t5 + 56U);
    t8 = *((char **)t6);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB8:;
}

static void work_a_0066880114_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    char *t5;
    char *t6;
    int t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(70, ng0);
    t1 = (t0 + 1352U);
    t2 = *((char **)t1);
    t1 = (t0 + 8240);
    t4 = xsi_mem_cmp(t1, t2, 2U);
    if (t4 == 1)
        goto LAB3;

LAB6:    t5 = (t0 + 8242);
    t7 = xsi_mem_cmp(t5, t2, 2U);
    if (t7 == 1)
        goto LAB4;

LAB7:
LAB5:    xsi_set_current_line(73, ng0);
    t1 = ((WORK_P_2332286434) + 1168U);
    t2 = *((char **)t1);
    t1 = (t0 + 5104);
    t3 = (t1 + 56U);
    t5 = *((char **)t3);
    t6 = (t5 + 56U);
    t8 = *((char **)t6);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t1);

LAB2:    t1 = (t0 + 4880);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(71, ng0);
    t8 = (t0 + 1672U);
    t9 = *((char **)t8);
    t8 = (t0 + 5104);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t9, 16U);
    xsi_driver_first_trans_fast(t8);
    goto LAB2;

LAB4:    xsi_set_current_line(72, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t1 = (t0 + 5104);
    t3 = (t1 + 56U);
    t5 = *((char **)t3);
    t6 = (t5 + 56U);
    t8 = *((char **)t6);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB8:;
}

static void work_a_0066880114_3212880686_p_3(char *t0)
{
    char t27[16];
    char t41[16];
    char *t1;
    char *t2;
    char *t3;
    int t4;
    char *t5;
    int t6;
    char *t7;
    int t8;
    char *t9;
    int t10;
    char *t11;
    int t12;
    char *t13;
    int t14;
    char *t15;
    int t16;
    char *t17;
    int t18;
    char *t19;
    int t20;
    char *t21;
    int t22;
    char *t23;
    int t24;
    char *t25;
    int t26;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    unsigned int t33;
    unsigned int t34;
    unsigned char t35;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    char *t40;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned char t46;
    unsigned char t47;
    unsigned char t48;
    unsigned int t49;
    unsigned char t50;

LAB0:    xsi_set_current_line(79, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t1 = ((WORK_P_2332286434) + 7888U);
    t3 = *((char **)t1);
    t4 = xsi_mem_cmp(t3, t2, 4U);
    if (t4 == 1)
        goto LAB3;

LAB16:    t1 = ((WORK_P_2332286434) + 8008U);
    t5 = *((char **)t1);
    t6 = xsi_mem_cmp(t5, t2, 4U);
    if (t6 == 1)
        goto LAB4;

LAB17:    t1 = ((WORK_P_2332286434) + 8128U);
    t7 = *((char **)t1);
    t8 = xsi_mem_cmp(t7, t2, 4U);
    if (t8 == 1)
        goto LAB5;

LAB18:    t1 = ((WORK_P_2332286434) + 8248U);
    t9 = *((char **)t1);
    t10 = xsi_mem_cmp(t9, t2, 4U);
    if (t10 == 1)
        goto LAB6;

LAB19:    t1 = ((WORK_P_2332286434) + 8368U);
    t11 = *((char **)t1);
    t12 = xsi_mem_cmp(t11, t2, 4U);
    if (t12 == 1)
        goto LAB7;

LAB20:    t1 = ((WORK_P_2332286434) + 8488U);
    t13 = *((char **)t1);
    t14 = xsi_mem_cmp(t13, t2, 4U);
    if (t14 == 1)
        goto LAB8;

LAB21:    t1 = ((WORK_P_2332286434) + 8608U);
    t15 = *((char **)t1);
    t16 = xsi_mem_cmp(t15, t2, 4U);
    if (t16 == 1)
        goto LAB9;

LAB22:    t1 = ((WORK_P_2332286434) + 8728U);
    t17 = *((char **)t1);
    t18 = xsi_mem_cmp(t17, t2, 4U);
    if (t18 == 1)
        goto LAB10;

LAB23:    t1 = ((WORK_P_2332286434) + 8848U);
    t19 = *((char **)t1);
    t20 = xsi_mem_cmp(t19, t2, 4U);
    if (t20 == 1)
        goto LAB11;

LAB24:    t1 = ((WORK_P_2332286434) + 9088U);
    t21 = *((char **)t1);
    t22 = xsi_mem_cmp(t21, t2, 4U);
    if (t22 == 1)
        goto LAB12;

LAB25:    t1 = ((WORK_P_2332286434) + 8968U);
    t23 = *((char **)t1);
    t24 = xsi_mem_cmp(t23, t2, 4U);
    if (t24 == 1)
        goto LAB13;

LAB26:    t1 = ((WORK_P_2332286434) + 9208U);
    t25 = *((char **)t1);
    t26 = xsi_mem_cmp(t25, t2, 4U);
    if (t26 == 1)
        goto LAB14;

LAB27:
LAB15:    xsi_set_current_line(108, ng0);
    t1 = ((WORK_P_2332286434) + 1168U);
    t2 = *((char **)t1);
    t1 = (t0 + 5168);
    t3 = (t1 + 56U);
    t5 = *((char **)t3);
    t7 = (t5 + 56U);
    t9 = *((char **)t7);
    memcpy(t9, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t1 = (t0 + 4896);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(80, ng0);
    t1 = (t0 + 2472U);
    t28 = *((char **)t1);
    t1 = (t0 + 8104U);
    t29 = (t0 + 2632U);
    t30 = *((char **)t29);
    t29 = (t0 + 8120U);
    t31 = ieee_p_3620187407_sub_1496620905533649268_3965413181(IEEE_P_3620187407, t27, t28, t1, t30, t29);
    t32 = (t27 + 12U);
    t33 = *((unsigned int *)t32);
    t34 = (1U * t33);
    t35 = (16U != t34);
    if (t35 == 1)
        goto LAB29;

LAB30:    t36 = (t0 + 5168);
    t37 = (t36 + 56U);
    t38 = *((char **)t37);
    t39 = (t38 + 56U);
    t40 = *((char **)t39);
    memcpy(t40, t31, 16U);
    xsi_driver_first_trans_fast_port(t36);
    goto LAB2;

LAB4:    xsi_set_current_line(81, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = (t0 + 2632U);
    t5 = *((char **)t3);
    t3 = (t0 + 8120U);
    t7 = ieee_p_3620187407_sub_1496620905533721142_3965413181(IEEE_P_3620187407, t27, t2, t1, t5, t3);
    t9 = (t27 + 12U);
    t33 = *((unsigned int *)t9);
    t34 = (1U * t33);
    t35 = (16U != t34);
    if (t35 == 1)
        goto LAB31;

LAB32:    t11 = (t0 + 5168);
    t13 = (t11 + 56U);
    t15 = *((char **)t13);
    t17 = (t15 + 56U);
    t19 = *((char **)t17);
    memcpy(t19, t7, 16U);
    xsi_driver_first_trans_fast_port(t11);
    goto LAB2;

LAB5:    xsi_set_current_line(82, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = (t0 + 2632U);
    t5 = *((char **)t3);
    t3 = (t0 + 8120U);
    t7 = ieee_p_2592010699_sub_16439989832805790689_503743352(IEEE_P_2592010699, t27, t2, t1, t5, t3);
    t9 = (t27 + 12U);
    t33 = *((unsigned int *)t9);
    t34 = (1U * t33);
    t35 = (16U != t34);
    if (t35 == 1)
        goto LAB33;

LAB34:    t11 = (t0 + 5168);
    t13 = (t11 + 56U);
    t15 = *((char **)t13);
    t17 = (t15 + 56U);
    t19 = *((char **)t17);
    memcpy(t19, t7, 16U);
    xsi_driver_first_trans_fast_port(t11);
    goto LAB2;

LAB6:    xsi_set_current_line(83, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = (t0 + 2632U);
    t5 = *((char **)t3);
    t3 = (t0 + 8120U);
    t7 = ieee_p_2592010699_sub_16439767405979520975_503743352(IEEE_P_2592010699, t27, t2, t1, t5, t3);
    t9 = (t27 + 12U);
    t33 = *((unsigned int *)t9);
    t34 = (1U * t33);
    t35 = (16U != t34);
    if (t35 == 1)
        goto LAB35;

LAB36:    t11 = (t0 + 5168);
    t13 = (t11 + 56U);
    t15 = *((char **)t13);
    t17 = (t15 + 56U);
    t19 = *((char **)t17);
    memcpy(t19, t7, 16U);
    xsi_driver_first_trans_fast_port(t11);
    goto LAB2;

LAB7:    xsi_set_current_line(84, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = (t0 + 2632U);
    t5 = *((char **)t3);
    t3 = (t0 + 8120U);
    t35 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t5, t3);
    if (t35 != 0)
        goto LAB37;

LAB39:    xsi_set_current_line(87, ng0);
    t1 = ((WORK_P_2332286434) + 1408U);
    t2 = *((char **)t1);
    t1 = (t0 + 5168);
    t3 = (t1 + 56U);
    t5 = *((char **)t3);
    t7 = (t5 + 56U);
    t9 = *((char **)t7);
    memcpy(t9, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);

LAB38:    goto LAB2;

LAB8:    xsi_set_current_line(89, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = ieee_p_2592010699_sub_207919886985903570_503743352(IEEE_P_2592010699, t27, t2, t1);
    t5 = (t27 + 12U);
    t33 = *((unsigned int *)t5);
    t34 = (1U * t33);
    t35 = (16U != t34);
    if (t35 == 1)
        goto LAB40;

LAB41:    t7 = (t0 + 5168);
    t9 = (t7 + 56U);
    t11 = *((char **)t9);
    t13 = (t11 + 56U);
    t15 = *((char **)t13);
    memcpy(t15, t3, 16U);
    xsi_driver_first_trans_fast_port(t7);
    goto LAB2;

LAB9:    xsi_set_current_line(90, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = ieee_p_2592010699_sub_12303121079769504865_503743352(IEEE_P_2592010699, t41, t2, t1, (unsigned char)0);
    t5 = (t41 + 12U);
    t33 = *((unsigned int *)t5);
    t33 = (t33 * 1U);
    t7 = (t0 + 2632U);
    t9 = *((char **)t7);
    t7 = (t0 + 8120U);
    t4 = ieee_p_3620187407_sub_5109402382352621412_3965413181(IEEE_P_3620187407, t9, t7);
    t11 = xsi_vhdl_bitvec_sll(t11, t3, t33, t4);
    t13 = ieee_p_2592010699_sub_24166140421859237_503743352(IEEE_P_2592010699, t27, t11, t41);
    t15 = (t27 + 12U);
    t34 = *((unsigned int *)t15);
    t34 = (t34 * 1U);
    t35 = (16U != t34);
    if (t35 == 1)
        goto LAB42;

LAB43:    t17 = (t0 + 5168);
    t19 = (t17 + 56U);
    t21 = *((char **)t19);
    t23 = (t21 + 56U);
    t25 = *((char **)t23);
    memcpy(t25, t13, 16U);
    xsi_driver_first_trans_fast_port(t17);
    goto LAB2;

LAB10:    xsi_set_current_line(91, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t4 = (15 - 15);
    t33 = (t4 * -1);
    t34 = (1U * t33);
    t42 = (0 + t34);
    t1 = (t2 + t42);
    t35 = *((unsigned char *)t1);
    t3 = (t0 + 2632U);
    t5 = *((char **)t3);
    t6 = (15 - 15);
    t43 = (t6 * -1);
    t44 = (1U * t43);
    t45 = (0 + t44);
    t3 = (t5 + t45);
    t46 = *((unsigned char *)t3);
    t47 = (t35 == t46);
    if (t47 != 0)
        goto LAB44;

LAB46:    xsi_set_current_line(98, ng0);
    t1 = ((WORK_P_2332286434) + 1288U);
    t2 = *((char **)t1);
    t1 = (t0 + 2472U);
    t3 = *((char **)t1);
    t4 = (15 - 15);
    t33 = (t4 * -1);
    t34 = (1U * t33);
    t42 = (0 + t34);
    t1 = (t3 + t42);
    t35 = *((unsigned char *)t1);
    t5 = (t0 + 2632U);
    t7 = *((char **)t5);
    t6 = (15 - 15);
    t43 = (t6 * -1);
    t44 = (1U * t43);
    t45 = (0 + t44);
    t5 = (t7 + t45);
    t46 = *((unsigned char *)t5);
    t47 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t46);
    t48 = ieee_p_2592010699_sub_3488768496604610246_503743352(IEEE_P_2592010699, t35, t47);
    t11 = ((IEEE_P_2592010699) + 4000);
    t13 = ((WORK_P_2332286434) + 17608U);
    t9 = xsi_base_array_concat(t9, t27, t11, (char)97, t2, t13, (char)99, t48, (char)101);
    t49 = (15U + 1U);
    t50 = (16U != t49);
    if (t50 == 1)
        goto LAB50;

LAB51:    t15 = (t0 + 5168);
    t17 = (t15 + 56U);
    t19 = *((char **)t17);
    t21 = (t19 + 56U);
    t23 = *((char **)t21);
    memcpy(t23, t9, 16U);
    xsi_driver_first_trans_fast_port(t15);

LAB45:    goto LAB2;

LAB11:    xsi_set_current_line(100, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = (t0 + 2632U);
    t5 = *((char **)t3);
    t3 = (t0 + 8120U);
    t35 = ieee_p_3620187407_sub_1366267000076357978_3965413181(IEEE_P_3620187407, t2, t1, t5, t3);
    if (t35 != 0)
        goto LAB52;

LAB54:    xsi_set_current_line(103, ng0);
    t1 = ((WORK_P_2332286434) + 1168U);
    t2 = *((char **)t1);
    t1 = (t0 + 5168);
    t3 = (t1 + 56U);
    t5 = *((char **)t3);
    t7 = (t5 + 56U);
    t9 = *((char **)t7);
    memcpy(t9, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);

LAB53:    goto LAB2;

LAB12:    xsi_set_current_line(105, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = ieee_p_2592010699_sub_12303121079769504865_503743352(IEEE_P_2592010699, t41, t2, t1, (unsigned char)0);
    t5 = (t41 + 12U);
    t33 = *((unsigned int *)t5);
    t33 = (t33 * 1U);
    t7 = (t0 + 2632U);
    t9 = *((char **)t7);
    t7 = (t0 + 8120U);
    t4 = ieee_p_3620187407_sub_5109402382352621412_3965413181(IEEE_P_3620187407, t9, t7);
    t11 = xsi_vhdl_bitvec_sra(t11, t3, t33, t4);
    t13 = ieee_p_2592010699_sub_24166140421859237_503743352(IEEE_P_2592010699, t27, t11, t41);
    t15 = (t27 + 12U);
    t34 = *((unsigned int *)t15);
    t34 = (t34 * 1U);
    t35 = (16U != t34);
    if (t35 == 1)
        goto LAB55;

LAB56:    t17 = (t0 + 5168);
    t19 = (t17 + 56U);
    t21 = *((char **)t19);
    t23 = (t21 + 56U);
    t25 = *((char **)t23);
    memcpy(t25, t13, 16U);
    xsi_driver_first_trans_fast_port(t17);
    goto LAB2;

LAB13:    xsi_set_current_line(106, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = ieee_p_2592010699_sub_12303121079769504865_503743352(IEEE_P_2592010699, t41, t2, t1, (unsigned char)0);
    t5 = (t41 + 12U);
    t33 = *((unsigned int *)t5);
    t33 = (t33 * 1U);
    t7 = (t0 + 2632U);
    t9 = *((char **)t7);
    t7 = (t0 + 8120U);
    t4 = ieee_p_3620187407_sub_5109402382352621412_3965413181(IEEE_P_3620187407, t9, t7);
    t11 = xsi_vhdl_bitvec_srl(t11, t3, t33, t4);
    t13 = ieee_p_2592010699_sub_24166140421859237_503743352(IEEE_P_2592010699, t27, t11, t41);
    t15 = (t27 + 12U);
    t34 = *((unsigned int *)t15);
    t34 = (t34 * 1U);
    t35 = (16U != t34);
    if (t35 == 1)
        goto LAB57;

LAB58:    t17 = (t0 + 5168);
    t19 = (t17 + 56U);
    t21 = *((char **)t19);
    t23 = (t21 + 56U);
    t25 = *((char **)t23);
    memcpy(t25, t13, 16U);
    xsi_driver_first_trans_fast_port(t17);
    goto LAB2;

LAB14:    xsi_set_current_line(107, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8104U);
    t3 = (t0 + 2632U);
    t5 = *((char **)t3);
    t3 = (t0 + 8120U);
    t7 = ieee_p_2592010699_sub_16439989833707593767_503743352(IEEE_P_2592010699, t27, t2, t1, t5, t3);
    t9 = (t27 + 12U);
    t33 = *((unsigned int *)t9);
    t34 = (1U * t33);
    t35 = (16U != t34);
    if (t35 == 1)
        goto LAB59;

LAB60:    t11 = (t0 + 5168);
    t13 = (t11 + 56U);
    t15 = *((char **)t13);
    t17 = (t15 + 56U);
    t19 = *((char **)t17);
    memcpy(t19, t7, 16U);
    xsi_driver_first_trans_fast_port(t11);
    goto LAB2;

LAB28:;
LAB29:    xsi_size_not_matching(16U, t34, 0);
    goto LAB30;

LAB31:    xsi_size_not_matching(16U, t34, 0);
    goto LAB32;

LAB33:    xsi_size_not_matching(16U, t34, 0);
    goto LAB34;

LAB35:    xsi_size_not_matching(16U, t34, 0);
    goto LAB36;

LAB37:    xsi_set_current_line(85, ng0);
    t7 = ((WORK_P_2332286434) + 1168U);
    t9 = *((char **)t7);
    t7 = (t0 + 5168);
    t11 = (t7 + 56U);
    t13 = *((char **)t11);
    t15 = (t13 + 56U);
    t17 = *((char **)t15);
    memcpy(t17, t9, 16U);
    xsi_driver_first_trans_fast_port(t7);
    goto LAB38;

LAB40:    xsi_size_not_matching(16U, t34, 0);
    goto LAB41;

LAB42:    xsi_size_not_matching(16U, t34, 0);
    goto LAB43;

LAB44:    xsi_set_current_line(92, ng0);
    t7 = (t0 + 2472U);
    t9 = *((char **)t7);
    t7 = (t0 + 8104U);
    t11 = (t0 + 2632U);
    t13 = *((char **)t11);
    t11 = (t0 + 8120U);
    t48 = ieee_p_3620187407_sub_1366267000076357978_3965413181(IEEE_P_3620187407, t9, t7, t13, t11);
    if (t48 != 0)
        goto LAB47;

LAB49:    xsi_set_current_line(95, ng0);
    t1 = ((WORK_P_2332286434) + 1168U);
    t2 = *((char **)t1);
    t1 = (t0 + 5168);
    t3 = (t1 + 56U);
    t5 = *((char **)t3);
    t7 = (t5 + 56U);
    t9 = *((char **)t7);
    memcpy(t9, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);

LAB48:    goto LAB45;

LAB47:    xsi_set_current_line(93, ng0);
    t15 = ((WORK_P_2332286434) + 1408U);
    t17 = *((char **)t15);
    t15 = (t0 + 5168);
    t19 = (t15 + 56U);
    t21 = *((char **)t19);
    t23 = (t21 + 56U);
    t25 = *((char **)t23);
    memcpy(t25, t17, 16U);
    xsi_driver_first_trans_fast_port(t15);
    goto LAB48;

LAB50:    xsi_size_not_matching(16U, t49, 0);
    goto LAB51;

LAB52:    xsi_set_current_line(101, ng0);
    t7 = ((WORK_P_2332286434) + 1408U);
    t9 = *((char **)t7);
    t7 = (t0 + 5168);
    t11 = (t7 + 56U);
    t13 = *((char **)t11);
    t15 = (t13 + 56U);
    t17 = *((char **)t15);
    memcpy(t17, t9, 16U);
    xsi_driver_first_trans_fast_port(t7);
    goto LAB53;

LAB55:    xsi_size_not_matching(16U, t34, 0);
    goto LAB56;

LAB57:    xsi_size_not_matching(16U, t34, 0);
    goto LAB58;

LAB59:    xsi_size_not_matching(16U, t34, 0);
    goto LAB60;

}


extern void work_a_0066880114_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0066880114_3212880686_p_0,(void *)work_a_0066880114_3212880686_p_1,(void *)work_a_0066880114_3212880686_p_2,(void *)work_a_0066880114_3212880686_p_3};
	xsi_register_didat("work_a_0066880114_3212880686", "isim/testEXE_isim_beh.exe.sim/work/a_0066880114_3212880686.didat");
	xsi_register_executes(pe);
}
