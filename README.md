# NeuropixelsRegistration
 Motion estimation and registration of Neuropixels data.
 
 Small modifications to python version and added demo notebook
 To get motion estimates, run python/demo_registration
 
 Input:
 Recording file (.bin),
 Channel map (.mat),
 
 Output:
 Motion estimates
 Interpolated registered data (.bin)


 I opted to save the registered data as int16 (same as input format).


Summary of the approach:
![Demo](https://github.com/evarol/NeuropixelsRegistration/blob/master/fig1.png)

Comparison with Kilosort 2.5:
![Demo](https://github.com/evarol/NeuropixelsRegistration/blob/master/raster_icassp-1.png)
Data used in this figure is provided by International Brain Laboratory (public link: TBA).

<!-- http://internationalbrainlab.org/data/2021-02-12_Varol -->


Reference:

Erdem Varol, Julien Boussard, Nishchal Dethe, Olivier Winter, Anne Urai, The International Brain Laboratory, Anne Churchland, Nick Steinmetz, Liam Paninski. Decentralized motion inference and registration of Neuropixels data. In ICASSP 2021 (To appear).