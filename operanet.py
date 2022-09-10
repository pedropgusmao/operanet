import pandas as pd
import mat73
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


def read_mat(path_to_file: Path) -> DataFrame:
    """Reads MAT files for Kinect

    Args:
        path_to_file (Path): Full path of mat file.
        path_to_file (Path): Full path of mat file.

    Returns:
        DataFrame: Pandas DataFrame with extracted data.
    """
    # CSI files were created using matlab v7.3
    # so h5py is necessary
    tmp_dict = mat73.loadmat(path_to_file, use_attrdict=True)
    k, v = tmp_dict.popitem()
    df = pd.DataFrame(v[1:], columns=v[0])
    if "timestamp" in df:
        for j in len(df["timestamp"]):
            if isinstance(df["timestamp"][j], list):
                df["timestamp"][j] = df["timestamp"][j][0]

    return
