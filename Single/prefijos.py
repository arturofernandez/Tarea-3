import glob
import os

for f in glob.glob('*.sv'):
    new_filename = "single_" + f
    os.rename(f,new_filename)