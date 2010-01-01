#!/bin/bash
nargs=$#
if [ ${nargs} -lt 3 ]
then 
cat<<_EOF
USAGE: readRes.sh resultFile dorisStep parameter

INPUT:
  resultFile: is the DORIS result file (*.res)
  dorisStep: is the processing step to look for the parameter.
  parameter: field to be read in the result file. 

OUTPUT: 
  parameter value from the result file. 

LIMITATIONS:
If the value of the parameter has ":" character the returned field might be wrong.

EXAMPLE:
$> readRes.sh  /RAID1/batu/adore_MexicoCity2/process/20by20/crops/09828/09828.res readfiles RADAR_FREQUENCY
5331004416.000000
$> readRes.sh /RAID1/batu/adore_MexicoCity2/process/20by20/crops/09828/09828.res readfiles First_pixel_azimuth_time
31.238
$> grep First_pixel_azimuth_time /RAID1/batu/adore_MexicoCity2/process/20by20/crops/09828/09828.res 
First_pixel_azimuth_time (UTC):                 16-JAN-2004 16:36:31.238
_EOF
exit 1
fi
#Input:
# readres.sh "inputfile" "section" "parameter"

inputfile=${1}
section=${2}
parameter=${3}
startline=`grep -n _Start_${section} ${inputfile} | cut -f1 -d":"`
endline=`grep -n End_${section} ${inputfile} | cut -f1 -d":"`

length=`echo ${endline} - ${startline} |bc`
result=`grep -A ${length} _Start_${section} ${inputfile} | grep ${parameter}`
#echo $result

result=${result##*:} 	#Get the part after the LAST column 

#echo "$startline $endline $length $parameter_length"
#echo "$parameter"
echo $result