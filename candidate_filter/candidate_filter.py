#!/usr/bin/env python3.6
import optparse
import argparse
import json
import os
import reading_cands
import cluster_cands
import spatial_rfi
import filtering
import pandas as pd
import numpy as np
import known_filter
import time
import glob

def parse_arguments():
    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description='Command line arguments for the candidate filtering.')
    parser.add_argument('-i', '--input', type=str, default='', metavar=('input_files'),
                        help="Path to directory containing the input files.", nargs='+')
    parser.add_argument('-o', '--output', type=str, default='', metavar=('output_path'),
                        help="Base name of the output csv files")
    default_config_path = f"{os.path.dirname(__file__)}/default_config.json"
    parser.add_argument('-c', '--config', type=str, default=default_config_path,
                        metavar=('config_file'), help="Path to config file.")
    parser.add_argument('-p', '--plot', action='store_true',
                        help="Plot diagnostic plots of the clusters.")
    parser.add_argument('-H','--harmonics',type=int,help='harmonic number to search upto',default=16)
    parser.add_argument('--p_tol',type=float,help='period tolerance',dest="p_tol",default=5e-4)
    parser.add_argument('--dm_tol',type=float,help='dm tolerance',dest="dm_tol",default=5e-3)
    parser.add_argument('--par',type=str,help='Path to par files of known pulsars',dest="par_path",default='/beegfs/u/prajwalvp/presto_ephemerides/Ter5/par_files_scott')
    parser.add_argument('--rfi',type=str,help='known birdie list name',dest="birdies",default='known_rfi.txt')
    parser.add_argument('--searchpsr',type=str,help='Flag for filtering known pulsars(Default is no known pulsar filtering(0))',dest="psr_filter",default=0)
    args = parser.parse_args()
    return args

def a_to_pdot(P_s, acc_ms2):
    LIGHT_SPEED = 2.99792458e8                 # Speed of Light in SI
    return P_s * acc_ms2 /LIGHT_SPEED


def period_modified(p0,pdot,no_of_samples,tsamp,fft_size):
    if (fft_size==0.0):
        return p0 - pdot*float(1<<(int(no_of_samples).bit_length()-1))*tsamp/2
    else:
        return p0 - pdot*float(fft_size)*tsamp/2


def main(args):
    # Main function

    # Load config
    with open(args.config) as json_data_file:
        config = json.load(json_data_file)

    # Read files into a single pandas DataFrame
    xml_list = sorted(glob.glob("{}/*.xml".format(args.input)))
    df_cands_ini, obs_meta_data = reading_cands.read_candidate_files(xml_list)


   
    # Remove DM candidates below 2 pc cm^-3 - 0 DM + too low a DM to probably be real
    print("Removing candidates below DM of 2 pc cm^-3") 
    df_cands_ini = df_cands_ini[df_cands_ini['dm'] > 2.0]


    # Get candidate periods and dms
    cand_mid_periods = df_cands_ini['period'].to_numpy()
    cand_dms = df_cands_ini['dm'].to_numpy()
    cand_snrs = df_cands_ini['snr'].to_numpy()
    cand_accs = df_cands_ini['acc'].to_numpy()


    # Modify periods to starting epoch reference
    print("Calculating modified period based on starting epoch reference")

    tsamp = obs_meta_data['tsamp']
    fft_size = obs_meta_data['fft_size']
    nsamples = obs_meta_data['nsamples']

    mod_periods=[]
    pdots = []
    for i in range(len(cand_mid_periods)):
        Pdot = a_to_pdot(cand_mid_periods[i],cand_accs[i])
        mod_periods.append(period_modified(cand_mid_periods[i],Pdot,nsamples,tsamp,fft_size))
        pdots.append(Pdot)

    cand_periods = np.asarray(mod_periods,dtype=float)
    cand_freqs = 1/cand_periods
    cand_mid_freqs = 1/cand_mid_periods
     

    




    # Label known RFI sources
    known_rfi_indices = known_filter.get_known_rfi(cand_mid_freqs,args)
    print("Number of RFI instances: %d"%len(known_rfi_indices))
    time.sleep(5)



    # Retain candidates which are not known rfi or pulsars
    if args.psr_filter:
        # Get known pulsar periods and dms
        known_psrs = known_filter.get_params_from_pars(args.par_path)
        known_freqs = np.array(known_psrs['F0'],dtype=float)
        known_dms = np.array(known_psrs['DM'],dtype=float)

        # Label known pulsar sources from input par files
        known_psr_indices,known_ph_indices = known_filter.get_known_psr(args,known_psrs,known_freqs,known_dms,cand_freqs,cand_dms,cand_snrs) 
        all_known_indices =  list(set(list(known_rfi_indices) + known_psr_indices + known_ph_indices))

    else:
        all_known_indices =  list(set(list(known_rfi_indices)))

    print("Number of dropped candidates: %d"%len(all_known_indices))
    df_cands_remain = df_cands_ini.drop(df_cands_ini.index[all_known_indices]) 

    df_cands_remain.to_csv('remaining_cands.csv')

    # Create clusters from remaining candidates
    #df_cands_clustered = cluster_cands.cluster_cand_df(
    #    df_cands_ini, obs_meta_data, config)

    df_cands_clustered = cluster_cands.cluster_cand_df(
        df_cands_remain, obs_meta_data, config)

    # Find spatial RFI and write out details about clusters

    df_clusters = spatial_rfi.label_spatial_rfi(df_cands_clustered, config)


    # Label bad clusters

    df_cands_filtered, df_clusters_filtered = filtering.filter_clusters(df_cands_clustered,
                                                                         df_clusters, config, args)


    # Write out known rfi file
    df_cands_ini.iloc[known_rfi_indices,:].to_csv(f"{args.output}_known_rfi_cands.csv")



    if args.psr_filter:
        # Write out known pulsar file
        df_cands_ini.iloc[known_psr_indices,:].to_csv(f"{args.output}_known_psr_cands.csv")

        # Write out known pulsar harmonics file
        df_cands_ini.iloc[known_ph_indices,:].to_csv(f"{args.output}_known_ph_cands.csv")

    
   
    # Write out reduced candidate list
    df_cands_filtered.to_csv(f"{args.output}_cands.csv")
    # Write out cluster list
    df_clusters_filtered.to_csv(f"{args.output}_clusters.csv")

if __name__ == "__main__":
    args = parse_arguments()
    main(args)
