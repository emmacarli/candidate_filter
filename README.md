# candidate_filter
Filter and group pulsar candidates of different beams based on spatial information.

Requires >= python 3.6.



```usage: candidate_filter.py [-h] [-i input_files [input_files ...]]
                           [-o output_path] [-c config_file] [-p]
                           [-H HARMONICS] [--p_tol P_TOL] [--dm_tol DM_TOL]
                           [--par PAR_PATH] [--rfi BIRDIES]
```

Command line arguments for the candidate filtering.



optional arguments:
  -h, --help            show this help message and exit
  
  
  -i input_files [input_files ...], --input input_files [input_files ...]
                        Path to the input files.
                        
                        
  -o output_path, --output output_path
                        Base name of the output csv files
                        
                        
  -c config_file, --config config_file
                        Path to config file.
                        
                        
  -p, --plot            Plot diagnostic plots of the clusters.
  
  
  -H HARMONICS, --harmonics HARMONICS
                        harmonic number to search upto
                        
                        
  --p_tol P_TOL         period tolerance
  
  
  --dm_tol DM_TOL       dm tolerance
  
  
  --par PAR_PATH        Path to par files of known pulsars
  
  
  --rfi BIRDIES         known birdie list name




Basic usage:

```python candidate_filter.py --input /path_to_input/beam_folder_*/overview.xml --output /path_to_output/base_name ```
