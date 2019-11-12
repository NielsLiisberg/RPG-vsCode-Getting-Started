**FREE
// ------------------------------------------------------------- 
// Program . . . : Test                                          
// Company . . . : System & Method A/S                           
// Design  . . . : Niels Liisberg                                
// Function  . . : put a message in the joblog                   
//
// Simple vanilla project to place a message in the joblog using rpg
//                                                               
// By     Date       Fix     Beskrivelse                         ?
// NLI    12.11.2019 0000000 New program                         
// ------------------------------------------------------------- 
   
ctl-opt copyright('Sitemule.com  (C), 2019');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt decEdit('0,') datEdit(*YMD.) ;
ctl-opt debug(*yes) bndDir('QC2LE');
ctl-opt main(main);

/include ./headers/Qp0zLprintf.rpgle

dcl-pr JOBLOG extpgm('JOBLOG');
   text varchar(2000);
end-pr;

// -----------------------------------------------------------------------------
// Program Entry Point
// -----------------------------------------------------------------------------     
dcl-proc main;

   dcl-pi *n;
      text varchar(2000);
   end-pi;


   // print input parameter to job log 
   Qp0zLprintf ( '%s\n' : text);

end-proc;

