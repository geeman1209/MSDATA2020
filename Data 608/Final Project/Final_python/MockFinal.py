# -*- coding: utf-8 -*-
"""
Created on Sun May 16 21:42:45 2021

@author: gabre
"""

import pandas as pd
import numpy as np
import plotly
import matplotlib as plt


def get_data():
    dataFrame = pd.read_csv('./hate_crime.csv')
    return dataFrame

#Call the function to retrieve the data
df_1 = get_data()

def clean_data(dataFrame):
    del dataFrame['INCIDENT_ID']
    del dataFrame['ORI']
    del dataFrame['PUB_AGENCY_UNIT']
    del dataFrame['AGENCY_TYPE_NAME']
    del dataFrame['POPULATION_GROUP_CODE']
    del dataFrame['POPULATION_GROUP_DESC']
    del dataFrame['INCIDENT_DATE']
    del dataFrame['ADULT_VICTIM_COUNT']
    del dataFrame['JUVENILE_VICTIM_COUNT']
    del dataFrame['ADULT_OFFENDER_COUNT']
    del dataFrame['JUVENILE_OFFENDER_COUNT']
    del dataFrame['OFFENDER_ETHNICITY']
    del dataFrame['MULTIPLE_OFFENSE']
    del dataFrame['MULTIPLE_BIAS']
    return dataFrame

df_2 = clean_data(df_1).copy()

data = df_2.query('year == 2010')



