#from hierarquica.fusao_hierarquica_aglomerativa_minibatch import run_hier_agglomerative
#from hierarquica.fusao_hierarquica_birch import run_hier_birch
#from hierarquica.fusao_hierarquica_Fastcluster_with_scipy import run_hier_fastcluster
#from hierarquica.fusao_hierarquica_hdbscan import run_hier_hdbscan
#from hierarquica.fusao_hierarquica_kmeans import run_hier_kmeans

#from temporal.fusao_temporal_arima_exponencial_sktime import run_temp_sk_arima_ex
#from temporal.fusao_temporal_arima_exponential_statsmodels import run_temp_stats_arima_ex
#from temporal.fusao_temporal_arima_sktime import run_temp_sk_arima
#from temporal.fusao_temporal_arima_statsmodels import run_temp_stats_arima
#from temporal.fusao_temporal_prophet import run_temp_prophet
from temporal.fusao_temporal_sarima_exponential_sktime import run_temp_sk_sarima_ex
#from temporal.fusao_temporal_sarima_exponential_statsmodels import run_temp_stats_sarima_ex
from temporal.fusao_temporal_sarima_sktime import run_temp_sk_sarima
#from temporal.fusao_temporal_sarima_statsmodels import run_temp_stats_sarima
#from temporal.fusao_temporal_Tslearn_KMeans import run_temp_ts_kmeans


#run_hier_agglomerative()
#run_hier_birch()
#run_hier_fastcluster()
#run_hier_hdbscan()
#run_hier_kmeans()

print('''
      
      
      ++++++++++Acabou hierarquicos+++++++++
      
      
      ''')

##run_temp_sk_arima_ex()
##run_temp_stats_arima_ex()
##run_temp_sk_arima()
##run_temp_stats_arima()
##run_temp_prophet()
##run_temp_sk_sarima_ex()
##run_temp_stats_sarima_ex()
run_temp_sk_sarima()
#run_temp_stats_sarima()
##run_temp_ts_kmeans()

print('''
      
      
      ++++++++++Acabou temporal+++++++++
      
      
      ''')