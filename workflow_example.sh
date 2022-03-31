#!/bin/bash
 
input_dir="/home/user/NorESM_LandSites_Platform/data/input/clm" # home folder for storing the inputdata for each site. 
model_dir="/home/user/NorESM_LandSites_Platform/noresm2"
case_dir= "/home/user/NorESM_LandSites_Platform/data/cases"
output_dir="/home/user/NorESM_LandSites_Platform/data/output"

experimentID="xxxx"
version="1.0.0"                                    # version of inputdata

out_list="'GPP_SCPF', 'PFTcrownarea'"

######### SeedClim Sites
plotlat=(61.0243 60.8231 60.8328 60.9335)
plotlon=(8.12343 7.27596 7.17561 6.41504)
sitename=(ALP1 ALP2 ALP3 ALP4)

######### Switch for all the steps related to setting a site simulation. 
create_case="F"             # T or F, swtich for creating, building and submitting short test runs
run_case="F"            # T or F, swtich for running long experiments
run_archive="F"                # T or F, swtich for archiving experiments. 
merge_hist="F"                 # T or F, merge history experiments. 

#0 1 2 3 
for i in 0
do

case_name="${sitename[i]}_${experimentID}_${version}"
fsurdat="/home/user/NorESM_LandSites_Platform/data/input/${sitename[i]}_*version*_input/inputdata/lnd/clm2/surfdata_map/${sitename[i]}/surfdata_${plotname[i]}_simyr2000.nc"
fates_paramfile=""/home/user/NorESM_LandSites_Platform/data/input/${sitename[i]}_*version*_input/inputdata/lnd/clm2/paramdata/fates_params_*****.nc"

######## Create a case
if [ ${create_case} == "T" ]
then
# not needed, use lasse's automatic script, but it needs to be adapted to download different version of the inputdata
#  cd ${model_dir}  
#  ./create_newcase --case ../../data/cases/${case_name} --compset 2000_DATM%1PTGSWP3_CLM50%FATES_SICE_SOCN_MOSART_SGLC_SWAV --res 1x1_${sitename[i]} --machine container_nlp  --run-unsupported   
   
# Parameter file
# use the one made for ALP1

######## Build the case and run the case 
 cd ${case_dir}/${case_name}
   
   ./xmlchange --file env_build.xml --id CALENDAR --val GREGORIAN 
    
  ./xmlchange --file env_run.xml --id RUN_STARTDATE --val 1995-01-01                
  ./xmlchange --file env_run.xml --id STOP_OPTION --val nyears               
  ./xmlchange --file env_run.xml --id STOP_N --val 100                        
  ./xmlchange --file env_run.xml --id DOUT_S --val TRUE 
  ./xmlchange --file env_run.xml --id DIN_LOC_ROOT_CLMFORC --val *****${input_dir}/***
  ./xmlchange --file env_run.xml --id DATM_CLMNCEP_YR_ALIGN --val 1995
  ./xmlchange --file env_run.xml --id DATM_CLMNCEP_YR_START --val 1995
  ./xmlchange --file env_run.xml --id DATM_CLMNCEP_YR_END --val 2018   
  ./xmlchange --file env_run.xml --id LND_TUNING_MODE --val clm5_0_CRUv7   
  
   sed -i "32s,.*, fsurdat=\'${fsurdat}\'," ./user_nl_clm
   sed -i "33s,.*, fates_paramfile=\'${fates_paramfile}\'," ./user_nl_clm
   sed -i "34s,.*, co2_ppmv=367.0," ./user_nl_clm
   sed -i "35s,.*, use_bedrock = .true.," ./user_nl_clm
   sed -i "36s/.*/ hist_fincl2=${out_list}/" ./user_nl_clm
  # sed -i "37s/.*/ hist_avgflag_pertape = 'A','A'/" ./user_nl_clm
  # sed -i "38s/.*/ hist_dov2xy = .true.,.true./" ./user_nl_clm
  # sed -i "39s/.*/ hist_mfilt  = 1,1,/" ./user_nl_clm
  # sed -i "40s/.*/ hist_nhtfrq = 0,0,/" ./user_nl_clm
   
   ./case.build     # need to rebuild the case if you change the calendar
fi

if [ ${run_case} == "T" ]
then

   cd ${case_dir}/${case_name}

   ./case.submit
   
fi

######## Merge history files (just an example, not ready to used directly in container)
  if [ ${merge_hist} == "T" ]
  then

#    ncrcat /cluster/projects/nn2806k/mosslichen/model/${case_name}/lnd/hist/${case_name}.clm2.h2.2015*.nc /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h2.2016*.nc /cluster/projects/nn2806k/mosslichen/model/Merged_results/${case_name}_${experimentID}.clm2.h2.2015-2016.nc
#    ncrcat /cluster/projects/nn2806k/mosslichen/model/${case_name}/lnd/hist/${case_name}.clm2.h0.2015*.nc /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h0.2016*.nc /cluster/projects/nn2806k/mosslichen/model/Merged_results/${case_name}_${experimentID}.clm2.h0.2015-2016.nc
#    ncrcat /cluster/projects/nn2806k/mosslichen/model/${case_name}/lnd/hist/${case_name}.clm2.h1.2015*.nc /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h1.2016*.nc /cluster/projects/nn2806k/mosslichen/model/Merged_results/${case_name}_${experimentID}.clm2.h1.2015-2016.nc

    ncrcat /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/*.clm2.h0.2015*.nc /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/*.clm2.h0.2016*.nc /cluster/projects/nn2806k/mosslichen/model/Merged_results/${case_name}_${experimentID}.clm2.h0.2015-2016.nc
    ncrcat /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/*.clm2.h1.2015*.nc /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/*.clm2.h1.2016*.nc /cluster/projects/nn2806k/mosslichen/model/Merged_results/${case_name}_${experimentID}.clm2.h1.2015-2016.nc  
 
  fi

######## Archive experiments
  if [ ${run_archive} == "T" ]
  then

#    mv /cluster/work/users/huit/archive/${case_name} /cluster/work/users/huit/archive/${case_name}_${experimentID}    
#    rm /cluster/work/users/huit/archive/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h*.*.nc
#    ls -a -l /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/logs
#    mv /cluster/work/users/huit/archive/${case_name}_${experimentID} /cluster/projects/nn2806k/mosslichen/model/
    cd /cluster/work/users/huit/model
    tar cvf ${case_name}_${experimentID}.tar ${case_name}_${experimentID}
    mv ${case_name}_${experimentID}.tar /cluster/projects/nn2806k/mosslichen/model/

  fi

done

