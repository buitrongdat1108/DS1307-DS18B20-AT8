/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
? Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 20/07/2020
Author  : 
Company : 
Comments: 


Chip type               : ATmega8A
Program type            : Application
AVR Core Clock frequency: 7.372800 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>

// I2C Bus functions
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// 1 Wire Bus interface functions
#include <1wire.h>

// DS1820 Temperature Sensor functions
#include <ds1820.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here
#include <delay.h>
#include <stdio.h>
unsigned int temp;
unsigned int temp1,temp2,temp3,temp4;
unsigned char byte0,byte1,byte2,a;        //skip rom cho DS18B20
char str[8];                       //luu thong tin gio phut giay
char wd[3];                        //bien luu thu trong tuan     
unsigned char h,m,s;               //bien luu thong tin gio, phut, giay
unsigned char week_day,day,month,year;   //bien luu thong tin ngay,thang,nam
//khoi tao cho led 7 thanh
unsigned int led7seg_CC[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
unsigned int led7seg_CA[10]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0x8F,0x80,0x90};
unsigned int led7seg_CC_point[10]={ 0xBF, 0x86, 0xDB, 0xCF, 0xE6, 0xED, 0xFD, 0x87, 0xFF, 0xEF};
unsigned int led7seg_CA_point[10]={0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10};
unsigned char zerodegree_CA = 0x9C;
unsigned char zerodegree_CC = 0x63;
unsigned char degree_C_CA = 0x46;
unsigned char degree_C_CC = 0xB9; 
//khoi tao cho IC dich chot 74HC595
//#define 74HC595_PORT   PORTD
//#define 74HC595_DDR    DDRD
#define HC595_DS_POS PORTD.6         //Data pin (DS) pin location
#define HC595_SH_CP_POS PORTD.5      //Shift Clock (SH_CP) pin location 
#define HC595_ST_CP_POS PORTD.7      //Store Clock (ST_CP) pin location
unsigned char i,j,k,l,m;
void hienthithu(unsigned char x)                  //DS1307 chi hien thi thu trong tuan tu 1 den 7 nen can ham nay de thay the cac so thanh ten cac thu trong tuan
{
    switch(x)
        {
            case 1: lcd_putsf("Mon");
                break;
            case 2: lcd_putsf("Tue");
                break;
            case 3: lcd_putsf("Wed");
                break;
            case 4: lcd_putsf("Thu");
                break;
            case 5: lcd_putsf("Fri");
                break;
            case 6: lcd_putsf("Sar");
                break;
            case 7: lcd_putsf("Sun");
                break; 
            default:                            
        }        
    sprintf(wd,"%3c",x);
    //lcd_gotoxy(13,0);
    lcd_puts(wd);
}
void HC595_init()
{
  DDRD.5=1;
  DDRD.6=1;
  DDRD.7=1;
}

void HC595_clock()
{
PORTD.5=1;
delay_us(1);
PORTD.5=0;
delay_us(1);
}

void HC595_latch()
{
PORTD.7=1;
delay_us(1);
PORTD.7=0;
delay_us(1);
}

void nhap5sohienthi(unsigned int data1, unsigned int data2, unsigned int data3, unsigned int data4, unsigned int data5)
{
 
 
  for(i=0;i<8;i++)
  {
  
  if(data1&0x80)
  {
    PORTD.6=1;
    //74HC595_PORT&=(~(1<<74HC595_DS_POS));
  }         
  else
  {
    PORTD.6=0;
    //74HC595_PORT|=(1<<74HC595_DS_POS);
  }
  HC595_clock();
  data1=data1<<1;
  }
   
  
  for(j=0;j<8;j++)
  {
  
  if(data2&0x80)
  {
    PORTD.6=1;
    //74HC595_PORT&=(~(1<<74HC595_DS_POS));
  }         
  else
  {
    PORTD.6=0;
    //74HC595_PORT|=(1<<74HC595_DS_POS);
  }    
  HC595_clock();
  data2=data2<<1;
  }
  
  for(k=0;k<8;k++)
  {

  if(data3&0x80)
  {
    PORTD.6=1;
  }         
  else
  {
    PORTD.6=0;
  }
  HC595_clock();
  data3=data3<<1;
  }
  
  for(l=0;l<8;l++)
  {
  
  if(data4&0x80)
  {
    PORTD.6=1;
  }         
  else
  {
    PORTD.6=0;
  }
  HC595_clock();
  data4=data4<<1;
  }
  
  for(m=0;m<8;m++)
  {
  
  if(data5&0x80)
  {
    PORTD.6=1;
  }         
  else
  {
    PORTD.6=0;
  }
  HC595_clock();
  data5=data5<<1;
  }
  
  HC595_latch();
}
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTC
// I2C SDA bit: 4
// I2C SCL bit: 5
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: On
// Square wave frequency: 1Hz
rtc_init(0,1,0);

// 1 Wire Bus initialization
// 1 Wire Data port: PORTD
// 1 Wire Data bit: 3
// Note: 1 Wire port settings are specified in the
// Project|Configure|C Compiler|Libraries|1 Wire menu.
w1_init();

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 3
// D5 - PORTD Bit 0
// D6 - PORTD Bit 1
// D7 - PORTD Bit 2
// Characters/line: 16
lcd_init(16);
HC595_init();
rtc_set_time(10,10,10);
rtc_set_date(3,21,7,20);

while (1)
      {
      // Place your code here
         w1_init();
         w1_write(0xCC);      //skip ROM
         w1_write(0x44);      //Stack converse, bat dau chuyen doi nhiet do
         delay_ms(200);
         w1_init();
         w1_write(0xCC);
         w1_write(0xBE);      //read scratchpad
//giai thich: trong DS18B20 co 8 byte thanh ghi, 
//trong do chi co hai byte dau tien la doc nhiet do (byte0,byte1)         
         byte0=w1_read();
         byte1=w1_read(); 
         byte2=(byte0)&0b00001111;
         a = (byte2>>1);
         a |=byte2>>3; 
         temp=(((byte1)&0b00000111)<<5)|(((byte0)&0b11111000)>>3);
         temp1=(((byte1)&0b00000111)<<5)|(((byte0)&0b11111000)>>3);
         temp2 = temp*10;
         temp3 = temp1*10;
         temp4 = temp2 - temp3;
         //nhap5sohienthi(led7seg_CA[temp/10],led7seg_CA_point[temp%10],led7seg_CA[(temp*10)%10],zerodegree_CA,degree_C_CA);
         nhap5sohienthi(degree_C_CA,zerodegree_CA,led7seg_CA[(temp*10)%10],led7seg_CA_point[temp%10],led7seg_CA[temp/10]);         
         rtc_get_time(&h,&m,&s);
         rtc_get_date(&week_day,&day,&month,&year);
         sprintf(str,"%0.2d:%0.2d:%0.2d ",h,m,s);
         lcd_gotoxy(2,0);
         lcd_puts(str);
         
         lcd_gotoxy(0,1);
         hienthithu(week_day);
         lcd_putsf("/");
         lcd_putchar(day/10+0x30);
         lcd_putchar(day%10+0x30);
         lcd_putsf("/");
         lcd_putchar(month/10+0x30);
         lcd_putchar(month%10+0x30);
         lcd_putsf("/");
         lcd_putchar(2+0x30);
         lcd_putchar(0+0x30);
         lcd_putchar(year/10+0x30);
         lcd_putchar(year%10+0x30);
         
      }
}
