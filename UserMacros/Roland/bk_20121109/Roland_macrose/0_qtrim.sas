/*<pre><b>
/ Program   : qtrim.sas
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 23-Sep-2011
/ Purpose   : Function-style macro to trim the contents of a macro variable and
/             return the result MACRO QUOTED.
/ SubMacros : %verifyb %qcompress
/ Notes     : 
/ Usage     : %let macvar=%qtrim(&macvar);
/ 
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ string            (pos) String to trim
/===============================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description------------------------
/ rrb  29Mar07         Put out "macro called" message plus header tidy
/ rrb  31Jul07         Header tidy
/ rrb  04May11         Code tidy
/ rrb  23Sep11         Header tidy
/===============================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/=============================================================================*/

%put MACRO CALLED: qtrim v1.0;

%macro qtrim(string);
  %if %length(%qcompress(&string,%str( )))
    %then %qsubstr(&string,1,%verifyb(&string,%str( )));
%mend qtrim;
