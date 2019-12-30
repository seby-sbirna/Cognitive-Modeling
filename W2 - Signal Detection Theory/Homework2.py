
"""
12 SEP 2019
02458 Cognitive Modeling
Homework 2

Seb Sbirna and Aleksander Frese
"""

import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

# --- generate samples ---- #

n_samples = 50
mu_noise, sigma_noise = 0, 1
mu_signal, sigma_signal = 1, 1

s_noise = np.random.normal(mu_noise, sigma_noise, n_samples) # get 50 samples from the noise normal dist
s_signal = np.random.normal(mu_signal, sigma_signal, n_samples) # get 50 samples from the signal normal dist

# s_joined = np.concatenate([s_signal, s_noise])
# print(len(s_joined)) # testing

# ---- classify/categorize ----- #

def obsResp(criterion, input):
    response = 0
    if input > criterion:
        response = 1
    return response

# ---- moderate bias = 0.5 ----- #

# print(obsResp(0.5, s_noise[0]))
resp_noise = []
for i in s_noise:
    resp_noise.append(obsResp(0.5, i))

resp_signal = []
for i in s_signal:
    resp_signal.append(obsResp(0.5, i))

# print(resp_noise)
# print(len(resp_noise))
# print("yes:", sum(resp_noise))
# print("no:", 50 - sum(resp_noise))

p_hit = sum(resp_signal)/len(resp_signal)
p_fa = sum(resp_noise)/len(resp_noise)

# estimate d'
est_d_prime = stats.norm.ppf(p_hit) - stats.norm.ppf(p_fa)
print("estimated d' with moderate bias = 0.5:", est_d_prime)

# --- plotting ROC --- #
# source of the code below: https://towardsdatascience.com/receiver-operating-characteristic-curves-demystified-in-python-bd531a4364d0

"""
def pdf(x, std, mean):
    const = 1.0 / np.sqrt(2*np.pi*(std**2))
    pdf_normal_dist = const*np.exp(-((x-mean)**2)/(2.0*(std**2)))
    return pdf_normal_dist

x = np.linspace(0, 1, num=100)
good_pdf = pdf(x,1,0)
print(good_pdf)
"""
x = np.linspace(0, 1, num=50)

def plot_roc(good_pdf, bad_pdf, ax):
    #Total
    total_bad = np.sum(bad_pdf)
    total_good = np.sum(good_pdf)
    #Cumulative sum
    cum_TP = 0
    cum_FP = 0
    #TPR and FPR list initialization
    TPR_list=[]
    FPR_list=[]
    #Iteratre through all values of x
    for i in range(len(x)):
        #We are only interested in non-zero values of bad
        if bad_pdf[i]>0:
            cum_TP+=bad_pdf[len(x)-1-i]
            cum_FP+=good_pdf[len(x)-1-i]
        FPR=cum_FP/total_good
        TPR=cum_TP/total_bad
        TPR_list.append(TPR)
        FPR_list.append(FPR)
    #Calculating AUC, taking the 100 timesteps into account
    auc=np.sum(TPR_list)/100
    #Plotting final ROC curve
    ax.plot(FPR_list, TPR_list)
    ax.plot(x,x, "--")
    ax.set_xlim([0,1])
    ax.set_ylim([0,1])
    ax.set_title("ROC Curve", fontsize=14)
    ax.set_ylabel('TPR', fontsize=12)
    ax.set_xlabel('FPR', fontsize=12)
    ax.grid()
    ax.legend(["AUC=%.3f"%auc])

fig, ax = plt.subplots(1,1, figsize=(10,5))
plot_roc(s_signal, s_noise, ax)
plt.show()