
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 7,372800 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _temp=R4
	.DEF _temp_msb=R5
	.DEF _temp1=R6
	.DEF _temp1_msb=R7
	.DEF _temp2=R8
	.DEF _temp2_msb=R9
	.DEF _temp3=R10
	.DEF _temp3_msb=R11
	.DEF _temp4=R12
	.DEF _temp4_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x3:
	.DB  0x3F,0x0,0x6,0x0,0x5B,0x0,0x4F,0x0
	.DB  0x66,0x0,0x6D,0x0,0x7D,0x0,0x7,0x0
	.DB  0x7F,0x0,0x6F
_0x4:
	.DB  0xC0,0x0,0xF9,0x0,0xA4,0x0,0xB0,0x0
	.DB  0x99,0x0,0x92,0x0,0x82,0x0,0x8F,0x0
	.DB  0x80,0x0,0x90
_0x5:
	.DB  0xBF,0x0,0x86,0x0,0xDB,0x0,0xCF,0x0
	.DB  0xE6,0x0,0xED,0x0,0xFD,0x0,0x87,0x0
	.DB  0xFF,0x0,0xEF
_0x6:
	.DB  0x40,0x0,0x79,0x0,0x24,0x0,0x30,0x0
	.DB  0x19,0x0,0x12,0x0,0x2,0x0,0x78,0x0
	.DB  0x0,0x0,0x10
_0x7:
	.DB  0x9C
_0x8:
	.DB  0x63
_0x9:
	.DB  0x46
_0xA:
	.DB  0xB9
_0x0:
	.DB  0x4D,0x6F,0x6E,0x0,0x54,0x75,0x65,0x0
	.DB  0x57,0x65,0x64,0x0,0x54,0x68,0x75,0x0
	.DB  0x46,0x72,0x69,0x0,0x53,0x61,0x72,0x0
	.DB  0x53,0x75,0x6E,0x0,0x25,0x33,0x63,0x0
	.DB  0x25,0x30,0x2E,0x32,0x64,0x3A,0x25,0x30
	.DB  0x2E,0x32,0x64,0x3A,0x25,0x30,0x2E,0x32
	.DB  0x64,0x20,0x0,0x2F,0x0
_0x2040003:
	.DB  0x80,0xC0
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2100060:
	.DB  0x1
_0x2100000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x13
	.DW  _led7seg_CA
	.DW  _0x4*2

	.DW  0x13
	.DW  _led7seg_CA_point
	.DW  _0x6*2

	.DW  0x01
	.DW  _zerodegree_CA
	.DW  _0x7*2

	.DW  0x01
	.DW  _degree_C_CA
	.DW  _0x9*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

	.DW  0x01
	.DW  __seed_G108
	.DW  _0x2100060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 20/07/2020
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 7.372800 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// I2C Bus functions
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// 1 Wire Bus interface functions
;#include <1wire.h>
;
;// DS1820 Temperature Sensor functions
;#include <ds1820.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;#include <delay.h>
;#include <stdio.h>
;unsigned int temp;
;unsigned int temp1,temp2,temp3,temp4;
;unsigned char byte0,byte1,byte2,a;        //skip rom cho DS18B20
;char str[8];                       //luu thong tin gio phut giay
;char wd[3];                        //bien luu thu trong tuan
;unsigned char h,m,s;               //bien luu thong tin gio, phut, giay
;unsigned char week_day,day,month,year;   //bien luu thong tin ngay,thang,nam
;//khoi tao cho led 7 thanh
;unsigned int led7seg_CC[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

	.DSEG
;unsigned int led7seg_CA[10]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0x8F,0x80,0x90};
;unsigned int led7seg_CC_point[10]={ 0xBF, 0x86, 0xDB, 0xCF, 0xE6, 0xED, 0xFD, 0x87, 0xFF, 0xEF};
;unsigned int led7seg_CA_point[10]={0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10};
;unsigned char zerodegree_CA = 0x9C;
;unsigned char zerodegree_CC = 0x63;
;unsigned char degree_C_CA = 0x46;
;unsigned char degree_C_CC = 0xB9;
;//khoi tao cho IC dich chot 74HC595
;//#define 74HC595_PORT   PORTD
;//#define 74HC595_DDR    DDRD
;#define HC595_DS_POS PORTD.6         //Data pin (DS) pin location
;#define HC595_SH_CP_POS PORTD.5      //Shift Clock (SH_CP) pin location
;#define HC595_ST_CP_POS PORTD.7      //Store Clock (ST_CP) pin location
;unsigned char i,j,k,l,m;
;void hienthithu(unsigned char x)                  //DS1307 chi hien thi thu trong tuan tu 1 den 7 nen can ham nay de tha ...
; 0000 0044 {

	.CSEG
_hienthithu:
; .FSTART _hienthithu
; 0000 0045     switch(x)
	ST   -Y,R26
;	x -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 0046         {
; 0000 0047             case 1: lcd_putsf("Mon");
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xE
	__POINTW2FN _0x0,0
	RCALL _lcd_putsf
; 0000 0048                 break;
	RJMP _0xD
; 0000 0049             case 2: lcd_putsf("Tue");
_0xE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xF
	__POINTW2FN _0x0,4
	RCALL _lcd_putsf
; 0000 004A                 break;
	RJMP _0xD
; 0000 004B             case 3: lcd_putsf("Wed");
_0xF:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x10
	__POINTW2FN _0x0,8
	RCALL _lcd_putsf
; 0000 004C                 break;
	RJMP _0xD
; 0000 004D             case 4: lcd_putsf("Thu");
_0x10:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x11
	__POINTW2FN _0x0,12
	RCALL _lcd_putsf
; 0000 004E                 break;
	RJMP _0xD
; 0000 004F             case 5: lcd_putsf("Fri");
_0x11:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x12
	__POINTW2FN _0x0,16
	RCALL _lcd_putsf
; 0000 0050                 break;
	RJMP _0xD
; 0000 0051             case 6: lcd_putsf("Sar");
_0x12:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x13
	__POINTW2FN _0x0,20
	RCALL _lcd_putsf
; 0000 0052                 break;
	RJMP _0xD
; 0000 0053             case 7: lcd_putsf("Sun");
_0x13:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x15
	__POINTW2FN _0x0,24
	RCALL _lcd_putsf
; 0000 0054                 break;
; 0000 0055             default:
_0x15:
; 0000 0056         }
_0xD:
; 0000 0057     sprintf(wd,"%3c",x);
	LDI  R30,LOW(_wd)
	LDI  R31,HIGH(_wd)
	RCALL SUBOPT_0x0
	__POINTW1FN _0x0,28
	RCALL SUBOPT_0x0
	LDD  R30,Y+4
	RCALL SUBOPT_0x1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 0058     //lcd_gotoxy(13,0);
; 0000 0059     lcd_puts(wd);
	LDI  R26,LOW(_wd)
	LDI  R27,HIGH(_wd)
	RCALL _lcd_puts
; 0000 005A }
	RJMP _0x2120006
; .FEND
;void HC595_init()
; 0000 005C {
_HC595_init:
; .FSTART _HC595_init
; 0000 005D   DDRD.5=1;
	SBI  0x11,5
; 0000 005E   DDRD.6=1;
	SBI  0x11,6
; 0000 005F   DDRD.7=1;
	SBI  0x11,7
; 0000 0060 }
	RET
; .FEND
;
;void HC595_clock()
; 0000 0063 {
_HC595_clock:
; .FSTART _HC595_clock
; 0000 0064 PORTD.5=1;
	SBI  0x12,5
; 0000 0065 delay_us(1);
	__DELAY_USB 2
; 0000 0066 PORTD.5=0;
	CBI  0x12,5
; 0000 0067 delay_us(1);
	RJMP _0x2120009
; 0000 0068 }
; .FEND
;
;void HC595_latch()
; 0000 006B {
_HC595_latch:
; .FSTART _HC595_latch
; 0000 006C PORTD.7=1;
	SBI  0x12,7
; 0000 006D delay_us(1);
	__DELAY_USB 2
; 0000 006E PORTD.7=0;
	CBI  0x12,7
; 0000 006F delay_us(1);
_0x2120009:
	__DELAY_USB 2
; 0000 0070 }
	RET
; .FEND
;
;void nhap5sohienthi(unsigned int data1, unsigned int data2, unsigned int data3, unsigned int data4, unsigned int data5)
; 0000 0073 {
_nhap5sohienthi:
; .FSTART _nhap5sohienthi
; 0000 0074 
; 0000 0075 
; 0000 0076   for(i=0;i<8;i++)
	RCALL SUBOPT_0x2
;	data1 -> Y+8
;	data2 -> Y+6
;	data3 -> Y+4
;	data4 -> Y+2
;	data5 -> Y+0
	LDI  R30,LOW(0)
	STS  _i,R30
_0x25:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x26
; 0000 0077   {
; 0000 0078 
; 0000 0079   if(data1&0x80)
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BREQ _0x27
; 0000 007A   {
; 0000 007B     PORTD.6=1;
	SBI  0x12,6
; 0000 007C     //74HC595_PORT&=(~(1<<74HC595_DS_POS));
; 0000 007D   }
; 0000 007E   else
	RJMP _0x2A
_0x27:
; 0000 007F   {
; 0000 0080     PORTD.6=0;
	CBI  0x12,6
; 0000 0081     //74HC595_PORT|=(1<<74HC595_DS_POS);
; 0000 0082   }
_0x2A:
; 0000 0083   HC595_clock();
	RCALL _HC595_clock
; 0000 0084   data1=data1<<1;
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 0085   }
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RJMP _0x25
_0x26:
; 0000 0086 
; 0000 0087 
; 0000 0088   for(j=0;j<8;j++)
	LDI  R30,LOW(0)
	STS  _j,R30
_0x2E:
	LDS  R26,_j
	CPI  R26,LOW(0x8)
	BRSH _0x2F
; 0000 0089   {
; 0000 008A 
; 0000 008B   if(data2&0x80)
	LDD  R30,Y+6
	ANDI R30,LOW(0x80)
	BREQ _0x30
; 0000 008C   {
; 0000 008D     PORTD.6=1;
	SBI  0x12,6
; 0000 008E     //74HC595_PORT&=(~(1<<74HC595_DS_POS));
; 0000 008F   }
; 0000 0090   else
	RJMP _0x33
_0x30:
; 0000 0091   {
; 0000 0092     PORTD.6=0;
	CBI  0x12,6
; 0000 0093     //74HC595_PORT|=(1<<74HC595_DS_POS);
; 0000 0094   }
_0x33:
; 0000 0095   HC595_clock();
	RCALL _HC595_clock
; 0000 0096   data2=data2<<1;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x4
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0097   }
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RJMP _0x2E
_0x2F:
; 0000 0098 
; 0000 0099   for(k=0;k<8;k++)
	LDI  R30,LOW(0)
	STS  _k,R30
_0x37:
	LDS  R26,_k
	CPI  R26,LOW(0x8)
	BRSH _0x38
; 0000 009A   {
; 0000 009B 
; 0000 009C   if(data3&0x80)
	LDD  R30,Y+4
	ANDI R30,LOW(0x80)
	BREQ _0x39
; 0000 009D   {
; 0000 009E     PORTD.6=1;
	SBI  0x12,6
; 0000 009F   }
; 0000 00A0   else
	RJMP _0x3C
_0x39:
; 0000 00A1   {
; 0000 00A2     PORTD.6=0;
	CBI  0x12,6
; 0000 00A3   }
_0x3C:
; 0000 00A4   HC595_clock();
	RCALL _HC595_clock
; 0000 00A5   data3=data3<<1;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0x4
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00A6   }
	LDS  R30,_k
	SUBI R30,-LOW(1)
	STS  _k,R30
	RJMP _0x37
_0x38:
; 0000 00A7 
; 0000 00A8   for(l=0;l<8;l++)
	LDI  R30,LOW(0)
	STS  _l,R30
_0x40:
	LDS  R26,_l
	CPI  R26,LOW(0x8)
	BRSH _0x41
; 0000 00A9   {
; 0000 00AA 
; 0000 00AB   if(data4&0x80)
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	BREQ _0x42
; 0000 00AC   {
; 0000 00AD     PORTD.6=1;
	SBI  0x12,6
; 0000 00AE   }
; 0000 00AF   else
	RJMP _0x45
_0x42:
; 0000 00B0   {
; 0000 00B1     PORTD.6=0;
	CBI  0x12,6
; 0000 00B2   }
_0x45:
; 0000 00B3   HC595_clock();
	RCALL _HC595_clock
; 0000 00B4   data4=data4<<1;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RCALL SUBOPT_0x4
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00B5   }
	LDS  R30,_l
	SUBI R30,-LOW(1)
	STS  _l,R30
	RJMP _0x40
_0x41:
; 0000 00B6 
; 0000 00B7   for(m=0;m<8;m++)
	LDI  R30,LOW(0)
	STS  _m,R30
_0x49:
	LDS  R26,_m
	CPI  R26,LOW(0x8)
	BRSH _0x4A
; 0000 00B8   {
; 0000 00B9 
; 0000 00BA   if(data5&0x80)
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x4B
; 0000 00BB   {
; 0000 00BC     PORTD.6=1;
	SBI  0x12,6
; 0000 00BD   }
; 0000 00BE   else
	RJMP _0x4E
_0x4B:
; 0000 00BF   {
; 0000 00C0     PORTD.6=0;
	CBI  0x12,6
; 0000 00C1   }
_0x4E:
; 0000 00C2   HC595_clock();
	RCALL _HC595_clock
; 0000 00C3   data5=data5<<1;
	LD   R30,Y
	LDD  R31,Y+1
	RCALL SUBOPT_0x4
	ST   Y,R30
	STD  Y+1,R31
; 0000 00C4   }
	LDS  R30,_m
	SUBI R30,-LOW(1)
	STS  _m,R30
	RJMP _0x49
_0x4A:
; 0000 00C5 
; 0000 00C6   HC595_latch();
	RCALL _HC595_latch
; 0000 00C7 }
	ADIW R28,10
	RET
; .FEND
;void main(void)
; 0000 00C9 {
_main:
; .FSTART _main
; 0000 00CA // Declare your local variables here
; 0000 00CB 
; 0000 00CC // Input/Output Ports initialization
; 0000 00CD // Port B initialization
; 0000 00CE // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00CF DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 00D0 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D1 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 00D2 
; 0000 00D3 // Port C initialization
; 0000 00D4 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D5 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 00D6 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D7 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00D8 
; 0000 00D9 // Port D initialization
; 0000 00DA // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00DB DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(224)
	OUT  0x11,R30
; 0000 00DC // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00DD PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00DE 
; 0000 00DF // Timer/Counter 0 initialization
; 0000 00E0 // Clock source: System Clock
; 0000 00E1 // Clock value: Timer 0 Stopped
; 0000 00E2 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00E3 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00E4 
; 0000 00E5 // Timer/Counter 1 initialization
; 0000 00E6 // Clock source: System Clock
; 0000 00E7 // Clock value: Timer1 Stopped
; 0000 00E8 // Mode: Normal top=0xFFFF
; 0000 00E9 // OC1A output: Disconnected
; 0000 00EA // OC1B output: Disconnected
; 0000 00EB // Noise Canceler: Off
; 0000 00EC // Input Capture on Falling Edge
; 0000 00ED // Timer1 Overflow Interrupt: Off
; 0000 00EE // Input Capture Interrupt: Off
; 0000 00EF // Compare A Match Interrupt: Off
; 0000 00F0 // Compare B Match Interrupt: Off
; 0000 00F1 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00F2 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00F3 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00F4 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00F5 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00F6 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F7 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F8 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F9 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00FA OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00FB 
; 0000 00FC // Timer/Counter 2 initialization
; 0000 00FD // Clock source: System Clock
; 0000 00FE // Clock value: Timer2 Stopped
; 0000 00FF // Mode: Normal top=0xFF
; 0000 0100 // OC2 output: Disconnected
; 0000 0101 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0102 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0103 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0104 OCR2=0x00;
	OUT  0x23,R30
; 0000 0105 
; 0000 0106 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0107 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0108 
; 0000 0109 // External Interrupt(s) initialization
; 0000 010A // INT0: Off
; 0000 010B // INT1: Off
; 0000 010C MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 010D 
; 0000 010E // USART initialization
; 0000 010F // USART disabled
; 0000 0110 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0111 
; 0000 0112 // Analog Comparator initialization
; 0000 0113 // Analog Comparator: Off
; 0000 0114 // The Analog Comparator's positive input is
; 0000 0115 // connected to the AIN0 pin
; 0000 0116 // The Analog Comparator's negative input is
; 0000 0117 // connected to the AIN1 pin
; 0000 0118 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0119 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 011A 
; 0000 011B // ADC initialization
; 0000 011C // ADC disabled
; 0000 011D ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 011E 
; 0000 011F // SPI initialization
; 0000 0120 // SPI disabled
; 0000 0121 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0122 
; 0000 0123 // TWI initialization
; 0000 0124 // TWI disabled
; 0000 0125 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0126 
; 0000 0127 // Bit-Banged I2C Bus initialization
; 0000 0128 // I2C Port: PORTC
; 0000 0129 // I2C SDA bit: 4
; 0000 012A // I2C SCL bit: 5
; 0000 012B // Bit Rate: 100 kHz
; 0000 012C // Note: I2C settings are specified in the
; 0000 012D // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 012E i2c_init();
	RCALL _i2c_init
; 0000 012F 
; 0000 0130 // DS1307 Real Time Clock initialization
; 0000 0131 // Square wave output on pin SQW/OUT: On
; 0000 0132 // Square wave frequency: 1Hz
; 0000 0133 rtc_init(0,1,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 0134 
; 0000 0135 // 1 Wire Bus initialization
; 0000 0136 // 1 Wire Data port: PORTD
; 0000 0137 // 1 Wire Data bit: 3
; 0000 0138 // Note: 1 Wire port settings are specified in the
; 0000 0139 // Project|Configure|C Compiler|Libraries|1 Wire menu.
; 0000 013A w1_init();
	RCALL _w1_init
; 0000 013B 
; 0000 013C // Alphanumeric LCD initialization
; 0000 013D // Connections are specified in the
; 0000 013E // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 013F // RS - PORTC Bit 0
; 0000 0140 // RD - PORTC Bit 1
; 0000 0141 // EN - PORTC Bit 2
; 0000 0142 // D4 - PORTC Bit 3
; 0000 0143 // D5 - PORTD Bit 0
; 0000 0144 // D6 - PORTD Bit 1
; 0000 0145 // D7 - PORTD Bit 2
; 0000 0146 // Characters/line: 16
; 0000 0147 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0148 HC595_init();
	RCALL _HC595_init
; 0000 0149 rtc_set_time(10,10,10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(10)
	RCALL _rtc_set_time
; 0000 014A rtc_set_date(3,21,7,20);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(20)
	RCALL _rtc_set_date
; 0000 014B 
; 0000 014C while (1)
_0x51:
; 0000 014D       {
; 0000 014E       // Place your code here
; 0000 014F          w1_init();
	RCALL _w1_init
; 0000 0150          w1_write(0xCC);      //skip ROM
	LDI  R26,LOW(204)
	RCALL _w1_write
; 0000 0151          w1_write(0x44);      //Stack converse, bat dau chuyen doi nhiet do
	LDI  R26,LOW(68)
	RCALL _w1_write
; 0000 0152          delay_ms(200);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x7
; 0000 0153          w1_init();
	RCALL _w1_init
; 0000 0154          w1_write(0xCC);
	LDI  R26,LOW(204)
	RCALL _w1_write
; 0000 0155          w1_write(0xBE);      //read scratchpad
	LDI  R26,LOW(190)
	RCALL _w1_write
; 0000 0156 //giai thich: trong DS18B20 co 8 byte thanh ghi,
; 0000 0157 //trong do chi co hai byte dau tien la doc nhiet do (byte0,byte1)
; 0000 0158          byte0=w1_read();
	RCALL _w1_read
	STS  _byte0,R30
; 0000 0159          byte1=w1_read();
	RCALL _w1_read
	STS  _byte1,R30
; 0000 015A          byte2=(byte0)&0b00001111;
	LDS  R30,_byte0
	ANDI R30,LOW(0xF)
	STS  _byte2,R30
; 0000 015B          a = (byte2>>1);
	LSR  R30
	STS  _a,R30
; 0000 015C          a |=byte2>>3;
	LDS  R30,_byte2
	LSR  R30
	LSR  R30
	LSR  R30
	LDS  R26,_a
	OR   R30,R26
	STS  _a,R30
; 0000 015D          temp=(((byte1)&0b00000111)<<5)|(((byte0)&0b11111000)>>3);
	RCALL SUBOPT_0x8
	MOVW R4,R30
; 0000 015E          temp1=(((byte1)&0b00000111)<<5)|(((byte0)&0b11111000)>>3);
	RCALL SUBOPT_0x8
	MOVW R6,R30
; 0000 015F          temp2 = temp*10;
	RCALL SUBOPT_0x9
	MOVW R8,R30
; 0000 0160          temp3 = temp1*10;
	MOVW R30,R6
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	MOVW R10,R30
; 0000 0161          temp4 = temp2 - temp3;
	MOVW R30,R8
	SUB  R30,R10
	SBC  R31,R11
	MOVW R12,R30
; 0000 0162          //nhap5sohienthi(led7seg_CA[temp/10],led7seg_CA_point[temp%10],led7seg_CA[(temp*10)%10],zerodegree_CA,degree_C_ ...
; 0000 0163          nhap5sohienthi(degree_C_CA,zerodegree_CA,led7seg_CA[(temp*10)%10],led7seg_CA_point[temp%10],led7seg_CA[temp/10] ...
	LDS  R30,_degree_C_CA
	LDI  R31,0
	RCALL SUBOPT_0x0
	LDS  R30,_zerodegree_CA
	LDI  R31,0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	RCALL __MODW21U
	LDI  R26,LOW(_led7seg_CA_point)
	LDI  R27,HIGH(_led7seg_CA_point)
	RCALL SUBOPT_0x4
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RCALL SUBOPT_0xB
	RCALL __DIVW21U
	RCALL SUBOPT_0xA
	MOVW R26,R30
	RCALL _nhap5sohienthi
; 0000 0164          rtc_get_time(&h,&m,&s);
	LDI  R30,LOW(_h)
	LDI  R31,HIGH(_h)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(_m)
	LDI  R31,HIGH(_m)
	RCALL SUBOPT_0x0
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	RCALL _rtc_get_time
; 0000 0165          rtc_get_date(&week_day,&day,&month,&year);
	LDI  R30,LOW(_week_day)
	LDI  R31,HIGH(_week_day)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(_day)
	LDI  R31,HIGH(_day)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(_month)
	LDI  R31,HIGH(_month)
	RCALL SUBOPT_0x0
	LDI  R26,LOW(_year)
	LDI  R27,HIGH(_year)
	RCALL _rtc_get_date
; 0000 0166          sprintf(str,"%0.2d:%0.2d:%0.2d ",h,m,s);
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	RCALL SUBOPT_0x0
	__POINTW1FN _0x0,32
	RCALL SUBOPT_0x0
	LDS  R30,_h
	RCALL SUBOPT_0x1
	LDS  R30,_m
	RCALL SUBOPT_0x1
	LDS  R30,_s
	RCALL SUBOPT_0x1
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
; 0000 0167          lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0168          lcd_puts(str);
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	RCALL _lcd_puts
; 0000 0169 
; 0000 016A          lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 016B          hienthithu(week_day);
	LDS  R26,_week_day
	RCALL _hienthithu
; 0000 016C          lcd_putsf("/");
	RCALL SUBOPT_0xC
; 0000 016D          lcd_putchar(day/10+0x30);
	LDS  R26,_day
	RCALL SUBOPT_0xD
; 0000 016E          lcd_putchar(day%10+0x30);
	LDS  R26,_day
	RCALL SUBOPT_0xE
; 0000 016F          lcd_putsf("/");
; 0000 0170          lcd_putchar(month/10+0x30);
	LDS  R26,_month
	RCALL SUBOPT_0xD
; 0000 0171          lcd_putchar(month%10+0x30);
	LDS  R26,_month
	RCALL SUBOPT_0xE
; 0000 0172          lcd_putsf("/");
; 0000 0173          lcd_putchar(2+0x30);
	LDI  R26,LOW(50)
	RCALL _lcd_putchar
; 0000 0174          lcd_putchar(0+0x30);
	LDI  R26,LOW(48)
	RCALL _lcd_putchar
; 0000 0175          lcd_putchar(year/10+0x30);
	LDS  R26,_year
	RCALL SUBOPT_0xD
; 0000 0176          lcd_putchar(year%10+0x30);
	LDS  R26,_year
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _lcd_putchar
; 0000 0177 
; 0000 0178       }
	RJMP _0x51
; 0000 0179 }
_0x54:
	RJMP _0x54
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	RCALL SUBOPT_0xF
	LDI  R26,LOW(7)
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL SUBOPT_0x10
	RJMP _0x2120008
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xF
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	RCALL SUBOPT_0xF
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x10
	RJMP _0x2120008
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xF
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x13
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	RCALL SUBOPT_0xF
	LDI  R26,LOW(3)
	RCALL _i2c_write
	LDD  R26,Y+3
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x10
	RJMP _0x2120003
; .FEND

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
; .FSTART __lcd_write_nibble_G102
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x15,3
	RJMP _0x2040005
_0x2040004:
	CBI  0x15,3
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x12,0
	RJMP _0x2040007
_0x2040006:
	CBI  0x12,0
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x12,1
	RJMP _0x2040009
_0x2040008:
	CBI  0x12,1
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x12,2
	RJMP _0x204000B
_0x204000A:
	CBI  0x12,2
_0x204000B:
	RCALL SUBOPT_0x19
	SBI  0x15,2
	RCALL SUBOPT_0x19
	CBI  0x15,2
	RCALL SUBOPT_0x19
	RJMP _0x2120006
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 123
	RJMP _0x2120006
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x7
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x7
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040010
_0x2040011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040013
	RJMP _0x2120006
_0x2040013:
_0x2040010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2120006
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL SUBOPT_0x2
	ST   -Y,R17
_0x2040014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	RJMP _0x2120007
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	RCALL SUBOPT_0x2
	ST   -Y,R17
_0x2040017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040017
_0x2040019:
_0x2120007:
	LDD  R17,Y+0
_0x2120008:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x14,3
	SBI  0x11,0
	SBI  0x11,1
	SBI  0x11,2
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1A
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 246
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2120006:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G103:
; .FSTART _put_buff_G103
	RCALL SUBOPT_0x2
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x1B
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	RCALL SUBOPT_0x1B
	ADIW R26,2
	RCALL SUBOPT_0x1D
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	RCALL SUBOPT_0x1B
	RCALL __GETW1P
	TST  R31
	BRMI _0x2060014
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
__ftoe_G103:
; .FSTART __ftoe_G103
	RCALL SUBOPT_0x1E
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2060019
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x0
	__POINTW2FN _0x2060000,0
	RCALL _strcpyf
	RJMP _0x2120005
_0x2060019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2060018
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x0
	__POINTW2FN _0x2060000,1
	RCALL _strcpyf
	RJMP _0x2120005
_0x2060018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x206001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x206001B:
	LDD  R17,Y+11
_0x206001C:
	RCALL SUBOPT_0x1F
	BREQ _0x206001E
	RCALL SUBOPT_0x20
	RJMP _0x206001C
_0x206001E:
	RCALL SUBOPT_0x21
	RCALL __CPD10
	BRNE _0x206001F
	LDI  R19,LOW(0)
	RCALL SUBOPT_0x20
	RJMP _0x2060020
_0x206001F:
	LDD  R19,Y+11
	RCALL SUBOPT_0x22
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2060021
	RCALL SUBOPT_0x20
_0x2060022:
	RCALL SUBOPT_0x22
	BRLO _0x2060024
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
	RJMP _0x2060022
_0x2060024:
	RJMP _0x2060025
_0x2060021:
_0x2060026:
	RCALL SUBOPT_0x22
	BRSH _0x2060028
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	SUBI R19,LOW(1)
	RJMP _0x2060026
_0x2060028:
	RCALL SUBOPT_0x20
_0x2060025:
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x22
	BRLO _0x2060029
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
_0x2060029:
_0x2060020:
	LDI  R17,LOW(0)
_0x206002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x206002C
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x27
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	__PUTD1S 4
	RCALL SUBOPT_0x23
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x28
	RCALL __MULF12
	RCALL SUBOPT_0x23
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x26
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x206002A
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x206002A
_0x206002C:
	RCALL SUBOPT_0x2C
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x206002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2060113
_0x206002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2060113:
	ST   X,R30
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	RCALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	RCALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2120005:
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G103:
; .FSTART __print_G103
	RCALL SUBOPT_0x2
	SBIW R28,63
	SBIW R28,17
	RCALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	RCALL SUBOPT_0x5
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0x18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	RCALL SUBOPT_0x1D
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2060036
	CPI  R18,37
	BRNE _0x2060037
	LDI  R17,LOW(1)
	RJMP _0x2060038
_0x2060037:
	RCALL SUBOPT_0x2E
_0x2060038:
	RJMP _0x2060035
_0x2060036:
	CPI  R30,LOW(0x1)
	BRNE _0x2060039
	CPI  R18,37
	BRNE _0x206003A
	RCALL SUBOPT_0x2E
	RJMP _0x2060114
_0x206003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x206003B
	LDI  R16,LOW(1)
	RJMP _0x2060035
_0x206003B:
	CPI  R18,43
	BRNE _0x206003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2060035
_0x206003C:
	CPI  R18,32
	BRNE _0x206003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2060035
_0x206003D:
	RJMP _0x206003E
_0x2060039:
	CPI  R30,LOW(0x2)
	BRNE _0x206003F
_0x206003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060040
	ORI  R16,LOW(128)
	RJMP _0x2060035
_0x2060040:
	RJMP _0x2060041
_0x206003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2060042
_0x2060041:
	CPI  R18,48
	BRLO _0x2060044
	CPI  R18,58
	BRLO _0x2060045
_0x2060044:
	RJMP _0x2060043
_0x2060045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2060035
_0x2060043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2060046
	LDI  R17,LOW(4)
	RJMP _0x2060035
_0x2060046:
	RJMP _0x2060047
_0x2060042:
	CPI  R30,LOW(0x4)
	BRNE _0x2060049
	CPI  R18,48
	BRLO _0x206004B
	CPI  R18,58
	BRLO _0x206004C
_0x206004B:
	RJMP _0x206004A
_0x206004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2060035
_0x206004A:
_0x2060047:
	CPI  R18,108
	BRNE _0x206004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2060035
_0x206004D:
	RJMP _0x206004E
_0x2060049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2060035
_0x206004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2060053
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x2F
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x31
	RJMP _0x2060054
_0x2060053:
	CPI  R30,LOW(0x45)
	BREQ _0x2060057
	CPI  R30,LOW(0x65)
	BRNE _0x2060058
_0x2060057:
	RJMP _0x2060059
_0x2060058:
	CPI  R30,LOW(0x66)
	BRNE _0x206005A
_0x2060059:
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	RCALL __GETD1P
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	LDD  R26,Y+13
	TST  R26
	BRMI _0x206005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x206005D
	CPI  R26,LOW(0x20)
	BREQ _0x206005F
	RJMP _0x2060060
_0x206005B:
	RCALL SUBOPT_0x36
	RCALL __ANEGF1
	RCALL SUBOPT_0x34
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x206005D:
	SBRS R16,7
	RJMP _0x2060061
	LDD  R30,Y+21
	ST   -Y,R30
	RCALL SUBOPT_0x31
	RJMP _0x2060062
_0x2060061:
_0x206005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	RCALL SUBOPT_0x37
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2060062:
_0x2060060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2060064
	RCALL SUBOPT_0x36
	RCALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	RCALL _ftoa
	RJMP _0x2060065
_0x2060064:
	RCALL SUBOPT_0x36
	RCALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G103
_0x2060065:
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x38
	RJMP _0x2060066
_0x206005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2060068
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	RJMP _0x2060069
_0x2060068:
	CPI  R30,LOW(0x70)
	BRNE _0x206006B
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x37
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x206006D
	CP   R20,R17
	BRLO _0x206006E
_0x206006D:
	RJMP _0x206006C
_0x206006E:
	MOV  R17,R20
_0x206006C:
_0x2060066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x206006F
_0x206006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2060072
	CPI  R30,LOW(0x69)
	BRNE _0x2060073
_0x2060072:
	ORI  R16,LOW(4)
	RJMP _0x2060074
_0x2060073:
	CPI  R30,LOW(0x75)
	BRNE _0x2060075
_0x2060074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2060076
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0x3A
	LDI  R17,LOW(10)
	RJMP _0x2060077
_0x2060076:
	__GETD1N 0x2710
	RCALL SUBOPT_0x3A
	LDI  R17,LOW(5)
	RJMP _0x2060077
_0x2060075:
	CPI  R30,LOW(0x58)
	BRNE _0x2060079
	ORI  R16,LOW(8)
	RJMP _0x206007A
_0x2060079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20600B8
_0x206007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x206007C
	__GETD1N 0x10000000
	RCALL SUBOPT_0x3A
	LDI  R17,LOW(8)
	RJMP _0x2060077
_0x206007C:
	__GETD1N 0x1000
	RCALL SUBOPT_0x3A
	LDI  R17,LOW(4)
_0x2060077:
	CPI  R20,0
	BREQ _0x206007D
	ANDI R16,LOW(127)
	RJMP _0x206007E
_0x206007D:
	LDI  R20,LOW(1)
_0x206007E:
	SBRS R16,1
	RJMP _0x206007F
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x33
	ADIW R26,4
	RCALL __GETD1P
	RJMP _0x2060115
_0x206007F:
	SBRS R16,2
	RJMP _0x2060081
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x39
	RCALL __CWD1
	RJMP _0x2060115
_0x2060081:
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x39
	CLR  R22
	CLR  R23
_0x2060115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2060083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2060084
	RCALL SUBOPT_0x36
	RCALL __ANEGD1
	RCALL SUBOPT_0x34
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2060084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2060085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2060086
_0x2060085:
	ANDI R16,LOW(251)
_0x2060086:
_0x2060083:
	MOV  R19,R20
_0x206006F:
	SBRC R16,0
	RJMP _0x2060087
_0x2060088:
	CP   R17,R21
	BRSH _0x206008B
	CP   R19,R21
	BRLO _0x206008C
_0x206008B:
	RJMP _0x206008A
_0x206008C:
	SBRS R16,7
	RJMP _0x206008D
	SBRS R16,2
	RJMP _0x206008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x206008F
_0x206008E:
	LDI  R18,LOW(48)
_0x206008F:
	RJMP _0x2060090
_0x206008D:
	LDI  R18,LOW(32)
_0x2060090:
	RCALL SUBOPT_0x2E
	SUBI R21,LOW(1)
	RJMP _0x2060088
_0x206008A:
_0x2060087:
_0x2060091:
	CP   R17,R20
	BRSH _0x2060093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2060094
	RCALL SUBOPT_0x3B
	BREQ _0x2060095
	SUBI R21,LOW(1)
_0x2060095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2060094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL SUBOPT_0x31
	CPI  R21,0
	BREQ _0x2060096
	SUBI R21,LOW(1)
_0x2060096:
	SUBI R20,LOW(1)
	RJMP _0x2060091
_0x2060093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2060097
_0x2060098:
	CPI  R19,0
	BREQ _0x206009A
	SBRS R16,3
	RJMP _0x206009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	RCALL SUBOPT_0x37
	RJMP _0x206009C
_0x206009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x206009C:
	RCALL SUBOPT_0x2E
	CPI  R21,0
	BREQ _0x206009D
	SUBI R21,LOW(1)
_0x206009D:
	SUBI R19,LOW(1)
	RJMP _0x2060098
_0x206009A:
	RJMP _0x206009E
_0x2060097:
_0x20600A0:
	RCALL SUBOPT_0x3C
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20600A2
	SBRS R16,3
	RJMP _0x20600A3
	SUBI R18,-LOW(55)
	RJMP _0x20600A4
_0x20600A3:
	SUBI R18,-LOW(87)
_0x20600A4:
	RJMP _0x20600A5
_0x20600A2:
	SUBI R18,-LOW(48)
_0x20600A5:
	SBRC R16,4
	RJMP _0x20600A7
	CPI  R18,49
	BRSH _0x20600A9
	RCALL SUBOPT_0x3D
	__CPD2N 0x1
	BRNE _0x20600A8
_0x20600A9:
	RJMP _0x20600AB
_0x20600A8:
	CP   R20,R19
	BRSH _0x2060116
	CP   R21,R19
	BRLO _0x20600AE
	SBRS R16,0
	RJMP _0x20600AF
_0x20600AE:
	RJMP _0x20600AD
_0x20600AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20600B0
_0x2060116:
	LDI  R18,LOW(48)
_0x20600AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20600B1
	RCALL SUBOPT_0x3B
	BREQ _0x20600B2
	SUBI R21,LOW(1)
_0x20600B2:
_0x20600B1:
_0x20600B0:
_0x20600A7:
	RCALL SUBOPT_0x2E
	CPI  R21,0
	BREQ _0x20600B3
	SUBI R21,LOW(1)
_0x20600B3:
_0x20600AD:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x3C
	RCALL __MODD21U
	RCALL SUBOPT_0x34
	LDD  R30,Y+20
	RCALL SUBOPT_0x3D
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	RCALL SUBOPT_0x3A
	__GETD1S 16
	RCALL __CPD10
	BREQ _0x20600A1
	RJMP _0x20600A0
_0x20600A1:
_0x206009E:
	SBRS R16,0
	RJMP _0x20600B4
_0x20600B5:
	CPI  R21,0
	BREQ _0x20600B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x31
	RJMP _0x20600B5
_0x20600B7:
_0x20600B4:
_0x20600B8:
_0x2060054:
_0x2060114:
	LDI  R17,LOW(0)
_0x2060035:
	RJMP _0x2060030
_0x2060032:
	RCALL SUBOPT_0x18
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x3E
	SBIW R30,0
	BRNE _0x20600B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120004
_0x20600B9:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x3E
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x0
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	RCALL SUBOPT_0x0
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	RCALL SUBOPT_0x18
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120004:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	RCALL SUBOPT_0x2
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x2
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x2
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x3F
	RJMP _0x2120003
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x3F
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x2120003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x1E
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x210000D
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x0
	__POINTW2FN _0x2100000,0
	RCALL _strcpyf
	RJMP _0x2120002
_0x210000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x210000C
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x0
	__POINTW2FN _0x2100000,1
	RCALL _strcpyf
	RJMP _0x2120002
_0x210000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x210000F
	RCALL SUBOPT_0x40
	RCALL __ANEGF1
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x42
	LDI  R30,LOW(45)
	ST   X,R30
_0x210000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2100010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2100010:
	LDD  R17,Y+8
_0x2100011:
	RCALL SUBOPT_0x1F
	BREQ _0x2100013
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x44
	RJMP _0x2100011
_0x2100013:
	RCALL SUBOPT_0x45
	RCALL __ADDF12
	RCALL SUBOPT_0x41
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x44
_0x2100014:
	RCALL SUBOPT_0x45
	RCALL __CMPF12
	BRLO _0x2100016
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x44
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2100017
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x0
	__POINTW2FN _0x2100000,5
	RCALL _strcpyf
	RJMP _0x2120002
_0x2100017:
	RJMP _0x2100014
_0x2100016:
	CPI  R17,0
	BRNE _0x2100018
	RCALL SUBOPT_0x42
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2100019
_0x2100018:
_0x210001A:
	RCALL SUBOPT_0x1F
	BREQ _0x210001C
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x27
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x45
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x2B
	LDI  R31,0
	RCALL SUBOPT_0x43
	RCALL __CWD1
	RCALL __CDF1
	RCALL __MULF12
	RCALL SUBOPT_0x46
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x41
	RJMP _0x210001A
_0x210001C:
_0x2100019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2120001
	RCALL SUBOPT_0x42
	LDI  R30,LOW(46)
	ST   X,R30
_0x210001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2100020
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x40
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x2B
	LDI  R31,0
	RCALL SUBOPT_0x46
	RCALL __CWD1
	RCALL __CDF1
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x41
	RJMP _0x210001E
_0x2100020:
_0x2120001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2120002:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
___ds1820_scratch_pad:
	.BYTE 0x9
_byte0:
	.BYTE 0x1
_byte1:
	.BYTE 0x1
_byte2:
	.BYTE 0x1
_a:
	.BYTE 0x1
_str:
	.BYTE 0x8
_wd:
	.BYTE 0x3
_h:
	.BYTE 0x1
_m:
	.BYTE 0x1
_s:
	.BYTE 0x1
_week_day:
	.BYTE 0x1
_day:
	.BYTE 0x1
_month:
	.BYTE 0x1
_year:
	.BYTE 0x1
_led7seg_CA:
	.BYTE 0x14
_led7seg_CA_point:
	.BYTE 0x14
_zerodegree_CA:
	.BYTE 0x1
_degree_C_CA:
	.BYTE 0x1
_i:
	.BYTE 0x1
_j:
	.BYTE 0x1
_k:
	.BYTE 0x1
_l:
	.BYTE 0x1
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G108:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x8:
	LDS  R30,_byte1
	LDI  R31,0
	ANDI R30,LOW(0x7)
	ANDI R31,HIGH(0x7)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOVW R26,R30
	LDS  R30,_byte0
	LDI  R31,0
	ANDI R30,LOW(0xF8)
	ANDI R31,HIGH(0xF8)
	RCALL __ASRW3
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	MOVW R30,R4
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_led7seg_CA)
	LDI  R27,HIGH(_led7seg_CA)
	RCALL SUBOPT_0x4
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x0
	MOVW R26,R4
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	__POINTW2FN _0x0,51
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xD:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _lcd_putchar
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	RCALL _i2c_write
	RJMP _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	RCALL _i2c_start
	LDI  R26,LOW(209)
	RCALL _i2c_write
	LDI  R26,LOW(1)
	RJMP _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	MOV  R26,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	ST   X,R30
	LDI  R26,LOW(1)
	RCALL _i2c_read
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RCALL _i2c_read
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	RCALL _i2c_write
	LD   R26,Y
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	RCALL _i2c_write
	LDD  R26,Y+1
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__DELAY_USB 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 246
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x2
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x20:
	__GETD2S 4
	__GETD1N 0x41200000
	RCALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x22:
	__GETD1S 4
	__GETD2S 12
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x23:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2B:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0x3
	ADIW R30,1
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2E:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2F:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x30:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x31:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x33:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0x2F
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x36:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x33
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3A:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x3B:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x41:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x18
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x43:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x44:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x45:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x46:
	__GETD2S 9
	RET


	.CSEG
	.equ __sda_bit=4
	.equ __scl_bit=5
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,12
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,25
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x733
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x12
	.equ __w1_bit=0x03

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x375
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x22
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xBB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x2CF
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1B
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xC5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x20
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xB8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xC
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
