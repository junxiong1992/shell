#!/bin/bash
#function:cut nginx log files

log_files_path="/data/logs/nginx/"
log_files_dir="/data/logs/nginx/logs_front/"
log_files_name=("mytoken.internalapi.access.log" "mytoken.exchangedataapi.access.log" )
save_days=7

mkdir -p $log_files_dir
log_files_num=${#log_files_name[@]}

#cut nginx log files
for((i=0;i<$log_files_num;i++));do
mv ${log_files_path}${log_files_name[i]} ${log_files_dir}${log_files_name[i]}.$(date -d "yesterday" +"%Y-%m-%d")
done

#delete 30 days ago nginx log files
find $log_files_path -mtime +$save_days -exec rm -rf {} \;

#restart nginx
supervisorctl restart nginx