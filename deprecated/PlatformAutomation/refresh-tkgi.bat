
fly -t core login -c https://concourse.caas.pez.pivotal.io -u myuser -p mypass -n platauto -k


SET PL=DEPLOY-TKGI
REM fly -t core dp -p %PL%
fly -t core sp -p %PL% -c pipelines/pks-pipeline-noharbor.yml -l pipelines/params-caas-tkgi.yml
fly -t core up -p %PL%

SET PL=UPGRADE-TKGI
REM fly -t core dp -p %PL%
fly -t core sp -p %PL% -c pipelines/upgrade-pks-pipeline-noharbor.yml -l pipelines/params-caas-tkgi.yml
fly -t core up -p %PL%

SET PL=RETRIEVE-TKGI
REM fly -t core dp -p %PL%
fly -t core sp -p %PL% -c pipelines/retrieve-pks-schedule.yml -l pipelines/params-caas-tkgi.yml
fly -t core up -p %PL%

SET PL=tkgi-clusters
REM fly -t core dp -p %PL%
fly -t core sp -p %PL% -c pipelines/defineclusters-pipeline.yml -l pipelines/params-caas-tkgi.yml
fly -t core up -p %PL%
