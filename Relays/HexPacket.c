/*{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
/* FILENAME : CSRC_HexPacket.cpp                                             */
/* UPDATED : 2004-DEC-25-SAT @20:19 Creation                                 */
/*****************************************************************************/

#include <string.h>
#include <stdlib.h>

#include "HexPacket.h"

///*{VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/
///*  MODULE : CvtIntTo16BitBinaryStr                                          */
///*    TYPE : FUNCTION                                                        */
///* PURPOSE :                                                                 */
///* UPDATED : 2005-JAN-05-WED @19:00 Creation                                 */
///* COPYRIGHT (C) Ronald Earl Madsen, Junior <ALL RIGHTS RESERVED>            */
///*****************************************************************************/
//int CvtIntTo16BitBinaryStr
//(
//char* OutBfr,
//int TheNmbr
//)
//{
//int ln;
//
//itoa(TheNmbr,OutBfr,2);
//ln = strlen(OutBfr);
//if (ln < 16)
// {
//  strrev(OutBfr);
//  while (ln < 16)
//   {
//    OutBfr[ln] = '0';
//    ln++;
//   }
//  OutBfr[ln] = (char)0;
//  strrev(OutBfr);
// }
//
//return(16);
//
//} /* END OF MODULE CvtIntTo16BitBinaryStr */
///*}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

///*{VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/
///*  MODULE : ComposeRelayControlPacket                                       */
///*    TYPE : FUNCTION                                                        */
///* PURPOSE :                                                                 */
///*   NOTES : NewStates is a string of letters specifying the new states for  */
///*           the 16 relays on the target board. The letters are ordered from */
///*           relay #16 at the left down to relay #1 at the right end of the  */
///*           string.                                                         */
///* UPDATED : 2004-DEC-25-SAT @20:20 Creation                                 */
///* COPYRIGHT (C) Ronald Earl Madsen, Junior <ALL RIGHTS RESERVED>            */
///*****************************************************************************/
//int ComposeRelayControlPacket
//(
//char* XmitBfr,
//char* NewStates,
//long int TheTargetAddress,
//long int TheSrcAddress
//)
//{
//unsigned char ChkSum;            /* MODULO-256 CHECKSUM OF ALL PACKET BYTES, */
//                               /* EXCEPT THOSE USED TO TRANSMIT THE CHECKSUM */
//int cdx;
//int idx;
//char TheAndMaskStr[16];
//char TheOrMaskStr[16];
//
//if (XmitBfr == (char*)0)
// {
//  return(0);
// }
//
//if (NewStates == (char*)0)
// {
//  return(0);
// }
//
//if (strlen(NewStates) != 16)
// {
//  return(0);
// }
//
//for (idx = 0; idx <= 15; idx++)
// {
//  if (NewStates[idx] == 'X')    /* IF RELAY STATE IS TO BE LEFT UNCHANGED... */
//   {
//    TheOrMaskStr[idx] = '0';                            /* DO NOT TURN IT ON */
//    TheAndMaskStr[idx] = '1';                          /* DO NOT TURN IT OFF */
//   }
//
//  if (NewStates[idx] == 'M')  /* IF THE RELAY IS TO BE CLOSED MOMENTARILY... */
//   {
//    TheOrMaskStr[idx] = '1';                                  /* TURN IT ON, */
//    TheAndMaskStr[idx] = '0';                            /* THEN TURN IT OFF */
//                                 /* THE MICROCONTROLLER IMPLEMENTS THE DELAY */
//   }
//
//  if (NewStates[idx] == '1')              /* IF THE RELAY IS TO BE CLOSED... */
//   {
//    TheOrMaskStr[idx] = '1';                                   /* TURN IT ON */
//    TheAndMaskStr[idx] = '1';                          /* DO NOT TURN IT OFF */
//   }
//
//  if (NewStates[idx] == '0')              /* IF THE RELAY IS TO BE OPENED... */
//   {
//    TheOrMaskStr[idx] = '0';                            /* DO NOT TURN IT ON */
//    TheAndMaskStr[idx] = '0';                                 /* TURN IT OFF */
//   }
// }
//
//ChkSum = 'R' + 'P' + 'S' + '#' + 'T' + 'U' + '@' + '$';    /* INITIALIZE THE */
//                                /* CHECKSUM ACCUMULATOR BY ADDING ALL OF THE */
//                                       /* STATIC CHARACTERS (BYTES) TOGETHER */
//
//for (cdx = 4,idx = 0; cdx <= 7; cdx++,idx += 4)
// {
//  XmitBfr[cdx] = CvtFourDigitBinaryStrToHexChar(&TheAndMaskStr[idx]);
//  ChkSum += (unsigned char)XmitBfr[cdx];
// }
//
//for (cdx = 8,idx = 0; cdx <= 11; cdx++,idx += 4)
// {
//  XmitBfr[cdx] = CvtFourDigitBinaryStrToHexChar(&TheOrMaskStr[idx]);
//  ChkSum += (unsigned char)XmitBfr[cdx];
// }
//
//XmitBfr[12] = 'R';                             /* THE PACKET TYPE IDENTIFIER */
//ChkSum += (unsigned char)CvtIntToFourDigitHexStr(XmitBfr+13,TheSrcAddress);
//XmitBfr[17] = 'P';                /* THE SOURCE ADDRESS TERMINATION SEQUENCE */
//XmitBfr[18] = 'S';
//XmitBfr[19] = '#';
//ChkSum += (unsigned char)CvtIntToFourDigitHexStr(XmitBfr+20,TheTargetAddress);
//XmitBfr[24] = 'T';           /* THE TARGET UNIT ADDRESS TERMINATION SEQUENCE */
//XmitBfr[25] = 'U';
//XmitBfr[26] = '@';
//XmitBfr[27] = '$';                       /* THE PACKET TERMINATION CHARACTER */
//
//XmitBfr[28] = (char)0;                                  /* STRING TERMINATOR */
//
//CvtByteValToTwoDigitHexStr(XmitBfr,ChkSum); /* 2 HEX DIGITS FOR THE CHECKSUM */
//ChkSum = 255 - ChkSum;                        /* BITWISE INVERT THE CHECKSUM */
//CvtByteValToTwoDigitHexStr((XmitBfr+2),ChkSum);      /* 2 HEX DIGITS FOR THE */
//                                                        /* INVERTED CHECKSUM */
//
//return(28);             /* RETURN THE NUMBER OF BYTES IN THE COMPOSED PACKET */
//
//} /* END OF MODULE ComposeRelayControlPacket */
///*}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

/*{VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/
/*  MODULE : CvtByteValToTwoDigitHexStr                                      */
/*    TYPE : FUNCTION                                                        */
/* PURPOSE : Converts a single byte value into a string of two hex digits    */
/* WARNING : The output string is not terminated. This allows the output     */
/*           from this function to be placed into a buffer without           */
/*           over-writing adjacent buffer content with a termination         */
/*           character.                                                      */
/* RETURNS : The eight-bit (modulo-256) sum of the two hexadecimal digits    */
/* UPDATED : 2004-DEC-26-SUN @09:20 Creation                                 */
/* COPYRIGHT (C) Ronald Earl Madsen, Junior <ALL RIGHTS RESERVED>            */
/*****************************************************************************/
int CvtByteValToTwoDigitHexStr
(
char* OutStr,
int TheByteVal
)
{
int LS_Digit;
int MS_Digit;
int CkSm;

LS_Digit = TheByteVal & 0xF;
MS_Digit = (TheByteVal >> 4) & 0xF;

OutStr[0] = CvtIntToHexDigit(MS_Digit);
OutStr[1] = CvtIntToHexDigit(LS_Digit);

CkSm = *OutStr + *(OutStr+1);

CkSm &= 0xFF;

return(CkSm);

} /* END OF MODULE CvtByteValToTwoDigitHexStr */
/*}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

/*{VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/
/*  MODULE : CvtFourDigitBinaryStrToHexChar                                  */
/*    TYPE : FUNCTION                                                        */
/* PURPOSE : CONVERTS A FOUR-DIGIT STRING OF 1's AND 0's (BINARY) INTO AN    */
/*           EQUIVALENT SINGLE HEXADECIMAL DIGIT                             */
/* UPDATED : 2004-DEC-19-SUN @18:00 Creation                                 */
/* COPYRIGHT (C) Ronald Earl Madsen, Junior <ALL RIGHTS RESERVED>            */
/*****************************************************************************/
char CvtFourDigitBinaryStrToHexChar
(
char *BinaryStr
)
{
int TheNumber;
TheNumber = CvtFourDigitBinaryStrToNmbr(BinaryStr);

return (CvtIntToHexDigit(TheNumber));

} /* END OF MODULE CvtFourDigitBinaryStrToHexChar */
/*}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

/*{VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/
/*  MODULE : CvtFourDigitBinaryStrToNmbr                                     */
/*    TYPE : FUNCTION                                                        */
/* PURPOSE : CONVERTS A FOUR-DIGIT STRING OF 1's AND 0's (BINARY) INTO AN    */
/*           EQUIVALENT INTEGER VALUE                                        */
/* UPDATED : 2004-DEC-19-SUN @18:56 Creation                                 */
/* COPYRIGHT (C) Ronald Earl Madsen, Junior <ALL RIGHTS RESERVED>            */
/*****************************************************************************/
int CvtFourDigitBinaryStrToNmbr
(
char* BinaryStr
) 
{
int tdx;
int RetVal;
int MultFactor;

RetVal = 0;
MultFactor = 1;
for (tdx = 3; tdx >= 0; tdx--)
 {
  if (BinaryStr[tdx] == '1')
   {
    RetVal = RetVal + MultFactor;
   }
  MultFactor <<= 1;                                       /* MULTIPLY BY TWO */
 }

return(RetVal);                       /* RETURN THE DECIMAL EQUIVALENT VALUE */

} /* END OF MODULE CvtFourDigitBinaryStrToNmbr */
/*}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/


/*{VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/
/*  MODULE : CvtIntToFourDigitHexStr                                         */
/*    TYPE : FUNCTION                                                        */
/* PURPOSE : Converts an integer value into a string of four hexadecimal     */
/*           digits                                                          */
/* RETURNS : The eight-bit (modulo-256) sum of the four hexadecimal digits   */
/* UPDATED : 2004-DEC-26-SUN @10:24 Creation                                 */
/* COPYRIGHT (C) Ronald Earl Madsen, Junior <ALL RIGHTS RESERVED>            */
/*****************************************************************************/
int CvtIntToFourDigitHexStr
(
char* OutStr,
int TheIntVal
)
{
int LS_Byte;
int MS_Byte;
int CkSm;

LS_Byte = TheIntVal & 0xFF;
MS_Byte = (TheIntVal >> 8) & 0xFF;

CvtByteValToTwoDigitHexStr(OutStr,MS_Byte);
CvtByteValToTwoDigitHexStr((OutStr+2),LS_Byte);

CkSm = *OutStr + *(OutStr+1) + *(OutStr+2) + *(OutStr+3);

CkSm &= 0xFF;

return(CkSm);

} /* END OF MODULE CvtIntToFourDigitHexStr */
/*}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

/*{VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/
/*  MODULE : CvtIntToHexDigit                                                */
/*    TYPE : FUNCTION                                                        */
/* PURPOSE : Returns the hexadecimal digit that represents the value of      */
/*           TheNumber                                                       */
/* UPDATED : 2004-DEC-26-SUN @09:12 Creation                                 */
/* COPYRIGHT (C) Ronald Earl Madsen, Junior <ALL RIGHTS RESERVED>            */
/*****************************************************************************/
char CvtIntToHexDigit
(
int TheNumber
)
{
if ((TheNumber >= 0) && (TheNumber <= 9))
 {
  return (TheNumber + '0');
 }

if ((TheNumber >= 10) && (TheNumber <= 15)) 
 {
  return (TheNumber - 10 + 'A');
 }

return('0');

} /* END OF MODULE CvtIntToHexDigit */
/*}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

/* END OF MODULE CSRC_HexPacket.cpp */
/*}XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
