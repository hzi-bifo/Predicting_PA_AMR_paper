import pandas as pd
def parse_mic(mic):
    """parse mic"""
    m = pd.read_csv(mic, sep = '\t', index_col = 0)
    atb2short = {"Ciprofloxacin" : "CIP", "Ceftazidim" : "CAZ",  "Tobramycin" : "TOB" , "Meropenem" : "MEM"}
    short2atb = dict([(j, i) for i, j in atb2short.iteritems()])
    mode2short = {"EC" : "e", "CLSI" : "c"}
    drop_cols = m.columns[m.apply(lambda x: pd.isnull(x).all(), axis = 0)]
    #drop na columns
    m.drop(drop_cols, axis = 1, inplace = True)
    #drop na rows
    drop_rows = m.index[m.apply(lambda x: pd.isnull(x).all(), axis = 1)]
    m.drop(drop_rows, axis = 0, inplace = True)
    #get mic values
    mic_cols = [drug for drug in short2atb] 
    for mode in "EC", "CLSI":
        resp_cols = ["%s_%s" %(drug, mode2short[mode]) for drug in short2atb] 
        print(m)
        response = m.loc[:, resp_cols]
        response.columns = [short2atb[i.split("_")[0]] for i in response.columns] 
        #if mode == "CLSI":
        configs = ("S-vs-R", "SI-vs-R", "S-vs-IR", "S-vs-I", "I-vs-R", "I-vs-SR")
        codings = ((0, float('nan'), 1),
            (0, 0, 1),
            (0, 1, 1),
            (0, 1, float('nan')),
            (float('nan'), 0, 1),
            (1, 0, 1)) 
        #else:
        #    configs = (["S-vs-R"])
        #    codings = ((1, 0, 1)) 
        config2coding = dict(zip(configs, codings))
        pheno_m = pd.DataFrame(pd.np.zeros((response.shape[0], len(configs) * len(response.columns))))
        pheno_m.index = response.index
        pheno_m.columns = ["%s_%s" % (atb, config) for config in configs for atb in response.columns]
        for config in configs:
            for drug in response.columns:
                pheno_m.loc[:, "%s_%s" % (drug, config)]  = response.loc[:, drug].replace(["S", "I", "R"], config2coding[config])
        pheno_m.to_csv("pheno_table_%s.txt" % mode, sep = "\t")
        #res/susc statistics
        #bin_response_without_intermediate.fillna("2", inplace = True)
        response = response.replace(["S", "I", "R"], [0, 1, 2])
        stats = response.apply(pd.Series.value_counts)
        print stats
        stats.index = ["susceptible", "intermediate resistant", "resistant"]
        stats.to_csv("resistance_statistics_%s.txt" % mode, sep = "\t")

from traitar.traitar_from_archive import call_traitar 

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("MIC parser")
    parser.add_argument("mic", help='mic table')
    args = parser.parse_args()
    parse_mic(args.mic)
