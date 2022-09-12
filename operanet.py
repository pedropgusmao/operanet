from calendar import c
from turtle import end_fill
import pandas as pd
import re
from pandas.core.frame import DataFrame
from pathlib import Path
from typing import Dict, List
from numpy import ndarray


def read_uwb(path_to_file: Path) -> DataFrame:
    """Reads Ultra-Wideband CSV files from OPERAnet.

    Args:
        path_to_file (Path): Full path of csv file.

    Returns:
        DataFrame: Pandas DataFrame with UWB data.
    """
    return pd.read_csv(path_to_file, header=1)


def read_parquet(path_to_file: Path) -> DataFrame:
    """Reads Parquet files for Kinect

    Args:
        path_to_file (Path): Full path of parquet file.
        path_to_file (Path): Full path of parquet file.

    Returns:
        DataFrame: Pandas DataFrame with extracted data.
    """
    df = pd.read_parquet(path_to_file)
    if "timestamp" in df:
        pass

    # CSI transmission columns back to complex
    # Kinect columns are sent back to (N,3)
    wificsi_complex = re.compile("tx*rx*_sub*")
    kinect_markers = re.compile("Kinect*_Markers")
    for col_name in df.keys():
        if wificsi_complex.match(col_name):
            df[col_name] = df[col_name][:,0] + 1j*df[col_name][:,1]
        elif kinect_markers.match(col_name):
            df[col_name] = df[col_name].reshape((-1,3))

    return
