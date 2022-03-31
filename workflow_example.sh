#!/bin/bash

#SBATCH --account=nn2806k 
#SBATCH --job-name=mkmapdata
#SBATCH --mem-per-cpu=256G --partition=bigmem
#SBATCH --ntasks=1
#SBATCH --time=07:00:00

# "creat_mapping" need extra large memory and long time (several hours) to finish. Thus, it is bettter to be run in a queue system (This is why the batch configuration is provided at the begining.)

date="200927"         # Date when you create the inputdata. 
input_dir="/cluster/shared/noresm/inputdata_fates_platform" # home folder for storing the inputdata for each site. 
version="version2.0.0"                                    # version of inputdata
treatment="moss"         # grass, moss, bare
usr_temp="/cluster/home/huit/ctsm_cases/BOR4_${treatment}/user_nl_clm"
fates_paramfile="/cluster/work/users/huit/inputdata/lnd/clm2/paramdata/fates_params_${treatment}_only_0tau_10clump_0xl.nc"
experimentID="S1V1"

#S3V1: T32223F
#S2V1: T22223F
#S1V1: T12223F
#S3V2: T32224F
#S2V2: T22224F
#S1V2: T12224F

######### SeedClim Sites
plotlat=(61.0243 60.8231 60.8328 60.9335 60.8203 60.8760 61.0866 60.5445 61.0355 60.8803 60.6652 60.6901)
plotlon=(8.12343 7.27596 7.17561 6.41504 8.70466 7.17666 6.63028 6.51468 9.07876 7.16982 6.33738 5.96487)
plotname=(ALP1 ALP2 ALP3 ALP4 SUB1 SUB2 SUB3 SUB4 BOR1 BOR2 BOR3 BOR4)

######### Landpress Sites
#plotlat=(60.70084 65.83677 64.779 65.79602)
#plotlon=(5.092566 12.224506 11.2193 12.219299)
#plotname=(LYG BUO HAV SKO)

######### Three-D Sites
#plotlat=(60.88019 60.86183 60.85994)
#plotlon=(7.16990 7.16800 7.19504)
#plotname=(VIKE JOAS LIAH)

######### Finnmark Site
#plotlat=(69.341088)
#plotlon=(25.293524)
#plotname=(FINN)


######### Switch for all the steps related to setting a site simulation. 
######### Set all "creat_****" switches to "T" to create inputdata for the site simulation
######### Set "tar_input" to "T" to wrap up all the inputdata to a tar file
######### Set "run_***" to "T" to run the site simulation
create_case="F"             # T or F, swtich for creating, building and submitting short test runs
run_case="F"            # T or F, swtich for running long experiments
run_archive="T"                # T or F, swtich for archiving experiments. 
merge_hist="F"                 # T or F, merge history experiments. 

#0 1 2 3 4 5 6 7 8 9 10 11
for i in 11
do

case_name="${plotname[i]}_${treatment}_1.0.0"
fsurdat="/cluster/work/users/huit/inputdata/lnd/clm2/surfdata_map/${plotname[i]}/surfdata_${plotname[i]}_simyr2000_${treatment}.nc"


######## Create a case
if [ ${create_case} == "T" ]
then
  
  module purge
    
  cd ~/ctsm_region/cime/scripts

  ./create_newcase --case ../../../ctsm_cases/${case_name} --compset 2000_DATM%1PTGSWP3_CLM50%FATES_SICE_SOCN_MOSART_SGLC_SWAV --res 1x1_${plotname[i]} --machine saga --run-unsupported --project nn2806k    
    

# copy inputdata to the working directory

 #cp /cluster/shared/noresm/inputdata_fates_platform/inputdata_version2.0.0_${plotname[i]}.tar $USERWORK/
 #cd $USERWORK/
 #tar xvf inputdata_version2.0.0_${plotname[i]}.tar

  cp ${input_dir}/inputdata_${version}_${plotname[i]}.tar /cluster/work/users/$USER/
  cd /cluster/work/users/$USER/
  tar xvf inputdata_${version}_${plotname[i]}.tar


# atmospheric forcing of crunecp is generated on FRAM
# Three steps to make the new forcing work
  #step 1: modify cime/src/components/data_comps_mct/datm/cime_config/namelist_definition_datm.xml
  #step 2: modify env_run: DIN_LOC_ROOT_CLMFORC, LND_TUNING_MODE

  #cd prepare_atm_forcing_ctsm/
  #module load NCL/6.6.2-intel-2018b
  #ncl prepare_atm_forcing_cruncep.ncl

  
# Modify surface data, 
  # using python script: moss_lichen_albedo_new
  # directly modify surface data in the inputdata folder
  
  cd /cluster/work/users/huit/inputdata/lnd/clm2/surfdata_map/${plotname[i]}
  cp surfdata_${plotname[i]}_simyr2000.nc surfdata_${plotname[i]}_simyr2000_${treatment}.nc
#  ncdump surfdata_${plotname[i]}_simyr2000_${treatment}.nc > surfdata_${plotname[i]}_simyr2000_${treatment}.cdl

# Parameter file
# use the one made for ALP1
#   

######## Build the case and run the case 
  cd ~/ctsm_cases/${case_name}
    
  ./xmlchange --file env_run.xml --id RUN_STARTDATE --val 2010-01-01                
  ./xmlchange --file env_run.xml --id STOP_OPTION --val nyears               
  ./xmlchange --file env_run.xml --id STOP_N --val 7                        
  ./xmlchange --file env_run.xml --id DOUT_S --val TRUE 
  ./xmlchange --file env_run.xml --id DIN_LOC_ROOT_CLMFORC --val /cluster/work/users/$USER 
  ./xmlchange --file env_run.xml --id DATM_CLMNCEP_YR_START --val 2010
  ./xmlchange --file env_run.xml --id DATM_CLMNCEP_YR_END --val 2016   
  ./xmlchange --file env_run.xml --id LND_TUNING_MODE --val clm5_0_CRUv7   
    
   cp ${usr_temp} ./
  
   sed -i "32s,.*, fsurdat=\'${fsurdat}\'," ./user_nl_clm
   sed -i "33s,.*, fates_paramfile=\'${fates_paramfile}\'," ./user_nl_clm

   sed -i "43s,.*, use_mosslichen      = .true.," ./user_nl_clm
   sed -i "44s,.*, use_mosslichen_mode = 3," ./user_nl_clm
   sed -i "45s,.*, use_mosslichen_photosyn = 2," ./user_nl_clm
   sed -i "46s,.*, use_mosslichen_photo_flux= 2," ./user_nl_clm
   sed -i "47s,.*, use_mosslichen_water=2," ./user_nl_clm
   sed -i "48s,.*, use_mosslichen_rad=3," ./user_nl_clm
   sed -i "49s,.*, use_mosslichen_bvoc      = .false.," ./user_nl_clm
   
   ./case.setup
   ./case.build
fi

if [ ${run_case} == "T" ]
then
   module purge
   cd ~/ctsm_cases/${case_name}

   sed -i "43s,.*, use_mosslichen      = .true.," ./user_nl_clm
   sed -i "44s,.*, use_mosslichen_mode = 3," ./user_nl_clm
   sed -i "45s,.*, use_mosslichen_photosyn = 2," ./user_nl_clm
   sed -i "46s,.*, use_mosslichen_photo_flux= 2," ./user_nl_clm
   sed -i "47s,.*, use_mosslichen_water=2," ./user_nl_clm
   sed -i "48s,.*, use_mosslichen_rad=4," ./user_nl_clm
   sed -i "49s,.*, use_mosslichen_bvoc      = .false.," ./user_nl_clm
   
#   sed -i '38d' ./env_batch.xml
   
   ./case.submit
   
fi

######## Merge history files
  if [ ${merge_hist} == "T" ]
  then
#    module purge
#    module load NCO/4.9.1-intel-2019b
#    ls -a -l /cluster/work/users/huit/archive/${case_name}/logs  

#    ncrcat /cluster/work/users/huit/archive/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h2.*.nc /cluster/work/users/huit/archive/${case_name}_${experimentID}/lnd/hist/merge_${case_name}_${experimentID}.clm2.h2.2010-2016.nc
#    ncrcat /cluster/work/users/huit/archive/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h1.*.nc /cluster/work/users/huit/archive/${case_name}_${experimentID}/lnd/hist/merge_${case_name}_${experimentID}.clm2.h1.2010-2016.nc
#    ncrcat /cluster/work/users/huit/archive/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h0.*.nc /cluster/work/users/huit/archive/${case_name}_${experimentID}/lnd/hist/merge_${case_name}_${experimentID}.clm2.h0.2010-2016.nc

    module purge
    module load NCO/4.9.1-intel-2019b
#    ncrcat /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h2.2015*.nc /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h2.2016*.nc /cluster/projects/nn2806k/mosslichen/model/Merged_results/${case_name}_${experimentID}.clm2.h2.2015-2016.nc
#    ncrcat /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h0.2015*.nc /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h0.2016*.nc /cluster/projects/nn2806k/mosslichen/model/Merged_results/${case_name}_${experimentID}.clm2.h0.2015-2016.nc
#    ncrcat /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h1.2015*.nc /cluster/projects/nn2806k/mosslichen/model/${case_name}_${experimentID}/lnd/hist/${case_name}.clm2.h1.2016*.nc /cluster/projects/nn2806k/mosslichen/model/Merged_results/${case_name}_${experimentID}.clm2.h1.2015-2016.nc

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

