/*{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
/* FILENAME : HDRP_HexPacket.h                                               */
/*  PURPOSE :                                                                */
/*  UPDATED : 2004-DEC-25-SAT @20:21 Creation                                */
/* COPYRIGHT (C) Ronald Earl Madsen, Junior <ALL RIGHTS RESERVED>            */
/*****************************************************************************/
/*{VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/
/* FUNCTION PROTOTYPE DECLARATIONS */

//extern int ComposeRelayControlPacket(char* XmitBfr,
//                                     char* NewStates,
//                                     long int TheTargetAddress,
//                                     long int TheSrcAddress);

extern int CvtByteValToTwoDigitHexStr(char* OutStr,int TheByteVal);

extern char CvtFourDigitBinaryStrToHexChar(char *BinaryStr);

extern int CvtFourDigitBinaryStrToNmbr(char* BinaryStr);

//extern int CvtIntTo16BitBinaryStr(char* OutBfr,int TheNmbr);

extern int CvtIntToFourDigitHexStr(char* OutStr,int TheIntVal);

extern char CvtIntToHexDigit(int TheNumber);

/* END OF FUNCTION PROTOTYPE DECLARATIONS */
/*}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/