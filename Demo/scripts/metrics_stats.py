# !/usr/bin/env python

import os
import fnmatch
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import plotly.graph_objects as go
import seaborn as sns
from PIL import Image

current_path = os.getcwd()
os.chdir('../data')
file_ = os.getcwd()+"/values.xlsx"
os.chdir('../')
if not os.path.exists("results"):
    os.mkdir("results")
os.chdir('results')
dir_correlation = 'correlation/'
dir_metrics_seq = 'metrics_sequences/'
dir_avg_environment = 'avg_environment/'


def read_file(path_file):
    data = pd.read_excel(path_file)
    data.drop(columns='Ground-truth', inplace=True)
    return data


def replace_character(data):
    data = [x.upper() for x in data]
    out = []
    for string in data:
        new_data = string.replace("_", " ")
        out.append(new_data)
    return out


def fix_axes(data):
    categories = replace_character(data['INDEX'])
    categories = [*categories, categories[0]]
    return categories


def drop_metrics(data, no_metrics):
    for i in range(len(no_metrics)):
        data.drop(data[data['INDEX'] == no_metrics[i]].index, inplace=True)
    return data.reset_index(drop=True)


def avg_metrics(data, env):
    metrics = data['INDEX'].unique()
    val_aloam, val_floam, val_iscloam, val_legoloam = [], [], [], []
    for y in metrics:
        aloam = data.loc[data['INDEX'] == y, 'A-LOAM'].mean()
        floam = data.loc[data['INDEX'] == y, 'FLOAM'].mean()
        iscloam = data.loc[data['INDEX'] == y, 'ISCLOAM'].mean()
        legoloam = data.loc[data['INDEX'] == y, 'LEGO-LOAM'].mean()
        val_aloam.append(aloam)
        val_floam.append(floam)
        val_iscloam.append(iscloam)
        val_legoloam.append(legoloam)
    return val_aloam, val_floam, val_iscloam, val_legoloam


def crop(path):
    left, right = 120, 560
    top, bottom = 20, 480
    listOfFiles = os.listdir('.')
    pattern = "*.png"
    for entry in listOfFiles:
        if fnmatch.fnmatch(entry, pattern):
            # print(entry)
            im = Image.open(entry)
            im1 = im.crop((left, top, right, bottom))
            im1.save(entry, quality=100)
            # im1.show()


def figure_plotly(title, data, categories):
    new_name = title.split('/')[1]
    fig = go.Figure(
        data=[
            go.Scatterpolar(r=data[0], theta=categories, name='A-LOAM'),
            go.Scatterpolar(r=data[1], theta=categories, name='FLOAM'),
            go.Scatterpolar(r=data[2], theta=categories, name='ISCLOAM'),
            go.Scatterpolar(r=data[3], theta=categories, name='LEGO-LOAM'),
        ],
        layout=go.Layout(
            title={
                'text': new_name,
                'x': 0.5,
                'y': 0.95,
                'xanchor': 'center',
            },
            polar={'radialaxis': {'visible': True}}, legend=dict(
                orientation="h", x=0.1)
        )
    )

    fig.write_image(title+'.png')
    # fig.show()


def plot_radar_for_metric(data, no_metrics, num_seq):
    """
      data: dataset
      no_metrics: drop metrics
      num_seq: sequence #
      s: yes or no [save figure]
    """

    data.drop(data.index[data['Sequence'] != num_seq], inplace=True)
    data = drop_metrics(data, no_metrics)

    categories = fix_axes(data)

    aloam, floam, iscloam, legoloam = data['A-LOAM'], data['FLOAM'], data['ISCLOAM'], data['LEGO-LOAM']
    aloam, floam, iscloam, legoloam = [
        *aloam, aloam[0]], [*floam, floam[0]], [*iscloam, iscloam[0]], [*legoloam, legoloam[0]]
    methods = [aloam, floam, iscloam, legoloam]
    title = dir_metrics_seq+'Sequence '+str(num_seq)
    figure_plotly(title, methods, categories)


def plot_radar_for_metric_env(data, no_metrics, env):
    """
      data: dataset
      no_metrics: drop metrics
      env: environment
      s: yes or no [save figure]
    """
    if env == 'all':
        pass
    else:
        data.drop(data.index[data['Environment'] != env], inplace=True)
    data = drop_metrics(data, no_metrics)

    categories = fix_axes(data)

    aloam, floam, iscloam, legoloam = [i for i in avg_metrics(data, env)]
    aloam, floam, iscloam, legoloam = [
        *aloam, aloam[0]], [*floam, floam[0]], [*iscloam, iscloam[0]], [*legoloam, legoloam[0]]
    methods = [aloam, floam, iscloam, legoloam]
    title = dir_avg_environment+'Average '+env
    figure_plotly(title, methods, categories)


def correlation(data):
    methods = ['A-LOAM', 'FLOAM', 'ISCLOAM', 'LEGO-LOAM']
    variables = ['Translation', 'Rotation', 'ATE', 'Traveled_distance', 'Average_speed',
                 'Yaw_dispersion', 'RMSE_yaw', 'RMSE_pitch', 'RMSE_roll', 'RMSE_x', 'RMSE_y', 'RMSE_z']
    N = len(methods)
    L = len(variables)
    seqs = 11
    for k in range(0, N):
        M = np.zeros([seqs, L])
        for j in range(0, L):
            pos = data['INDEX'] == variables[j]
            values = data[pos][methods[k]]
            M[:, j] = values
        corr_df = pd.DataFrame(M, columns=replace_character(variables))
        corr_p = corr_df.corr(method='pearson')
        # print("COPR", corr_p)
        # print("Matriz de correlación de Pearson \n", corr_p.round(2))
        fig = plt.figure(figsize=(10, 10))
        sns.heatmap(corr_p, annot=True)
        plt.title("Pearson Correlation: "+methods[k])
        fig.savefig(dir_correlation+'Corr_'+methods[k]+'.png', dpi=300,
                    transparent=True, bbox_inches="tight")
        # plt.show()


if __name__ == "__main__":
    # drop metrics
    no_metrics = ['Traveled_distance', 'Average_speed',
                  'Translation', 'Rotation', 'Yaw_dispersion']

    df = read_file(file_)

    # corr pearson
    correlation(df)

    # metrics seq
    num_sequences = [x for x in range(0, 12)]
    for i in num_sequences:
        try:
            plot_radar_for_metric(read_file(file_), no_metrics, i)
        except Exception as e:
            pass

    # avg env
    environment = ['Urban', 'Highway', 'Urban+Country', 'Country']
    for i in environment:
        try:
            plot_radar_for_metric_env(
                read_file(file_), no_metrics, i)
        except Exception as e:
            pass

# all avg
plot_radar_for_metric_env(df, no_metrics, 'all')

# crop images
# crop(os.getcwd())
