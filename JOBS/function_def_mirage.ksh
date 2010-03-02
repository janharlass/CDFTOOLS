#!/bin/ksh
# function_def.ksh file for mirage. To be used with cdfmoy and cdfvT jobs


#  $Rev$
#  $Date$
#  $Id$


# FROM CDFMOY suite
#####################
# chkdirg  path : check existence of directory path  on (remote) archiving machine. If it does not exist, create it.
chkdirg() { if [ ! -d $STOCKDIR/$1 ] ; then mkdir $STOCKDIR/$1 ; fi  ; }

# getmonth  mm type : retrieve all 5 days average files for month mm and grid type 'type', corresponding to current year, current confcase.A
#                     ex: getmonth 04 gridU  : retrieve all april files for gridU
getmonth() { for f  in  $STOCKDIR/$SDIR/${CONFCASE}_y${YEAR}m${1}\*_$2.nc   ; do
              cp $f ./
             done  ; }
# putmonth mm type : write back monthly mean for month mm type 'type' on remote machine in -MEAN/YEAR/ directory.
#                    also move the localfile to local MONTHLY dir for further annual mean computing

putmonth() { cp cdfmoy.nc $STOCKDIR/$MDIR/${CONFCASE}_y${YEAR}m${1}_$2.nc ;\
             mv cdfmoy.nc MONTHLY/${CONFCASE}_y${YEAR}m${1}_$2.nc ; \rm ${CONFCASE}_y${YEAR}m${1}d??_$2.nc ; }

# putmonth2 mm type : write back monthly quadratic  mean for month mm type 'type' on remote machine in -MEAN/YEAR/ directory.
#                    also move the localfile to local MONTHLY dir for further annual mean computing
putmonth2() { cp cdfmoy2.nc $STOCKDIR/$MDIR/${CONFCASE}_y${YEAR}m${1}_$2.nc ; \
             mv cdfmoy2.nc MONTHLY/${CONFCASE}_y${YEAR}m${1}_$2.nc ; }

# putannual type : write annual MEAN to remote -MEAN dir, in the corresponding year. Clean local files
putannual() { cp cdfmoy_annual.nc $STOCKDIR/$MDIR/${CONFCASE}_y${YEAR}_ANNUAL_$1.nc ; \rm cdfmoy_annual.nc ;}

# putvtmonth mm : write back monthly mean for month mm type 'VT' on remote machine in -MEAN/YEAR/ directory.
#                    also move the localfile to local MONTHLY dir for further annual mean computing
putvtmonth() { cp vt.nc $STOCKDIR/$MDIR/${CONFCASE}_y${YEAR}m${1}_VT.nc ; \
             mv vt.nc MONTHLY/${CONFCASE}_y${YEAR}m${1}_VT.nc ; \rm ${CONFCASE}_y${YEAR}m${month}d??_grid[UVT].nc ; }

# putvtannual type : write annual MEAN to remote -MEAN dir, in the corresponding year. Clean local files
putvtannual() { cp  cdfmoy_annual.nc $STOCKDIR/$MDIR/${CONFCASE}_y${YEAR}_ANNUAL_VT.nc ; \rm cdfmoy_annual.nc ; }
#


#  FROM MONITOR_PROD suite
###########################
# rapatrie : Usage: rapatrie  remote_file directory local_file
#   if local_file already here do nothing, else mfget it from gaya,
#   directory/remote_file
rapatrie() { if [ ! -f $3 ] ; then cp $STOCKDIR/$PREF/$2/$1 $3 ; else echo $3 is already \
            downloaded ; fi ; }

# expatrie : Usage:  expatrie local_file directory remote_file
#   put local file on gaya in directory/remote_file
#
expatrie() { cp $1 $STOCKDIR/$PREF/$2/$3 ; }

# chkfile : Usage: chkfile gaya_file
#    check if a file exists on gaya, return present or absent.
chkfile() {  if [ -f $STOCKDIR/$1 ] ; then echo present ;\
                       else echo absent ; fi  ; }

# chkdir  : Usage: chkdir local_dir
#   check the existence of a directory. Create it if not present
chkdir() { if [ ! -d $1 ] ; then mkdir $1 ; fi  ; }


# FROM gaya monitor.ksh
########################
# cptoweb : Usage: cptoweb  file.mtl
#    rcp the matlab file to the corresponding DATA dir of the website
cptoweb() { rcp $1 \
       apache@meolipc.hmg.inpg.fr:web/DRAKKAR/$CONFIG/$CONFCASE/DATA/ ; }

# chkdirw  : Usage: chkdirw web_site_directory
#   check the existence of a dir. on the web site. Create it if not present
chkdirw() { rsh meolipc.hmg.inpg.fr -l apache " if [ ! -d web/DRAKKAR/$1 ] ; \
            then mkdir web/DRAKKAR/$1 ; fi " ; }




