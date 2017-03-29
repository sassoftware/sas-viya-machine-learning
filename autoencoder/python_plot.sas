
/*python script to plot mnist handwriting in score dataset*/
import matplotlib
import pylab as pl
import numpy as np

f = open("mnist_train_10_autoencoder_score.csv", 'r')
a = f.readlines()
f.close()

f = pl.figure(figsize=(15,15));
count=1
for line in a:
    linebits = line.split(',')
    imarray = np.asfarray(linebits[1:]).reshape((28,28))
    pl.subplot(5,5,count)
    pl.subplots_adjust(hspace=0.5)
    count += 1
    pl.title("Label is " + linebits[0])
    pl.imshow(imarray, cmap='Greys', interpolation='None')
    pass

pl.show()  