import os
import csv
import pandas as pd
import math
import sys


def putValue(dataset, phen_id, value):
	if(phen_id in dataset):
		dataset[phen_id] += value
	else:
		dataset[phen_id] = value

def main(arg):
	directory = arg
	prog = 0
	prev = None
	s = 0
	finalDataSet = None
	for filename in os.listdir(directory):
		helper = directory + "/" + filename
		fname = filename.split("_")[1]
		dataset = None
		for file_ in os.listdir(helper):
			if(file_ == "abundance.tsv"):
				helper += "/" + file_
				counter = 0
				with open(helper) as fd:
					rd = csv.reader(fd, delimiter = "\t", quotechar = '"')
					for row in rd:
						if(counter == 0):
							counter += 1
							continue
						phen_id = row[0].split("|")[1].split(".")[0]
						if(dataset == None):
							dataset = {phen_id: float(row[-1])}
						else:
							putValue(dataset, phen_id, float(row[-1]))
		if(finalDataSet == None):
			finalDataSet = {"phenotype_id": list(dataset.keys())}
			helper = []
			for value in dataset:
				helper.append(math.log2(dataset[value]+1))
			finalDataSet[fname] = helper
		else:
			helper = []
			for value in dataset:
				 helper.append(math.log2(dataset[value]+1))
			finalDataSet[fname] = helper
		#if(s == 1):
			#break
		#s+=1

	#print(len(dataset['ERR188022']))
	df = pd.DataFrame(finalDataSet, columns = list(finalDataSet.keys()))
	df.to_csv('out.tsv', index = False, sep = "\t")

if __name__ == "__main__":
	main(sys.argv[-1])
