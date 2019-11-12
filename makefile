
#-----------------------------------------------------------
# User-defined part start
#

# NOTE - UTF is not allowed for ILE source (yet) - so convert to WIN-1252

# BIN_LIB is the destination library for the demo programs.
# NOTE: LIBLIST can be overwritten from the commandline, but defaults to the BIN_LIB
BIN_LIB=VSCODE
LIBLIST=$(BIN_LIB)

DBGVIEW=*ALL
TARGET_CCSID=*JOB

# The shell we use
SHELL=/QOpenSys/usr/bin/qsh

# Do not touch below
INCLUDE='/QIBM/include' 'headers/' 

# C-compilers
CCFLAGS=OPTIMIZE(10) ENUM(*INT) TERASPACE(*YES) STGMDL(*INHERIT) SYSIFCOPT(*IFSIO) INCDIR($(INCLUDE)) DBGVIEW($(DBGVIEW)) TGTCCSID($(TARGET_CCSID))

# C- For current compile:
CCFLAGS2=OPTION(*STDLOGMSG) OUTPUT(*print) OPTIMIZE(10) ENUM(*INT) TERASPACE(*YES) STGMDL(*INHERIT) SYSIFCOPT(*IFSIO) DBGVIEW(*ALL) INCDIR($(INCLUDE)) 
CCFLAGSB=OPTION(*STDLOGMSG) OUTPUT(*print) OPTIMIZE(10) ENUM(*INT) TERASPACE(*YES) SYSIFCOPT(*IFSIO) DBGVIEW(*ALL) INCDIR($(INCLUDE)) 


# RPGLE 
RCFLAGS=OPTION(*NOUNREF) DBGVIEW(*LIST)   INCDIR('./..')
SQLRPGCFLAGS=OPTION(*NOUNREF) DBGVIEW(*LIST)   INCDIR(''./..'')
FILTER=| grep '*RNF' | grep -v '*RNF7031' | sed  "s!*!src/$*.rpgle: &!"
NOFILTER=>postlist.txt
#
# User-defined part end
#-----------------------------------------------------------

# Dependency list ---  list all

all:  $(BIN_LIB).lib joblog.cmd joblog.rpgle test.clle


#-----------------------------------------------------------

%.lib:
	-system -q "CRTLIB $* TYPE(*TEST)"

%.bnddir:
	-system -q "DLTBNDDIR BNDDIR($(BIN_LIB)/$*)"
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$*)"
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$*) OBJ($(patsubst %.entry,(*LIBL/% *SRVPGM *IMMED),$^))"

%.entry:
	# Basically do nothing..
	@echo "Adding binding entry $*"

%.c:
	system -q "CHGATR OBJ('src/$*.c') ATR(*CCSID) VALUE(1252)"
	system "CRTBNDC PGM($(BIN_LIB)/$(notdir $*)) SRCSTMF('src/$*.c') $(CCFLAGSB)"
#	system "CRTCMOD MODULE($(BIN_LIB)/$(notdir $*)) SRCSTMF('src/$*.c') $(CCFLAGS2)"

%.rpgle:
	touch postlist.txt ;\
	setccsid 1252 postlist.txt;\
	liblist -a $(LIBLIST);\
	setccsid 1252 src/$*.rpgle;\
	system -iK "CRTBNDRPG PGM($(BIN_LIB)/$(notdir $*)) SRCSTMF('src/$*.rpgle') $(RCFLAGS) TEXT('$(OBJECT_DESCRIPTION)')" $(FILTER) ;\
	
%.sqlrpgle:
	liblist -a $(LIBLIST);\
	setccsid 1252 src/$*.sqlrpgle;\
	system -iK "CRTSQLRPGI OBJ($(BIN_LIB)/$(notdir $*)) SRCSTMF('src/$*.sqlrpgle') RPGPPOPT(*LVL2) COMPILEOPT('$(SQLRPGCFLAGS)') DBGVIEW(*NONE) TEXT('$(OBJECT_DESCRIPTION)')"



%.pycmd:
	system -q "CHGATR OBJ('pycmd/$*.pycmd') ATR(*CCSID) VALUE(1252)"
	-system -q "CRTSRCPF FILE($(BIN_LIB)/QCMDSRC) RCDLEN(132)"
	system "CPYFRMSTMF FROMSTMF('pycmd/$*.pycmd') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QCMDSRC.file/$(notdir $*).mbr') MBROPT(*REPLACE)"
	system "CRTCMD prdlib($(BIN_LIB)) cmd($(BIN_LIB)/$(notdir $*)) PGM(runpy) SRCFILE($(BIN_LIB)/QCMDSRC)"
#	system "CRTCMOD MODULE($(BIN_LIB)/$(notdir $*)) SRCSTMF('src/$*.c') $(CCFLAGS2)"

%.dspf:
	system -q "CHGATR OBJ('src/$*.dspf') ATR(*CCSID) VALUE(1252)"
	-system -q "CRTSRCPF FILE($(BIN_LIB)/Qddssrc) RCDLEN(132)"
	system "CPYFRMSTMF FROMSTMF('src/$*.dspf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QDDSSRC.file/$(notdir $*).mbr') MBROPT(*REPLACE)"
	system "CRTDSPF file($(BIN_LIB)/$(notdir $*))  SRCFILE($(BIN_LIB)/QDDSSRC)"
#	system "CRTCMOD MODULE($(BIN_LIB)/$(notdir $*)) SRCSTMF('src/$*.c') $(CCFLAGS2)"

%.cmd:
	system -q "CHGATR OBJ('cmd/$*.cmd') ATR(*CCSID) VALUE(1252)"
	-system -q "CRTSRCPF FILE($(BIN_LIB)/QCMDSRC) RCDLEN(132)"
	system "CPYFRMSTMF FROMSTMF('cmd/$*.cmd') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QCMDSRC.file/$(notdir $*).mbr') MBROPT(*REPLACE)"
	system "CRTCMD prdlib($(BIN_LIB)) cmd($(BIN_LIB)/$(notdir $*)) PGM($(notdir $*))  SRCFILE($(BIN_LIB)/QCMDSRC)"

%.clle:
	-system -q "CRTSRCPF FILE($(BIN_LIB)/QCLLESRC) RCDLEN(112)"
	liblist -a $(LIBLIST);\
	setccsid 1252 src/$*.clle;\
	system "CPYFRMSTMF FROMSTMF('src/$*.clle') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QCLLESRC.file/$(notdir $*).mbr') MBROPT(*replace)";\
	system "CRTBNDCL PGM($(BIN_LIB)/$(notdir $*)) SRCFILE($(BIN_LIB)/QCLLESRC) DBGVIEW($(DBGVIEW))"

%.sql:
	system -q "CHGATR OBJ('sql/$*.sql') ATR(*CCSID) VALUE(1252)"
	system "RUNSQLSTM SRCSTMF('sql/$*.sql') COMMIT(*NONE) ERRLVL(30)"

%.srvpgm:
	-system -q "CRTSRCPF FILE($(BIN_LIB)/QSRVSRC) RCDLEN(132)"
	system "CPYFRMSTMF FROMSTMF('headers/$*.binder') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QSRVSRC.file/$*.mbr') MBROPT(*replace)"
	
	# You may be wondering what this ugly string is. It's a list of objects created from the dep list that end with .c or .clle.
	$(eval modules := $(patsubst %,$(BIN_LIB)/%,$(basename $(filter %.c %.clle,$(notdir $^)))))
	
	system -q -kpieb "CRTSRVPGM SRVPGM($(BIN_LIB)/$*) MODULE($(modules)) SRCFILE($(BIN_LIB)/QSRVSRC) ACTGRP(QILE) ALWLIBUPD(*YES) TGTRLS(*current)"

hdr:
	-system -q "CRTSRCPF FILE($(BIN_LIB)/QRPGLEREF) RCDLEN(132)"
	-system -q "CRTSRCPF FILE($(BIN_LIB)/QCREF) RCDLEN(132)"
  
	system "CPYFRMSTMF FROMSTMF('headers/jsonxml.h') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QCREF.file/JSONXML.mbr') MBROPT(*REPLACE)"

all:
	@echo Build success!

clean:
	-system -q "DLTOBJ OBJ($(BIN_LIB)/*ALL) OBJTYPE(*FILE)"
	-system -q "DLTOBJ OBJ($(BIN_LIB)/*ALL) OBJTYPE(*MODULE)"
	
release: clean
	@echo " -- Creating noxdb release. --"
	@echo " -- Creating save file. --"
	system "CRTSAVF FILE($(BIN_LIB)/RELEASE)"
	system "SAVLIB LIB($(BIN_LIB)) DEV(*SAVF) SAVF($(BIN_LIB)/RELEASE) OMITOBJ((RELEASE *FILE))"
	-rm -r release
	-mkdir release
	system "CPYTOSTMF FROMMBR('/QSYS.lib/$(BIN_LIB).lib/RELEASE.FILE') TOSTMF('./release/release.savf') STMFOPT(*REPLACE) STMFCCSID(1252) CVTDTA(*NONE)"
	@echo " -- Cleaning up... --"
	system "DLTOBJ OBJ($(BIN_LIB)/RELEASE) OBJTYPE(*FILE)"
	@echo " -- Release created! --"
	@echo ""
	@echo "To install the release, run:"
	@echo "  > CRTLIB $(BIN_LIB)"
	@echo "  > CPYFRMSTMF FROMSTMF('./release/release.savf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/RELEASE.FILE') MBROPT(*REPLACE) CVTDTA(*NONE)"
	@echo "  > RSTLIB SAVLIB($(BIN_LIB)) DEV(*SAVF) SAVF($(BIN_LIB)/RELEASE)"
	@echo ""

# For vsCode / single file then i.e.: gmake current sqlio.c  
current: 
	system -i "CRTCMOD MODULE($(BIN_LIB)/$(SRC)) SRCSTMF('src/$(SRC).c') $(CCFLAGS2) "

