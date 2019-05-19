import pandas as pd
#color brewer
#colors = ["#1f78b4", "#33a02c", "#e31a1c", "#ff7f00", "#6a3d9a", "#ffff99", "#b15928", "#a6cee3", "#b2df8a", "#fb9a99", "#fdbf6f", "#cab2d6"]
#kelly + black and white + first three color brewer
colors = ["#3cb44b",
        "#ffe119",
        "#0082c8",
        "#f58231",
        "#911eb4",
        "#46f0f0",
        "#f032e6",
        "#d2f53c",
        "#fabebe",
        "#008080",
        "#e6beff",
        "#aa6e28",
        "#fffac8",
        "#800000",
        "#aaffc3",
        "#808000",
        "#ffd8b1",
        "#000080",
        "#808080",
        "#FFFFFF",
        "#000000",
        ]

def prepare_annot(annots, out_annot_table, out_annot, labels):
    """generate graphlan annotation"""
    annot_table = pd.DataFrame()
    #merge individual annotation tables
    for annot_f in annots:
        annot_table_temp = pd.read_csv(annot_f, sep = "\t", index_col = 0)
        annot_table = pd.concat([annot_table, annot_table_temp], axis = 1)
    #replace nan with 0
    #annot_table[pd.isnull(annot_table)] = 0
    annot_table.to_csv(out_annot_table, sep = "\t")
    dtypes =  annot_table.apply(lambda x: pd.np.any(pd.notnull(x) & (x != 0.0) & (x != 1.0) & (x != 0.5)))
    with open(out_annot, 'w') as out:
        out.write("start_rotation\t270\n")
        out.write("total_plotted_degrees\t320\n")
        out.write("clade_marker_size\t5\n")
        out.write("susceptible\tclade_marker_color\tgreen\n")
        out.write("intermediate resistant\tclade_marker_color\tpink\n")
        out.write("resistant\tclade_marker_color\tred\n")
        for annot_name, i in zip(annot_table.columns, range(annot_table.shape[1])):
            out.write("ring_label\t%s\t%s\n" % (i+1, labels[i]))
            out.write("ring_internal_separator_thickness\t%s\t%s\n" % (i+1, 1.0))
            #test if categorical
            if annot_table.loc[:, annot_name].dtype == 'object':
                unique_vals = list(set(filter(lambda j: pd.notnull(j) and "+" not in j and str(j) != "0", annot_table.loc[:, annot_name])))
                val2col = dict([(unique_vals[j], colors[j]) for j in range(len(unique_vals))])
                for val in val2col:
                    out.write("%s\tclade_marker_color\t%s\n" % (val, val2col[val]))
                for j in annot_table.loc[:,annot_name]:
                    if pd.notnull(j) and j not in unique_vals and j != "0":
                        val2col[j] = colors[len(unique_vals)]
                out.write("Multiple beta-lactamases\tclade_marker_color\t%s\n" % colors[len(unique_vals)])
                val2col["0"] = colors[len(unique_vals) + 1]
                print val2col
                for sample in annot_table.index:
                    val = annot_table.loc[sample, annot_name]
                    if pd.notnull(val):
                        if val != "0":
                            out.write("%s\tring_alpha\t%s\t%s\n" % (sample, i+1, 1))
                            out.write("%s\tring_color\t%s\t%s\n" % (sample, i+1, val2col[val]))
                
            else:
                for sample in annot_table.index:
                    if annot_table.loc[sample, annot_name] == 1:
                        color = "red"
                    elif annot_table.loc[sample, annot_name] == 0:
                        color = "green"
                    else:
                        color = "pink"
                    out.write("%s\tring_color\t%s\t%s\n" % (sample, i+1, color))
                    out.write("%s\tring_alpha\t%s\t%s\n" % (sample, i+1, 1))
                    #if dtypes[i]:
                    #    if pd.notnull(annot_table.loc[sample, annot_name]):
                    #        out.write("%s\tring_height\t%s\t%s\n" % (sample, i+1, annot_table.loc[sample, annot_name]))
                    #    else:
                    #        out.write("%s\tring_color\t%s\t%s\n" % (sample, i+1, 'grey'))
                    #else:
                    #    if pd.notnull(annot_table.loc[sample, annot_name]):
                    #        out.write("%s\tring_alpha\t%s\t%s\n" % (sample, i+1, annot_table.loc[sample, annot_name]))
                    #    else:
                    #        out.write("%s\tring_alpha\t%s\t%s\n" % (sample, i+1, 1))
                    #        out.write("%s\tring_color\t%s\t%s\n" % (sample, i+1, 'grey'))
        

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("read in annotation table and generate input for graphlan tree plotter")
    parser.add_argument("out_annot", help="output graphlan annotation")
    parser.add_argument("out_annot_table", help="output annotation as table ")
    parser.add_argument("--annots", nargs = "*", help="annotation_tables")
    parser.add_argument("--labels", nargs = "*", help="names for the rings")
    args = parser.parse_args()
    prepare_annot(**vars(args))
