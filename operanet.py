import h5py
import pandas as pd
from pandas.core.frame import DataFrame
from pathlib import Path
from scipy.io import loadmat
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


def get_header_from_ndarray(columns_row: ndarray):
    header = []
    for column_name in columns_row:
        header.append(column_name[0])
    return header


def read_mat(path_to_file: Path, modality: str) -> DataFrame:
    """Reads MAT files for Kinect

    Args:
        path_to_file (Path): Full path of mat file.
        path_to_file (Path): Full path of mat file.

    Returns:
        DataFrame: Pandas DataFrame with extracted data.
    """
    if modality not in ["Kinect", "PWR"]:
        pass
    try:
        # CSI files were created using matlab v7.3
        # so h5py is necessary
        tmp_mat = loadmat(path_to_file)[modality]
    except:
        with h5py.File(path_to_file, "r") as f:
            tmp_mat = f[modality]
    header = get_header_from_ndarray(tmp_mat[0])
    return DataFrame(tmp_mat[1:], columns=header)
